
#include "HartreeFock.hh"
#include "ModelSpace.hh"
#include "PhysicalConstants.hh"
#include <iomanip>
#include <vector>
#include <array>
#include <map>
#include <utility> // for make_pair
#include "gsl/gsl_sf_gamma.h" // for radial wave function
#include "gsl/gsl_sf_laguerre.h" // for radial wave function
//#include <gsl/gsl_math.h> // for M_SQRTPI
#include <omp.h>

//#ifndef SQRT2
//  #define SQRT2 1.4142135623730950488
//#endif
//#define HBARC 197.3269718 // hc in MeV * fm
//#define M_NUCLEON 938.9185 // average nucleon mass in MeV


//using namespace std;

HartreeFock::HartreeFock(Operator& hbare)
  : Hbare(hbare), modelspace(hbare.GetModelSpace()), 
    KE(Hbare.OneBody), energies(Hbare.OneBody.diag()),
    tolerance(1e-8), convergence_ediff(7,0), convergence_EHF(7,0), freeze_occupations(true)
{
   int norbits = modelspace->GetNumberOrbits();

   C             = arma::mat(norbits,norbits,arma::fill::eye);
   Vij           = arma::mat(norbits,norbits,arma::fill::zeros);
   V3ij          = arma::mat(norbits,norbits,arma::fill::zeros);
   F             = arma::mat(norbits,norbits);
   for (int Tz=-1;Tz<=1;++Tz)
   {
     for (int parity=0; parity<=1; ++parity)
     {
       int nKetsMon = modelspace->MonopoleKets[Tz+1][parity].size();
       Vmon[Tz+1][parity] = arma::mat(nKetsMon,nKetsMon);
       Vmon_exch[Tz+1][parity] = arma::mat(nKetsMon,nKetsMon);
     }
   }
   prev_energies = arma::vec(norbits,arma::fill::zeros);
   std::vector<double> occvec;
   for (auto& h : modelspace->holes) occvec.push_back(modelspace->GetOrbit(h).occ);
//   holeorbs = arma::uvec(modelspace->holes);
   holeorbs = arma::uvec( std::vector<index_t>(modelspace->holes.begin(),modelspace->holes.end()));
   hole_occ = arma::rowvec(occvec);
   BuildMonopoleV();
   if (hbare.GetParticleRank()>2)
   {
      BuildMonopoleV3();
   }
   UpdateDensityMatrix();
   UpdateF();
   std::cout << "Vij" << std::endl << Vij << std::endl;

}


//*********************************************************************
/// Diagonalize and update the Fock matrix until convergence.
/// Then, call ReorderCoefficients() to make sure the index
/// ordering and phases are preserved in the transformation
/// from the original basis to the Hatree-Fock basis.
//*********************************************************************
void HartreeFock::Solve()
{
   double t_start = omp_get_wtime();
   iterations = 0; // counter so we don't go on forever
   int maxiter = 1000;

   for (iterations=0; iterations<maxiter; ++iterations)
   {
      Diagonalize();          // Diagonalize the Fock matrix
      ReorderCoefficients();  // Reorder columns of C so we can properly identify the hole orbits.
      if (not freeze_occupations) FillLowestOrbits(); // if we don't freeze the occupations, then calculate the new ones.
      UpdateDensityMatrix();  // Update the 1 body density matrix, used in UpdateF()
      UpdateF();              // Update the Fock matrix

      if ( CheckConvergence() ) break;
   }
   CalcEHF();

   std::cout << std::setw(15) << std::setprecision(10);
   if (iterations < maxiter)
   {
      std::cout << "HF converged after " << iterations << " iterations. " << std::endl;
   }
   else
   {
      std::cout << "!!!! Warning: Hartree-Fock calculation didn't converge after " << iterations << " iterations." << std::endl;
      std::cout << "!!!! Last " << convergence_ediff.size() << " points in convergence check:";
      for (auto& x : convergence_ediff ) std::cout << x << " ";
      std::cout << "  (tolerance = " << tolerance << ")" << std::endl;
      std::cout << "!!!! Last " << convergence_EHF.size() << "  EHF values: ";
      for (auto& x : convergence_EHF ) std::cout << x << " ";
      std::cout << std::endl;
   }
   UpdateReference();
   PrintEHF();
   profiler.timer["HF_Solve"] += omp_get_wtime() - t_start;
}


//*********************************************************************
/// Calculate the HF energy.
/// \f{eqnarray*} E_{HF} &=& \sum_{\alpha} t_{\alpha\alpha} 
///                    + \frac{1}{2}\sum_{\alpha\beta} V_{\alpha\beta\alpha\beta}
///                    + \frac{1}{6}\sum_{\alpha\beta\gamma} V_{\alpha\beta\gamma\alpha\beta\gamma} \\
///    &=& \sum_{ij} (2j_i+1) \rho_{ij} ( t_{ij} +\frac{1}{2}\tilde{V}^{(2)}_{ij} + \frac{1}{6}\tilde{V}^{(3)}_{ij} )
/// \f}
/// Where the matrices \f{eqnarray*}
///  \tilde{V}^{(2)}_{ij} &=& \sum_{ab} \rho_{ab}\bar{V}^{(2)}_{iajb} \\
///  \tilde{V}^{(3)}_{ij} &=& \sum_{abcd} \rho_{ab}\rho_{cd} \bar{V}^{(3)}_{iacjbd} \\
/// \f}
/// have already been calculated by UpdateF().
//*********************************************************************
void HartreeFock::CalcEHF()
{
   EHF = 0;
   e1hf = 0;
   e2hf = 0;
   e3hf = 0;
//   int norbits = modelspace->GetNumberOrbits();
//   for (int i=0;i<norbits;i++)
   for (auto i : modelspace->all_orbits )
   {
      Orbit& oi = modelspace->GetOrbit(i);
      int jfactor = oi.j2 +1;
      for (int j : Hbare.OneBodyChannels.at({oi.l,oi.j2,oi.tz2}))
      {
         e1hf += rho(i,j) * jfactor * KE(i,j);
         e2hf += rho(i,j) * jfactor * 0.5 * Vij(i,j);
         e3hf += rho(i,j) * jfactor * (1./6)*V3ij(i,j);
      }
   }
   EHF = e1hf + e2hf + e3hf;
}

//**************************************************************************************
/// Print out the Hartree Fock energy, and the 1-, 2-, and 3-body contributions to it.
//**************************************************************************************
void HartreeFock::PrintEHF()
{
   std::cout << std::fixed <<  std::setprecision(7);
   std::cout << "e1hf = " << e1hf << std::endl;
   std::cout << "e2hf = " << e2hf << std::endl;
   std::cout << "e3hf = " << e3hf << std::endl;
   std::cout << "EHF = "  << EHF  << std::endl;
}

//*********************************************************************
/// [See Suhonen eq. 4.85]
/// Diagonalize the fock matrix \f$ <a|F|b> \f$ and put the
/// eigenvectors in \f$C(i,\alpha) = <i|\alpha> \f$
/// and eigenvalues in the vector energies.
/// Save the last vector of energies to check
/// for convergence.
/// Submatrices corresponding to different channels are diagonalized independently.
/// This guarantees that J,Tz, and \f$ \pi \f$ remain good. 
//*********************************************************************
void HartreeFock::Diagonalize()
{
   prev_energies = energies;
   for ( auto& it : Hbare.OneBodyChannels )
   {
//      arma::uvec orbvec(it.second);
      arma::uvec orbvec(std::vector<index_t>(it.second.begin(),it.second.end()) ); // convert std::set to std::vector, and convert that to arma::uvec...
      arma::mat F_ch = F.submat(orbvec,orbvec);
      arma::mat C_ch;
      arma::vec E_ch;
      bool success = false;
      int diag_tries = 0;
      while ( not success)
      {
         success = arma::eig_sym(E_ch, C_ch, F_ch);
         ++diag_tries;
         if (diag_tries > 5)
         {
           std::cout << "Hartree-Fock: Failed to diagonalize the submatrix " 
                << " on iteration # " << iterations << ". The submatrix looks like:" << std::endl;
           F_ch.print();
           break;
         }
      }
      // Update the full overlap matrix C and energy vector
      energies(orbvec) = E_ch;
      C.submat(orbvec,orbvec) = C_ch;

   }
}


//*********************************************************************
/// Construct an unnormalized two-body monopole interaction
/// \f[ \langle ab | \bar{V}^{(2)} | cd \rangle 
///   = \sqrt{(1+\delta_{ab})(1+\delta_{cd})} \sum_{J} (2J+1) \langle ab | V^{(2)} | cd \rangle_{J} \f]
/// This method utilizes the operator method  TwoBodyME::GetTBMEmonopole() 
///
//*********************************************************************
void HartreeFock::BuildMonopoleV()
{
   for (int Tz=-1; Tz<=1; ++Tz)
   {
     for (int parity=0; parity<=1; ++parity)
     {
        Vmon[Tz+1][parity].zeros();
        Vmon_exch[Tz+1][parity].zeros();
        for ( auto& itbra : modelspace->MonopoleKets[Tz+1][parity] )
        {
           Ket & bra = modelspace->GetKet(itbra.first);
           int a = bra.p;
           int b = bra.q;
           Orbit & oa = modelspace->GetOrbit(a);
           Orbit & ob = modelspace->GetOrbit(b);
           double norm = (oa.j2+1)*(ob.j2+1);
           for ( auto& itket : modelspace->MonopoleKets[Tz+1][parity] )
           {
              if (itket.second < itbra.second) continue;
              Ket & ket = modelspace->GetKet(itket.first);
              int c = ket.p;
              int d = ket.q;
              Vmon[Tz+1][parity](itbra.second,itket.second)       = Hbare.TwoBody.GetTBMEmonopole(a,b,c,d)*norm;
              Vmon_exch[Tz+1][parity](itbra.second,itket.second)  = Hbare.TwoBody.GetTBMEmonopole(a,b,d,c)*norm;
           }
        }
        Vmon[Tz+1][parity] = arma::symmatu(Vmon[Tz+1][parity]);
        Vmon_exch[Tz+1][parity] = arma::symmatu(Vmon_exch[Tz+1][parity]);
    }
  }
}



/// Set up the keys for the 3-body monopole terms
/// We do this separately because it's fast (so it doesn't need to be parallel)
/// and because it's the same whether we use lab frame 3N or jacobi 3N.
void HartreeFock::SetUpMonopoleV3Keys()
{
   double start_time = omp_get_wtime();
  // First, allocate. This is fast so don't parallelize.
//  size_t norbits = modelspace->GetNumberOrbits();
//  for (uint64_t i=0; i<norbits; ++i)
  for ( auto i : modelspace->all_orbits)
  {
    Orbit& oi = modelspace->GetOrbit(i);
    int ei = 2*oi.n + oi.l;
    for (uint64_t j : Hbare.OneBodyChannels.at({oi.l,oi.j2,oi.tz2}) )
    {
      if (j<i) continue;
      Orbit& oj = modelspace->GetOrbit(j);
      int ej = 2*oj.n + oj.l;

//      for (uint64_t a=0; a<norbits; ++a)
      for (auto a : modelspace->all_orbits)
      {
        Orbit& oa = modelspace->GetOrbit(a);
        int ea = 2*oa.n + oa.l;
        for (uint64_t b : Hbare.OneBodyChannels.at({oa.l,oa.j2,oa.tz2}) )
        {
          Orbit& ob = modelspace->GetOrbit(b);
          int eb = 2*ob.n + ob.l;
     
//            for (uint64_t c=0; c<norbits; ++c)
            for ( auto c : modelspace->all_orbits)
            {
              Orbit& oc = modelspace->GetOrbit(c);
              int ec = 2*oc.n + oc.l;
              if ( ea+ec+ei > Hbare.E3max ) continue;
              for (uint64_t d : Hbare.OneBodyChannels.at({oc.l,oc.j2,oc.tz2}) )
              {
                Orbit& od = modelspace->GetOrbit(d);
                int ed = 2*od.n + od.l;
 
                if ( eb+ed+ej > Hbare.E3max ) continue;
                if ( (oi.l+oa.l+ob.l+oj.l+oc.l+od.l)%2 >0) continue;
                  uint64_t key = Vmon3Hash(a,c,i,b,d,j);
                  Vmon3_keys.push_back( key );
              }
            }
          }
        }
      }
    }

   profiler.timer[std::string(__func__)] += omp_get_wtime() - start_time;

}


//*********************************************************************
/// Construct an unnormalized three-body monopole interaction
/// \f[ \langle iab | \bar{V}^{(3)} | jcd \rangle =
///     \sum\limits_{J,J_{12}}\sum_{Tt_{12}}(2J+1)(2T+1) 
///       \langle (ia)J_{12}t_{12};b JT| V^{(3)} | (jc)J_{12}t_{12}; d JT\rangle
/// \f]
//*********************************************************************
void HartreeFock::BuildMonopoleV3()
{

   SetUpMonopoleV3Keys();
   double start_time = omp_get_wtime();
/*
  // First, allocate. This is fast so don't parallelize.
//  size_t norbits = modelspace->GetNumberOrbits();
//  for (uint64_t i=0; i<norbits; ++i)
  for ( auto i : modelspace->all_orbits)
  {
    Orbit& oi = modelspace->GetOrbit(i);
    int ei = 2*oi.n + oi.l;
    for (uint64_t j : Hbare.OneBodyChannels.at({oi.l,oi.j2,oi.tz2}) )
    {
      if (j<i) continue;
      Orbit& oj = modelspace->GetOrbit(j);
      int ej = 2*oj.n + oj.l;

//      for (uint64_t a=0; a<norbits; ++a)
      for (auto a : modelspace->all_orbits)
      {
        Orbit& oa = modelspace->GetOrbit(a);
        int ea = 2*oa.n + oa.l;
        for (uint64_t b : Hbare.OneBodyChannels.at({oa.l,oa.j2,oa.tz2}) )
        {
          Orbit& ob = modelspace->GetOrbit(b);
          int eb = 2*ob.n + ob.l;
     
//            for (uint64_t c=0; c<norbits; ++c)
            for ( auto c : modelspace->all_orbits)
            {
              Orbit& oc = modelspace->GetOrbit(c);
              int ec = 2*oc.n + oc.l;
              if ( ea+ec+ei > Hbare.E3max ) continue;
              for (uint64_t d : Hbare.OneBodyChannels.at({oc.l,oc.j2,oc.tz2}) )
              {
                Orbit& od = modelspace->GetOrbit(d);
                int ed = 2*od.n + od.l;
 
                if ( eb+ed+ej > Hbare.E3max ) continue;
                if ( (oi.l+oa.l+ob.l+oj.l+oc.l+od.l)%2 >0) continue;
                  uint64_t key = Vmon3Hash(a,c,i,b,d,j);
                  Vmon3_keys.push_back( key );
              }
            }
          }
        }
      }
    }
*/
   
   Vmon3.resize( Vmon3_keys.size(), 0. );
   profiler.timer["HF_BuildMonopoleV3_allocate"] += omp_get_wtime() - start_time;

   #pragma omp parallel for schedule(dynamic,1) 
   for (size_t ind=0; ind<Vmon3.size(); ++ind)
   {
      double v=0;
      int a,b,c,d,i,j;
      Vmon3UnHash( Vmon3_keys[ind], a,c,i,b,d,j);

      int j2a = modelspace->GetOrbit(a).j2;
      int j2c = modelspace->GetOrbit(c).j2;
      int j2i = modelspace->GetOrbit(i).j2;
      int j2b = modelspace->GetOrbit(b).j2;  // this seems unnecessary
      int j2d = modelspace->GetOrbit(d).j2;  // this seems unnecessary
      int j2j = modelspace->GetOrbit(j).j2;  // this seems unnecessary
 
      // TODO: We can probably use some permutation symmetries to avoid recomputing things
      // at the very least, we can treat the permutation of the first two indices
      int j2min = std::max( std::abs(j2a-j2c), std::abs(j2b-j2d) )/2;
      int j2max = std::min( j2a+j2c, j2b+j2d )/2;
      for (int j2=j2min; j2<=j2max; ++j2)
      {
        int Jmin = std::max( std::abs(2*j2-j2i), std::abs(2*j2-j2j) );
        int Jmax = 2*j2 + std::min(j2i, j2j);
        for (int J2=Jmin; J2<=Jmax; J2+=2)
        {
           v += Hbare.ThreeBody.GetME_pn(j2,j2,J2,a,c,i,b,d,j) * (J2+1);
        }
      }
      v /= j2i+1.0;
      #pragma omp atomic write
      Vmon3[ind] = v ;
//      std::cout << " MONOPOLE: " << a << " " << c << " " << i << " " << b << " " << d << " " << j << "  " << v << std::endl;
   }
   std::cout << "HartreeFock::BuildMonopoleV3  storing " << Vmon3.size() << " doubles for Vmon3 and "
             << Vmon3_keys.size() << " uint64's for Vmon3_keys." << std::endl;

//   profiler.timer["HF_BuildMonopoleV3"] += omp_get_wtime() - start_time;
   profiler.timer[std::string(__func__)] += omp_get_wtime() - start_time;
}



//*********************************************************************
/// Construct the V3 monopole matrix elements directly from the jacobi matrix elements.
/// So far this is completely untested and certainly wrong.
//*********************************************************************
void HartreeFock::BuildMonopoleV3Jacobi()
{
   SetUpMonopoleV3Keys();
   double start_time = omp_get_wtime();
   Vmon3.resize( Vmon3_keys.size(), 0. );

   for ( auto& obc_a : Hbare.OneBodyChannels )
   {
//     uint64_t a0 = *(obc_a.second.begin()); // access the first element in the set
//     uint64_t a0 = obc_a.second[0];
     int j2a = obc_a.first[1];
     for ( auto& obc_b : Hbare.OneBodyChannels )
     {
//       uint64_t b0 = obc_b.second[0];
//       uint64_t b0 = *(obc_b.second.begin());// access the first element in the set
       int j2b = obc_b.first[1];
       int Jab_min = std::abs( j2a-j2b )/2;
       int Jab_max = ( j2a+j2b )/2;
       for ( auto& obc_c : Hbare.OneBodyChannels )
       {
//         uint64_t c0 = *(obc_c.second.begin());// access the first element in the set
//         uint64_t c0 = obc_c.second[0];
         int j2c = obc_c.first[1];

         // Now we compute the relevalt T coefficients
         // These are only a small subset, and we discard them after use
         // so that the storage doesn't kill us. 
         // The T coefficents int this sub-block can be labeled by: na,nb,nc, Jab, twoJ, E12, alpha, Ncm, Lcm
         std::unordered_map<size_t,double> Ttable;
         // We'll need one loop to allocate (not thread-safe), one loop to compute the Tcoefficients (can be parallel), and one to compute V3mon (also parallel).
         // first, allocate
         for ( int Jab=Jab_min; Jab<=Jab_max; Jab++)
         {
           int twoJ_min = std::abs(2*Jab-j2c);
           int twoJ_max = (2*Jab-j2c);
           for (int twoJ=twoJ_min; twoJ<=twoJ_max; twoJ+=2)
           {
            for (auto a : obc_a.second )
            {
             Orbit& oa = modelspace->GetOrbit(a);
             for (auto b : obc_b.second )
             {
              Orbit& ob = modelspace->GetOrbit(b);
              for (auto c : obc_c.second )
              {
               Orbit& oc = modelspace->GetOrbit(c);
               int Eabc = 2*(oa.n+ob.n+oc.n)+(oa.l+ob.l+oc.l);
               int Lcm_max = std::min(oa.l+ob.l+oc.l, Eabc);
               for (int Lcm=0; Lcm<=Lcm_max; Lcm++)
               {
                for ( int Ncm=0; 2*Ncm<=Eabc-Lcm; Ncm++)
                {
                  int E12 = Eabc - 2*Ncm - Lcm;
                  // TODO: Here's the tricky bit because of the isospin
                  int twoT = 1;
                  int alpha_dim = jacobi3bme->GetDimensionNAS( twoT, twoJ, E12%2, E12 );
                  for ( int alpha=0; alpha<alpha_dim; alpha++)
                  {
                    auto key = Vmon3JacobiHash(oa.n,ob.n,oc.n,Jab,twoJ,E12,alpha,Ncm,Lcm);
                    Ttable[ key ] = 0; // make sure there's somewhere to put the value when we calculate it.
                  } // for alpha
                } // for Ncm
               } // for Lcm
              } // for c
             } // for b
            } // for a
           } // for twoJ
         } // for Jab
         // Now the heavy lifting of computing the T coefficients
         // make a vector of keys so we can loop it in parallel
         std::vector<size_t> keyvector;
         keyvector.reserve( Ttable.size() );
         for ( auto& iter : Ttable ) keyvector.push_back(iter.first);
// parallelize here...
//         #pragma omp parallel for schedule(dynamic, 1)
         for (size_t ikey=0; ikey<keyvector.size(); ikey++)
         {
           auto key = keyvector[ikey];
           uint64_t na,nb,nc,Jab,twoJ,E12,alpha,Ncm,Lcm;
           Vmon3JacobiUnHash(key, na,nb,nc,Jab,twoJ,E12,alpha,Ncm,Lcm);
           jacobi1_state jac1;
           jacobi2_state jac2;
           int twoT = 1; // TODO: This is nonsense. Fix it.
           jacobi3bme->GetJacobiStates( twoT, twoJ, E12%2, E12, alpha, jac1, jac2);
           Orbit& oa = modelspace->GetOrbit( modelspace->GetOrbitIndex(na,obc_a.first[0],obc_a.first[1],obc_a.first[2]) );
           Orbit& ob = modelspace->GetOrbit( modelspace->GetOrbitIndex(nb,obc_b.first[0],obc_b.first[1],obc_b.first[2]) );
           Orbit& oc = modelspace->GetOrbit( modelspace->GetOrbitIndex(nc,obc_c.first[0],obc_c.first[1],obc_c.first[2]) );
           Ket3 ket3(oa,ob,oc);
           double Tcoef = jacobi3bme->Tcoeff_wrapper( ket3, Jab, twoJ, jac1, jac2, twoJ, Ncm, Lcm);
           Ttable[key] = Tcoef;
         }// for ikey
         // and now that we have all the relevant T coefficients computed, let's get all the 3-body monopole terms
         // we can again parallelize here
//         size_t asize = obc_a.second.size();
//         for ( auto a : obc_a.second )
//         #pragma omp parallel for schedule(dynamic,1)
//         for ( size_t ia=0; ia<asize; ia++)  // do it this way because omp doesn't play nice with range-based for loops
         for ( auto a : obc_a.second )
         {
//           auto a = obc_a.second[ia];
           Orbit& oa = modelspace->GetOrbit(a);
           for (auto b : obc_b.second )
           {
             Orbit& ob = modelspace->GetOrbit(b);
             for (auto c : obc_c.second )
             {
               Orbit& oc = modelspace->GetOrbit(c);
               int Eabc = 2*(oa.n+ob.n+oc.n) + (oa.l+ob.l+oc.l);
               for (auto d : obc_a.second )
               {
                 Orbit& od = modelspace->GetOrbit(d);
                 for (auto e : obc_b.second )
                 {
                   Orbit& oe = modelspace->GetOrbit(e);
                   for (auto f : obc_c.second )
                   {
                     if ( f < c ) continue;
                     Orbit& of = modelspace->GetOrbit(f);
                     int Edef = 2*(od.n+oe.n+of.n) + (od.l+oe.l+of.l);
                     double vmon3 = 0;
                     for ( int Jab=Jab_min; Jab<=Jab_max; Jab++ )
                     {
                       int twoJ_min = std::abs(2*Jab-j2c);
                       int twoJ_max = (2*Jab-j2c);
                       for (int twoJ=twoJ_min; twoJ<=twoJ_max; twoJ+=2)
                       {
                         for ( int Ncm=0; 2*Ncm<=std::min(Eabc,Edef); Ncm++)
                         {
                           for (int Lcm=0; Lcm<=std::min(Eabc,Edef)-2*Ncm; Lcm+=2)
                           {
                             int E12_abc = Eabc - 2*Ncm - Lcm;
                             int E12_def = Edef - 2*Ncm - Lcm;
                             if ( (E12_abc + Eabc +Lcm)%2 >0) continue; // check parity
                             int twoT = 1;
                             size_t alpha_dim_abc = jacobi3bme->GetDimensionNAS( twoT, twoJ, E12_abc%2, E12_abc );
                             size_t alpha_dim_def = jacobi3bme->GetDimensionNAS( twoT, twoJ, E12_def%2, E12_def );
                             for ( size_t alpha_abc=0; alpha_abc<alpha_dim_abc; alpha_abc++)
                             {
                               auto key_abc = Vmon3JacobiHash(oa.n, ob.n, oc.n, Jab, twoJ,  E12_abc, alpha_abc, Ncm, Lcm);
                               double T_abc = Ttable[key_abc];
                               for ( size_t alpha_def=0; alpha_def<alpha_dim_def; alpha_def++)
                               {
                                 auto key_def = Vmon3JacobiHash(od.n, oe.n, of.n, Jab, twoJ,  E12_def, alpha_def, Ncm, Lcm);
                                 double T_def = Ttable[key_def];
                                 double me_jacobi_NAS = jacobi3bme->GetMatElNAS( alpha_abc, alpha_def, E12_abc, E12_def, twoJ, twoT, E12_abc%2);
                                 vmon3 += (twoJ+1) * T_abc * me_jacobi_NAS * T_def;
                               }
                             }
                           }
                         }
                       }
                     }
                     // Probably should think of a more clever way to do the lookup here
                     auto key = Vmon3Hash(a,b,c,d,e,f);
                     auto ptr = std::find(Vmon3_keys.begin(),Vmon3_keys.end(),key) ;
                     Vmon3[ ptr- Vmon3_keys.begin() ] = vmon3;
                   }
                 }
               }               
             }
           }
         }
       }// for obc_c
     }// for obc_b
   }// for obc_a

   profiler.timer[std::string(__func__)] += omp_get_wtime() - start_time;
}









//*********************************************************************
/// Hashing function for rolling six orbit indices into a single long unsigned int.
/// Each orbit gets 10 bits.
//*********************************************************************
uint64_t HartreeFock::Vmon3Hash(uint64_t a, uint64_t b, uint64_t c, uint64_t d, uint64_t e, uint64_t f)
{
  return a + (b<<10) + (c<<20) + (d<<30) + (e<<40) + (f<<50);
}


//*********************************************************************
/// Take a hashed key and extract the six orbit indices that went into it.
//*********************************************************************
//void HartreeFock::ParseVmon3HashKey(uint64_t key, int& a, int& b, int& c, int& d, int& e, int& f)
void HartreeFock::Vmon3UnHash(uint64_t key, int& a, int& b, int& c, int& d, int& e, int& f)
{
  a = (key    )&0x3FFL; // The L means long, and 0x3FF is 1's in the lowest 10 bits.
  b = (key>>10)&0x3FFL;
  c = (key>>20)&0x3FFL;
  d = (key>>30)&0x3FFL;
  e = (key>>40)&0x3FFL;
  f = (key>>50)&0x3FFL;
}




//*********************************************************************
/// Hashing function for rolling nine indices into a single long unsigned int.
/// Each n value get 5 bits, which means they should be less than 32 (emax=64, probably ok for the near future)
/// Jab gets 6 bits, twoJ gets 7 bits, Lcm gets 7 bits, Ncm gets 6 bits, E12 gets 7 bits
/// leaving 16 bits for alpha, which is hopefully (?) enough.
//*********************************************************************
uint64_t HartreeFock::Vmon3JacobiHash(uint64_t na, uint64_t nb, uint64_t nc, uint64_t Jab, uint64_t twoJ, uint64_t E12, uint64_t alpha, uint64_t Ncm, uint64_t Lcm)
{
   return (  alpha + (na<<16) + (nb<<21) + (nc<<26) + (Jab<<31) + ((twoJ/2)<<37) + (E12<<44) + (Ncm<<51) + (Lcm<<57) );
}

//*********************************************************************
/// Take a hashed key and extract the six orbit indices that went into it.
//*********************************************************************
void HartreeFock::Vmon3JacobiUnHash(uint64_t key, uint64_t& na, uint64_t& nb, uint64_t& nc, uint64_t& Jab, uint64_t& twoJ, uint64_t& E12, uint64_t& alpha, uint64_t& Ncm, uint64_t& Lcm)
{
   alpha = (key    )&0xFFFF; // 16 bits
   na    = (key>>16)&0x1F;   // 5 bits
   nb    = (key>>21)&0x1F;   // 5 bits
   nc    = (key>>26)&0x1F;   // 5 bits
   Jab   = (key>>31)&0x3F;   // 6 bits
   twoJ  = (key>>37)&0x7F;   // 7 bits
   E12   = (key>>44)&0x7F;   // 7 bits
   Ncm   = (key>>51)&0x3F;   // 6 bits
   Lcm   = (key>>57)&0x7F;   // 7 bits
}




//*********************************************************************
/// one-body density matrix 
/// \f$ <i|\rho|j> = \sum\limits_{\beta} n_{\beta} <i|\beta> <\beta|j> \f$
/// where \f$n_{\beta} \f$ ensures that beta runs over HF orbits in
/// the core (i.e. below the fermi surface)
//*********************************************************************
void HartreeFock::UpdateDensityMatrix()
{
  arma::mat tmp = C.cols(holeorbs);
  rho = (tmp.each_row() % hole_occ) * tmp.t();
}



//********************************************************************
/// Get new occupation numbers by filling the orbits in order of their
/// single-particle energies. The last proton/neutron orbit can have
/// a fractional filling, corresponding to ensemble normal ordering.
//********************************************************************
void HartreeFock::FillLowestOrbits()
{
  // vector of indices such that they point to elements of F(i,i)
  // in ascending order of energy
  arma::uvec sorted_indices = arma::stable_sort_index( F.diag() );
  int targetZ = modelspace->GetZref();
  int targetN = modelspace->GetAref() - targetZ;
  int placedZ = 0;
  int placedN = 0;
  std::vector<index_t> holeorbs_tmp; 
  std::vector<double> hole_occ_tmp;

  for (auto i : sorted_indices)
  {

    Orbit& oi = modelspace->GetOrbit(i);
    if (oi.tz2 < 0 and (placedZ<targetZ))
    {
      holeorbs_tmp.push_back(i);
      hole_occ_tmp.push_back( std::min(1.0,double(targetZ-placedZ)/(oi.j2+1) ) );
      placedZ = std::min(placedZ+oi.j2+1,targetZ);
    }
    else if (oi.tz2 > 0 and (placedN<targetN))
    {
      holeorbs_tmp.push_back(i);
      hole_occ_tmp.push_back( std::min(1.0,double(targetN-placedN)/(oi.j2+1) ) );
      placedN = std::min(placedN+oi.j2+1,targetN);
    }

    if((placedZ >= targetZ) and (placedN >= targetN) ) break;
  }

  holeorbs = arma::uvec( holeorbs_tmp );
  hole_occ = arma::rowvec( hole_occ_tmp );
}




//*********************************************************************
///  [See Suhonen eq 4.85]
/// \f[ F_{ij} = t_{ij}  +  \frac{1}{2j_i+1}\sum_{ab} \rho_{ab} \bar{V}^{(2)}_{iajb}
///               + \frac{1}{2(2j_i+1)}\sum_{abcd}\rho_{ab} \rho_{cd} \bar{V}^{(3)}_{iacjbd}  \f]
/// * \f$ F \f$ is the Fock matrix, to be diagonalized
/// * \f$ t \f$ is the kinetic energy
/// * \f$\rho\f$ is the density matrix defined in UpdateDensityMatrix()
/// * \f$ \bar{V}^{(2)} \f$ is the monopole component of the 2-body interaction defined in BuildMonopoleV().
/// * \f$ \bar{V}^{(3)} \f$ is the monopole component of the 3-body interaction devined in BuildMonopoleV3().
//*********************************************************************
void HartreeFock::UpdateF()
{
   double start_time = omp_get_wtime();
//   int norbits = modelspace->GetNumberOrbits();
   Vij.zeros();
   V3ij.zeros();


   // This loop isn't thread safe for some reason. Regardless, parallelizing it makes it slower. 
//   for (int i=0;i<norbits;i++)
   for (auto i : modelspace->all_orbits)
   {
      Orbit& oi = modelspace->GetOrbit(i);
      for (auto j : Hbare.OneBodyChannels.at({oi.l,oi.j2,oi.tz2}) )
      {
         if (j<i) continue;
//         for (int a=0;a<norbits;++a)
         for (auto a : modelspace->all_orbits)
         {
            Orbit& oa = modelspace->GetOrbit(a);
            int Tz = (oi.tz2+oa.tz2)/2;
            int parity = (oi.l+oa.l)%2;
            int bra = modelspace->GetKetIndex(std::min(i,a),std::max(i,a));
            int local_bra = modelspace->MonopoleKets[Tz+1][parity][bra];
            for (auto b : Hbare.OneBodyChannels.at({oa.l,oa.j2,oa.tz2}) )
            {
               int ket = modelspace->GetKetIndex(std::min(j,b),std::max(j,b));
               int local_ket = modelspace->MonopoleKets[Tz+1][parity][ket];
               // 2body term <ai|V|bj>
               if ((a>i) xor (b>j))  // code needed some obfuscation, so threw an xor in there...
                  Vij(i,j) += rho(a,b)*Vmon_exch[Tz+1][parity](local_bra,local_ket); // <a|rho|b> * <ai|Vmon|jb>
               else
                  Vij(i,j) += rho(a,b)*Vmon[Tz+1][parity](local_bra,local_ket); // <a|rho|b> * <ai|Vmon|bj>
           }
         }
      }
      Vij.col(i) /= (oi.j2+1);
   }

   if (Hbare.GetParticleRank()>=3) 
   {
      // it's just a one-body matrix, so we can store different copy for each thread.
      std::vector<arma::mat> V3vec(omp_get_max_threads(),V3ij);
      #pragma omp parallel for schedule(dynamic,1)
      for (size_t ind=0;ind<Vmon3.size(); ++ind)
      {
        arma::mat& v3ij = V3vec[omp_get_thread_num()];
        int a,b,c,d,i,j;
        Vmon3UnHash(Vmon3_keys[ind], a,c,i,b,d,j);
        v3ij(i,j) += rho(a,b) * rho(c,d) * Vmon3[ind] ;
      }
      for (auto& v : V3vec) V3ij += v;
      V3vec.clear(); // free up the memory (is this at all necessary, since it goes out of scope?)
   }

   Vij  = arma::symmatu(Vij);
   V3ij = arma::symmatu(V3ij);
//   std::cout << "Updating F.  " << std::endl << "KE: " << std::endl << KE << std::endl << std::endl << "Vij" << std::endl << Vij << std::endl;

   F = KE + Vij + 0.5*V3ij;

   profiler.timer["HF_UpdateF"] += omp_get_wtime() - start_time;
}



//********************************************************
/// Check for convergence using difference in s.p. energies
/// between iterations.
/// Converged when
/// \f[ \delta_{e} \equiv \sqrt{ \sum_{i}(e_{i}^{(n)}-e_{i}^{(n-1)})^2} < \textrm{tolerance} \f]
/// where \f$ e_{i}^{(n)} \f$ is the \f$ i \f$th eigenvalue of the Fock matrix after \f$ n \f$ iterations.
///
//********************************************************
bool HartreeFock::CheckConvergence()
{
   CalcEHF();
   convergence_EHF.push_back(EHF);
   convergence_EHF.pop_front();
   double ediff = arma::norm(energies-prev_energies, "frob") / energies.size();
   convergence_ediff.push_back(ediff); // update list of convergence checks
   convergence_ediff.pop_front();
   return (ediff < tolerance);
}


//**********************************************************************
/// Eigenvectors/values come out of the diagonalization energy-ordered.
/// We want them ordered corresponding to the input ordering, i.e. we want
/// the l,j,tz sub-blockes of the matrix C to be energy-ordered and positive along the diagonal.
/// For a 3x3 matrix this would be something like (this needs to be updated)
/// \f[
/// \left(
/// \begin{array}{rrr}
///   -0.8 & 0.2 & -0.6 \\
///   -0.3 & 0.3 &  0.9 \\
///    0.2 & 0.9 & -0.4 \\
/// \end{array}\right)
/// \rightarrow
/// \left(\begin{array}{rrr} 
///    0.8 & -0.6 & 0.2  \\
///    0.3 &  0.9 & 0.3  \\
///   -0.2 & -0.4 & 0.9  \\
/// \end{array}\right)
/// \f]
//**********************************************************************
void HartreeFock::ReorderCoefficients()
{
   for ( auto& it : Hbare.OneBodyChannels )
   {
//     arma::uvec orbvec(it.second);
     arma::uvec orbvec(std::vector<index_t>(it.second.begin(),it.second.end())); // convert from std::set to std::vector, and then to arma::uvec
     arma::vec E_ch = energies(orbvec);
     int nswaps = 10; // keep track of the number of swaps we had to do, iterate until nswaps==0
     // first, make the orbits with the same l,j,tz energy ordered
     while (nswaps>0) // loop until we don't have to make any more swaps
     {
       nswaps = 0;
       for (index_t i=0;i<E_ch.size()-1;i++)
       {
         if (E_ch[i] > E_ch[i+1])
         {
           E_ch.swap_rows(orbvec[i],orbvec[i+1]);
           C.swap_cols(orbvec[i],orbvec[i+1]);
           nswaps++;
         }
       }
      }

     // Make sure the diagonal terms are positive (to avoid confusion later).
     for (index_t i=0;i<C.n_rows;++i) // loop through original basis states
     {
        if (C(i,i) < 0)  C.col(i) *= -1;
     }
   }

}


//**************************************************************************
/// Takes in an operator expressed in the basis of the original Hamiltonian,
/// and returns that operator in the Hartree-Fock basis.
/// \f[ t_{HF} = C^{\dagger} t_{HO} C \f]
/// \f[ V_{HF}^{J} = D^{\dagger} V^{J}_{HO} D \f]
/// The matrix \f$ D \f$ is defined as
/// \f[ D_{ab\alpha\beta} \equiv \sqrt{ \frac{1+\delta_{ab}} {1+\delta_{\alpha\beta}} }  C_{a\alpha} C_{b\beta} \f]
/// The factor in the square root is due to the fact that we're using normalized TBME's.
/// Since only kets with \f$ a\leq b\f$ are stored, we can use the antisymmetry of the TBME's and define
/// \f[ D(J)_{ab\alpha\beta} \equiv \sqrt{ \frac{1+\delta_{ab}} {1+\delta_{\alpha\beta}} }
///      \left( C_{a\alpha} C_{b\beta} -(1-\delta_{ab})(-1)^{j_a+j_b-J} C_{b\alpha}C_{a\beta}\right) \f]
///
//**************************************************************************
Operator HartreeFock::TransformToHFBasis( Operator& OpHO)
{

   Operator OpHF(OpHO);
   // Easy part:
   //Update the one-body part by multiplying by the matrix C(i,a) = <i|a>
   // where |i> is the original basis and |a> is the HF basis
   OpHF.OneBody = C.t() * OpHO.OneBody * C;


   // Moderately difficult part:
   // Update the two-body part by multiplying by the matrix D(ij,ab) = <ij|ab>
   // for each channel J,p,Tz. Most of the effort here is in constructing D.

   for ( auto& it : OpHO.TwoBody.MatEl )
   {
      int ch_bra = it.first[0];
      int ch_ket = it.first[1];
      TwoBodyChannel& tbc_bra = OpHF.GetModelSpace()->GetTwoBodyChannel(ch_bra);
      TwoBodyChannel& tbc_ket = OpHF.GetModelSpace()->GetTwoBodyChannel(ch_ket);
      int nbras = it.second.n_rows;
      int nkets = it.second.n_cols;
      arma::mat Dbra(nbras,nbras);
      arma::mat Dket(nkets,nkets);
      // loop over all possible original basis configurations <pq| in this J,p,Tz channel.
      // and all possible HF configurations |p'q'> in this J,p,Tz channel                                    
      // bra is in the original basis, ket is in the HF basis                                              
      // i and j are the indices of the matrix D for this channel                    
      for (int i=0; i<nkets; ++i)    
      {
         Ket & ket_ho = tbc_ket.GetKet(i);   
         for (int j=0; j<nkets; ++j)    
         {
            Ket & ket_hf = tbc_ket.GetKet(j); 
            Dket(i,j) = C(ket_ho.p,ket_hf.p) * C(ket_ho.q,ket_hf.q);
            if (ket_ho.p!=ket_ho.q)
            {
               Dket(i,j) += C(ket_ho.q, ket_hf.p) * C(ket_ho.p, ket_hf.q) * ket_ho.Phase(tbc_ket.J);
            }
            if (ket_ho.p==ket_ho.q)    Dket(i,j) *= PhysConst::SQRT2;
            if (ket_hf.p==ket_hf.q)    Dket(i,j) /= PhysConst::SQRT2;
         }
      }
      if (ch_bra == ch_ket)
      {
        Dbra = Dket.t();
      }
      else
      {
        for (int i=0; i<nbras; ++i)    
        {
           Ket & bra_hf = tbc_bra.GetKet(i);   
           for (int j=0; j<nbras; ++j)    
           {
              Ket & bra_ho = tbc_bra.GetKet(j); 
              Dbra(i,j) = C(bra_ho.p,bra_hf.p) * C(bra_ho.q,bra_hf.q);
              if (bra_ho.p!=bra_ho.q)
              {
                 Dbra(i,j) += C(bra_ho.q, bra_hf.p) * C(bra_ho.p, bra_hf.q) * bra_ho.Phase(tbc_bra.J);
              }
              if (bra_ho.p==bra_ho.q)    Dbra(i,j) *= PhysConst::SQRT2;
              if (bra_hf.p==bra_hf.q)    Dbra(i,j) /= PhysConst::SQRT2;
           }
        }
      }
      auto& IN  =  it.second;
      auto& OUT =  OpHF.TwoBody.GetMatrix(ch_bra,ch_ket);
      OUT  =    Dbra * IN * Dket;

   }

   return OpHF;
}

// If the lowest orbits are different from our previous guess, we should update the reference.
void HartreeFock::UpdateReference()
{

  bool changed_occupations = false;
  std::map<index_t,double> hole_map;
  for (index_t i=0;i<holeorbs.size();++i)  
  {
     hole_map[holeorbs[i]] = hole_occ[i];
//     std::cout << "i = " << i << " hole_occ = " << hole_occ << "  diff = " << std::abs(modelspace->GetOrbit( holeorbs[i] ).occ - hole_occ[i]) << std::endl;
     if ( std::abs(modelspace->GetOrbit( holeorbs[i] ).occ - hole_occ[i]) > 1e-3)
     {
        changed_occupations = true;
        std::cout << "After HF, occupation of orbit " << holeorbs[i] << " has changed. Modelspace will be updated." << std::endl;
     }
  }
//  std::cout << "Before calling SetReference, A,Z = " << modelspace->GetAref() << " " << modelspace->GetZref() << std::endl;
  if (changed_occupations)  modelspace->SetReference( hole_map );

}


Operator HartreeFock::GetNormalOrderedH(arma::mat& Cin) 
{
  C=Cin;
//  ReorderCoefficients();  // Reorder columns of C so we can properly identify the hole orbits.
  UpdateDensityMatrix();  // Update the 1 body density matrix, used in UpdateF()
  UpdateF();              // Update the Fock matrix
  CalcEHF();
  PrintEHF();

  return GetNormalOrderedH();
}
/// Returns the normal-ordered Hamiltonian in the Hartree-Fock basis, neglecting the residual 3-body piece.
/// \f[ E_0 = E_{HF} \f]
/// \f[ f = C^{\dagger} F C \f]
/// \f[ \Gamma = D^{\dagger} \left(V^{(2)}+V^{(3\rightarrow 2)} \right) D \f]
/// \f[ V^{(2\rightarrow 3)J}_{ijkl} \equiv \frac{1}{\sqrt{(1+\delta_{ij})(1+\delta_{kl})}}\sum_{ab}\sum_{J_3}(2J_{3}+1)\rho_{ab}V^{JJJ_{3}}_{ijaklb} \f]
/// Where \f$ F\f$ is the Fock matrix obtained in UpdateF() and the matrix \f$ D\f$ is the same as the one defined in TransformToHFBasis().
///
Operator HartreeFock::GetNormalOrderedH() 
{
   double start_time = omp_get_wtime();
   std::cout << "Getting normal-ordered H in HF basis" << std::endl;

   // First, check if we need to update the occupation numbers for the reference
   if (not freeze_occupations)
   {
     UpdateReference();
//     bool changed_occupations = false;
//     std::map<index_t,double> hole_map;
//     std::cout << "Looking through holeorbs to see if we changed occupations" << std::endl;
//     for (index_t i=0;i<holeorbs.size();++i)  
//     {
//        hole_map[holeorbs[i]] = hole_occ[i];
//        if ( std::abs(modelspace->GetOrbit( holeorbs[i] ).occ - hole_occ[i]) > 1e-3)
//        {
//           changed_occupations = true;
//           std::cout << "After HF, occupation of orbit " << i << " has changed. Modelspace will be updated." << std::endl;
//        }
//     }
//     if (changed_occupations)  modelspace->SetReference( hole_map );
   }

   Operator HNO = Operator(*modelspace,0,0,0,2);
   HNO.ZeroBody = EHF;
   HNO.OneBody = C.t() * F * C;

   int nchan = modelspace->GetNumberTwoBodyChannels();
//   int norb = modelspace->GetNumberOrbits();
//   #pragma omp parallel for schedule(dynamic,1) // have not yet confirmed that this improves performance ... no sign of significant improvement
   for (int ch=0;ch<nchan;++ch)
   {
      TwoBodyChannel& tbc = modelspace->GetTwoBodyChannel(ch);
      int J = tbc.J;
      int npq = tbc.GetNumberKets();

      arma::mat D(npq,npq,arma::fill::zeros);  // <ij|ab> = <ji|ba>
      arma::mat V3NO(npq,npq,arma::fill::zeros);  // <ij|ab> = <ji|ba>

      #pragma omp parallel for schedule(dynamic,1) // confirmed that this improves performance
      for (int i=0; i<npq; ++i)    
      {
         Ket & bra = tbc.GetKet(i);
         int e2bra = 2*bra.op->n + bra.op->l + 2*bra.oq->n + bra.oq->l;
         for (int j=0; j<npq; ++j)
         {
            Ket & ket = tbc.GetKet(j); 
            int e2ket = 2*ket.op->n + ket.op->l + 2*ket.oq->n + ket.oq->l;
            D(i,j) = C(bra.p,ket.p) * C(bra.q,ket.q);
            if (bra.p!=bra.q)
            {
               D(i,j) += C(bra.q,ket.p) * C(bra.p,ket.q) * bra.Phase(J);
            }
            if (bra.p==bra.q)    D(i,j) *= PhysConst::SQRT2;
            if (ket.p==ket.q)    D(i,j) /= PhysConst::SQRT2;

            // Now generate the NO2B part of the 3N interaction
            if (Hbare.GetParticleRank()<3) continue;
            if (i>j) continue;
//            for (int a=0; a<norb; ++a)
            for ( auto a : modelspace->all_orbits )
            {
              Orbit & oa = modelspace->GetOrbit(a);
              if ( 2*oa.n+oa.l+e2bra > Hbare.GetE3max() ) continue;
              for (int b : Hbare.OneBodyChannels.at({oa.l,oa.j2,oa.tz2}))
              {
                Orbit & ob = modelspace->GetOrbit(b);
                if ( 2*ob.n+ob.l+e2ket > Hbare.GetE3max() ) continue;
                if ( std::abs(rho(a,b)) < 1e-8 ) continue; // Turns out this helps a bit (factor of 5 speed up in tests)
                int J3min = std::abs(2*J-oa.j2);
                int J3max = 2*J + oa.j2;
                for (int J3=J3min; J3<=J3max; J3+=2)
                {
                  V3NO(i,j) += rho(a,b) * (J3+1) * Hbare.ThreeBody.GetME_pn(J,J,J3,bra.p,bra.q,a,ket.p,ket.q,b);
                }
              }
            }
            V3NO(i,j) /= (2*J+1);
            if (bra.p==bra.q)  V3NO(i,j) /= PhysConst::SQRT2; 
            if (ket.p==ket.q)  V3NO(i,j) /= PhysConst::SQRT2; 
            V3NO(j,i) = V3NO(i,j);
         }
      }

     auto& V2  =  Hbare.TwoBody.GetMatrix(ch);
     auto& OUT =  HNO.TwoBody.GetMatrix(ch);
     OUT  =    D.t() * (V2 + V3NO) * D;
   }
   
//   FreeVmon();

   profiler.timer["HF_GetNormalOrderedH"] += omp_get_wtime() - start_time;
   
   return HNO;

}


void HartreeFock::FreeVmon()
{
   // free up some memory
   std::array< std::array< arma::mat,2>,3>().swap(Vmon);
   std::array< std::array< arma::mat,2>,3>().swap(Vmon_exch);
//   vector< pair<const array<int,6>,double>>().swap( Vmon3 );
//   vector< pair<const uint64_t,double>>().swap( Vmon3 );
   std::vector< double>().swap( Vmon3 );
   std::vector< uint64_t>().swap( Vmon3_keys );
}


/// Get the one-body generator corresponding to the transformation to the HF basis.
/// Since the unitary transformation for HF is given by the \f$ U_{HF} = C^{\dagger} \f$ matrix, we have
/// \f$ e^{-\Omega} = C \Rightarrow \Omega = -\log(C) \f$.
/// The log is evaluated by diagonalizing the one-body submatrix and taking the log of the diagonal entries.
/// This is much slower than the other methods, but it might be useful.
Operator HartreeFock::GetOmega()
{
   Operator Omega(*modelspace,0,0,0,1);
   Omega.SetAntiHermitian();
   for ( auto& it : Hbare.OneBodyChannels )
   {
//      arma::uvec orbvec(it.second);
      arma::uvec orbvec(std::vector<index_t>(it.second.begin(),it.second.end()));
      arma::mat C_ch = C.submat(orbvec,orbvec);
      arma::cx_mat eigvect;
      arma::cx_vec eigval;
      arma::eig_gen(eigval, eigvect, C_ch);
      Omega.OneBody.submat(orbvec,orbvec) = -arma::real( eigvect * arma::diagmat(arma::log(eigval)) * eigvect.t()) ;
   }
   return Omega;
}


void HartreeFock::PrintSPE()
{
//  for (size_t i=0;i<modelspace->GetNumberOrbits();++i)
  for ( auto i : modelspace->all_orbits )
  {
    Orbit& oi = modelspace->GetOrbit(i);
    std::cout << std::fixed << std::setw(3) << oi.n << " " << std::setw(3) << oi.l << " "
         << std::setw(3) << oi.j2 << " " << std::setw(3) << oi.tz2 << "   " << std::setw(10) << F(i,i) << std::endl;
  }

}


void HartreeFock::PrintSPEandWF()
{
  std::cout << std::fixed << std::setw(3) << "i" << ": " << std::setw(3) << "n" << " " << std::setw(3) << "l" << " "
       << std::setw(3) << "2j" << " " << std::setw(3) << "2tz" << "   " << std::setw(12) << "SPE" << " " << std::setw(12) << "occ." << "   |   " << " overlaps" << std::endl;
//  for (int i=0;i<modelspace->GetNumberOrbits();++i)
  for ( auto i : modelspace->all_orbits )
  {
    Orbit& oi = modelspace->GetOrbit(i);
    std::cout << std::fixed << std::setw(3) << i << ": " << std::setw(3) << oi.n << " " << std::setw(3) << oi.l << " "
         << std::setw(3) << oi.j2 << " " << std::setw(3) << oi.tz2 << "   " << std::setw(12) << std::setprecision(6) << F(i,i) << " " << std::setw(12) << oi.occ << "   | ";
    for (int j : Hbare.OneBodyChannels.at({oi.l,oi.j2,oi.tz2}) )
    {
      std::cout << std::setw(9) << C(i,j) << "  ";
    }
    std::cout << std::endl;
  }
}


void HartreeFock::GetRadialWF(index_t index, std::vector<double>& R, std::vector<double>& PSI)
{
  PSI.resize(0);
  for (double r : R)
  {
    PSI.push_back( GetRadialWF_r(index, r) );
  }
}

double HartreeFock::GetRadialWF_r(index_t index, double R)
{
  using PhysConst::M_NUCLEON;
  using PhysConst::HBARC;
  using PhysConst::SQRTPI;
  double b = sqrt( (HBARC*HBARC) / (modelspace->GetHbarOmega() * M_NUCLEON) );
  Orbit& orb = modelspace->GetOrbit(index);
   double x = R/b;
   double psi = 0;
   for ( index_t j : Hbare.OneBodyChannels.at({orb.l,orb.j2,orb.tz2}) )
   {
     Orbit& oj = modelspace->GetOrbit(j);
//     double Norm = 2*sqrt( gsl_sf_fact(oj.n) * pow(2,oj.n+oj.l) / M_SQRTPI / gsl_sf_doublefact(2*oj.n+2*oj.l+1) * pow(b,-3.0) );
     double Norm = 2*sqrt( gsl_sf_fact(oj.n) * pow(2,oj.n+oj.l) / SQRTPI / gsl_sf_doublefact(2*oj.n+2*oj.l+1) * pow(b,-3.0) );
     psi += C(index,j) * Norm * pow(x,oj.l) * exp(-x*x*0.5) * gsl_sf_laguerre_n(oj.n,oj.l+0.5,x*x);
   }
   return psi;
}





double HartreeFock::GetHFPotential( size_t i, double r, double rprime)
{
  double Uhf = 0;
    Orbit& oi = modelspace->GetOrbit(i);
//  size_t norb = modelspace->GetNumberOrbits();
//  for (size_t i=0; i<norb; i++)
//  {
    for (auto j : Hbare.OneBodyChannels.at({oi.l,oi.j2,oi.tz2}) )
    {
      for (auto k : Hbare.OneBodyChannels.at({oi.l,oi.j2,oi.tz2}) )
      {
        Uhf +=  (Vij(j,k) + 0.5*V3ij(j,k) )  * GetRadialWF_r(j,r) * GetRadialWF_r(k,rprime);
      }
    }
//  }
  return Uhf;
}


double HartreeFock::GetAverageHFPotential( double r, double rprime)
{
  double Uhf = 0;
  size_t norb = modelspace->GetNumberOrbits();
  for (size_t i=0; i<norb; i++)
  {
    Orbit& oi = modelspace->GetOrbit(i);
    if (oi.n == 0)
    {
      Uhf += GetHFPotential(i,r,rprime);
    }
  }
  Uhf /= 2*(2*modelspace->GetEmax()+1); // 2 for protons/neutrons, and 2*emax+1 is number of different l,j combinations
  return Uhf;
}


// Get the 3-body interaction in the Hartree-Fock basis.
// Note that because the ThreeBody structure stores things in isospin format
// and because I haven't bothered to write a new structure, we get
// a 3-body interaction with good isospin, even though the HF basis breaks isospin.
// Hopefully this isn't much of an approximation, but it shouldn't be too bad
// to make a new structure in the future.
ThreeBodyME HartreeFock::GetValence3B( int emax, int E3max )
{
  double t_start = omp_get_wtime();
  ThreeBodyME hf3bme(modelspace, E3max);
  hf3bme.Setemax(emax);
  hf3bme.Allocate();
  // big loop over elements of hf3bme...
  auto norbits = modelspace->GetNumberOrbits();
  for (size_t a=0; a<norbits; a+=2)
  {
   Orbit& oa = modelspace->GetOrbit(a);
   int ea = 2*oa.n + oa.l;
   if ((ea > emax) or ea>E3max ) break;
   for (size_t b=0; b<=a; b+=2)
   {
    Orbit& ob = modelspace->GetOrbit(b);
    int eb = 2*ob.n + ob.l;
    if ((ea+eb)>E3max) break;
    int Jab_min = std::abs( oa.j2 - ob.j2 ) /2;
    int Jab_max =         ( oa.j2 + ob.j2 ) /2;
    int tab_min = std::abs( oa.tz2 + ob.tz2)/2;
    int tab_max = 1;
    for (size_t c=0; c<=b; c+=2)
    {
      Orbit& oc = modelspace->GetOrbit(c);
      int ec = 2*oc.n + oc.l;
      if ((ea+eb+ec)>E3max) break;
      for (size_t d=0; d<=a; d+=2 )
      {
       Orbit& od = modelspace->GetOrbit(d);
       for (size_t e=0; e<=d; e+=2 )
       {
        Orbit& oe = modelspace->GetOrbit(e);
        int Jde_min = std::abs( od.j2 - oe.j2 ) /2;
        int Jde_max =         ( od.j2 + oe.j2 ) /2;
        int tde_min = std::abs( od.tz2 + oe.tz2)/2;
        int tde_max = 1;
        for (size_t f=0; f<=e; f+=2 )
        {
          Orbit& of = modelspace->GetOrbit(f);
//          if ( (oa.tz2+ob.tz2+oc.tz2) != (od.tz2+oe.tz2+of.tz2) ) continue;
          for (int Jab=Jab_min; Jab<=Jab_max; Jab++)
          {
           for (int Jde=Jde_min; Jde<=Jde_max; Jde++)
           {
            int J2_min = std::max( std::abs(Jab*2-oc.j2), std::abs(Jde*2-of.j2) );
            int J2_max = std::min(         (Jab*2+oc.j2),         (Jde*2+of.j2) );
            for (int J2=J2_min; J2<=J2_max; J2++)
            {
              for (int tab=tab_min; tab<=tab_max; tab++)
              {
               for (int tde=tde_min; tde<=tde_max; tde++)
               {
                int T2_min = 1;
//                int T2_max = std::abs(oa.tz2+ob.tz2+oc.tz2);  // this will be either 1 or 3.
                int T2_max = 3;  // this will be either 1 or 3.
                for (int T2=T2_min; T2<=T2_max; T2++)
                {
                  double V = GetHF3bme( Jab, Jde, J2, tab, tde, T2, a, b, c, d, e, f );
                  hf3bme.SetME(Jab, Jde, J2, tab, tde, T2, a, b, c, d, e, f, V);
                } // for T2
               } // for tde
              } // for tab
            }
           } // for Jde
          } // for Jab
        } // for f
       } // for e
      } // for d
    }// for c
   } // for b
  } // for a

  IMSRGProfiler::timer["HartreeFock::GetValence3B"] += omp_get_wtime() - t_start;
  return hf3bme;

}



// Get a single 3-body matrix element in the HartreeFock basis.
// Because we're using good isospin, right now we just use the proton orbits.
// In principle we could figure out a more clever way by averaging depending on the isospin value.
double HartreeFock::GetHF3bme( int Jab, int Jde, int J2, int tab, int tde, int T2, size_t a, size_t b, size_t c, size_t d, size_t e, size_t f)
{
  double V_hf = 0.;
  Orbit& oa = modelspace->GetOrbit(a);
  Orbit& ob = modelspace->GetOrbit(b);
  Orbit& oc = modelspace->GetOrbit(c);
  Orbit& od = modelspace->GetOrbit(d);
  Orbit& oe = modelspace->GetOrbit(e);
  Orbit& of = modelspace->GetOrbit(f);

  for (auto alpha : Hbare.OneBodyChannels.at({oa.l,oa.j2,oa.tz2}) )
  {
   if ( std::abs(C(alpha,a)) < 1e-8 ) continue;
   for (auto beta : Hbare.OneBodyChannels.at({ob.l,ob.j2,ob.tz2}) )
   {
    if ( std::abs(C(beta,b)) < 1e-8 ) continue;
    for (auto gamma : Hbare.OneBodyChannels.at({oc.l,oc.j2,oc.tz2}) )
    {
     if ( std::abs(C(gamma,c)) < 1e-8 ) continue;
     for (auto delta : Hbare.OneBodyChannels.at({od.l,od.j2,od.tz2}) )
     {
      if ( std::abs(C(delta,d)) < 1e-8 ) continue;
      for (auto epsilon : Hbare.OneBodyChannels.at({oe.l,oe.j2,oe.tz2}) )
      {
       if ( std::abs(C(epsilon,e)) < 1e-8 ) continue;
       for (auto phi : Hbare.OneBodyChannels.at({of.l,of.j2,of.tz2}) )
       {
         double V_ho = Hbare.ThreeBody.GetME( Jab,  Jde,  J2,  tab,  tde,  T2,  alpha,  beta,  gamma,  delta,  epsilon,  phi);
         V_hf += V_ho * C(alpha,a) * C(beta,b) * C(gamma,c) * C(delta,d) * C(epsilon,e) * C(phi,f);
       } // for phi
      } // for epsilon
     } // for delta
    } // for gamma
   } // for beta
  } // for alpha
  return V_hf;
}


