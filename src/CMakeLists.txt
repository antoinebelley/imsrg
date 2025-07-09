cmake_minimum_required(VERSION 3.22)

# Determine if imsrg++ is built as a subproject (using add_subdirectory)
# or if it is the main project.
if(NOT DEFINED IMSRGPLUSPLUS_MAIN_PROJECT)
  set(IMSRGPLUSPLUS_MAIN_PROJECT OFF)
  if(CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
    set(IMSRGPLUSPLUS_MAIN_PROJECT ON)
    message(STATUS "CMake version: ${CMAKE_VERSION}")
  endif()
endif()

# Set the default CMAKE_BUILD_TYPE to Release.
# This should be done before the project command since the latter can set
# CMAKE_BUILD_TYPE itself (it does so for nmake).
if(IMSRGPLUSPLUS_MAIN_PROJECT AND NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()



set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(IMSRGPLUSPLUS_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR})


# Add a custom command that produces version.cpp, plus
# a dummy output that's not actually produced, in order
# to force version.cmake to always be re-run before the build
ADD_CUSTOM_COMMAND(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/version.cc
           ${CMAKE_CURRENT_BINARY_DIR}/_version.cc
    COMMAND ${CMAKE_COMMAND} -P
            ${CMAKE_CURRENT_SOURCE_DIR}/git_version.cmake)

if(USE_ARMADILLO_EXTERN)
    list(APPEND ARMADILLO_LIBS armadillo)
else()
    list(APPEND ARMADILLO_LIBS ${ARMADILLO_LIBRARIES})
endif()


add_library(
    AngMom
    AngMom.hh AngMom.cc
)
target_link_libraries(
    AngMom
    PRIVATE
    GSL::gsl
)

add_library(
    AngMomCache
    AngMomCache.hh AngMomCache.cc
)
target_link_libraries(
    AngMomCache
    PRIVATE
    AngMom
)

add_library(
    IMSRGProfiler
    IMSRGProfiler.hh IMSRGProfiler.cc
)
target_link_libraries(
    IMSRGProfiler
    PRIVATE
    OpenMP::OpenMP_CXX
)

add_library(
    ModelSpace
    ModelSpace.hh ModelSpace.cc
    TwoBodyChannel.cc
    ThreeBodyChannel.cc
)
target_link_libraries(
    ModelSpace
    PUBLIC
    ${ARMADILLO_LIBS}
    IMSRGProfiler
    AngMomCache
    PRIVATE
    OpenMP::OpenMP_CXX
)

add_library(
    PhysicalConstants
    INTERFACE
)

add_library(
    TwoBodyME
    TwoBodyME.hh TwoBodyME.cc
)
target_link_libraries(
    TwoBodyME
    PUBLIC
    ModelSpace
    PRIVATE
    AngMom
    PhysicalConstants
)

add_library(
    ThreeLegME
    ThreeLegME.hh ThreeLegME.cc
)
target_link_libraries(
    ThreeLegME
    PUBLIC
    ${ARMADILLO_LIBS}
    ModelSpace
    PRIVATE
    PhysicalConstants
)

add_library(
    ThreeBodyStorage
    ThreeBodyStorage.hh ThreeBodyStorage.cc
)
target_link_libraries(
    ThreeBodyStorage
    PUBLIC
    ModelSpace
)

add_library(
    ThreeBodyStorage_pn
    ThreeBodyStorage_pn.hh ThreeBodyStorage_pn.cc
)
target_link_libraries(
    ThreeBodyStorage_pn
    PUBLIC
    ThreeBodyStorage
    PRIVATE
    AngMom
    OpenMP::OpenMP_CXX
)

add_library(
    ThreeBodyStorage_no2b
    ThreeBodyStorage_no2b.hh ThreeBodyStorage_no2b.cc
)
target_link_libraries(
    ThreeBodyStorage_no2b
    PUBLIC
    IMSRGBoostZip
    HalfPrecision
    ModelSpace
    ThreeBodyStorage
    PRIVATE
    AngMom
    OpenMP::OpenMP_CXX
)

add_library(
    ThreeBodyStorage_mono
    ThreeBodyStorage_mono.hh ThreeBodyStorage_mono.cc
)
target_link_libraries(
    ThreeBodyStorage_mono
    PUBLIC
    IMSRGBoostZip
    HalfPrecision
    ModelSpace
    ThreeBodyStorage
    PRIVATE
    AngMom
    OpenMP::OpenMP_CXX
)

add_library(
    ThreeBodyStorage_iso
    ThreeBodyStorage_iso.hh ThreeBodyStorage_iso.cc
)
target_link_libraries(
    ThreeBodyStorage_iso
    PUBLIC
    ThreeBodyStorage
    PRIVATE
    AngMom
)

add_library(
    ThreeBodyME
    ThreeBodyME.hh ThreeBodyME.cc
)
target_link_libraries(
    ThreeBodyME
    PUBLIC
    ModelSpace
    ThreeBodyStorage
    ThreeBodyStorage_iso
    ThreeBodyStorage_pn
    ThreeBodyStorage_no2b
    ThreeBodyStorage_mono
    PRIVATE
    IMSRGProfiler
    AngMom
    OpenMP::OpenMP_CXX
)

add_library(
    Parameters
    INTERFACE
)

add_library(
    Operator
    Operator.hh Operator.cc
)
target_link_libraries(
    Operator
    PUBLIC
    ${ARMADILLO_LIBS}
    ModelSpace
    TwoBodyME
    ThreeBodyME
    ThreeLegME
    IMSRGProfiler
    PRIVATE
    GSL::gsl
    OpenMP::OpenMP_CXX
    PhysicalConstants
    AngMom
)

add_library(
    Version
    version.hh
    ${CMAKE_CURRENT_BINARY_DIR}/version.cc
)
target_include_directories(
    Version
    PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
)

add_library(
    ReadWrite
    ReadWrite.hh ReadWrite.cc
)
target_compile_definitions(
    ReadWrite
    PUBLIC
    NO_HDF5="true"
)
target_link_libraries(
    ReadWrite
    PUBLIC
    ModelSpace
    Operator
    Jacobi3BME
    ThreeBodyME
    PRIVATE
    OpenMP::OpenMP_CXX
    IMSRGBoostZip
    AngMom
    PhysicalConstants
    Version
)

add_library(
    BCH
    BCH.hh BCH.cc
)
target_link_libraries(
    BCH
    PUBLIC
    Operator
    PRIVATE
    Commutator
    OpenMP::OpenMP_CXX
)

add_library(
    IMSRGSolver
    IMSRGSolver.hh IMSRGSolver.cc
)
target_link_libraries(
    IMSRGSolver
    PUBLIC
    Operator
    Generator
    IMSRGProfiler
    ReadWrite
    PRIVATE
    BCH
    Commutator
    Boost::boost
)

add_library(
    IMSRGSolverPV
    IMSRGSolverPV.hh IMSRGSolverPV.cc
)
target_link_libraries(
    IMSRGSolverPV
    PUBLIC
    IMSRGSolver
    GeneratorPV
    PRIVATE
    Commutator
)

add_library(
    Commutator232
    Commutator232.hh Commutator232.cc
)
target_link_libraries(
    Commutator232
    PUBLIC
    Operator
    ModelSpace
    PRIVATE
    OpenMP::OpenMP_CXX
)

add_library(
    TensorCommutators
    TensorCommutators.hh TensorCommutators.cc
)
target_link_libraries(
    TensorCommutators
    PUBLIC
    Operator
    ModelSpace
    PRIVATE
    OpenMP::OpenMP_CXX
)

add_library(
    IMSRG3Commutators
    IMSRG3Commutators.hh IMSRG3Commutators.cc
)
target_link_libraries(
    IMSRG3Commutators
    PUBLIC
    Operator
    ModelSpace
    PRIVATE
    OpenMP::OpenMP_CXX
)

add_library(
    FactorizedDoubleCommutator
    FactorizedDoubleCommutator.hh FactorizedDoubleCommutator.cc
)
target_link_libraries(
    FactorizedDoubleCommutator
    PUBLIC
    Operator
    ModelSpace
    PRIVATE
    OpenMP::OpenMP_CXX
)

add_library(
    DaggerCommutators
    DaggerCommutators.hh DaggerCommutators.cc
)
target_link_libraries(
    DaggerCommutators
    PUBLIC
    Operator
    ModelSpace
    PRIVATE
    OpenMP::OpenMP_CXX
)

add_library(
    Commutator
    Commutator.hh Commutator.cc
)
target_link_libraries(
    Commutator
    PUBLIC
    ${ARMADILLO_LIBS}
    Operator
    TwoBodyME
    ThreeLegME
    PRIVATE
    OpenMP::OpenMP_CXX
    PhysicalConstants
    Commutator232
    TensorCommutators
    IMSRG3Commutators
    FactorizedDoubleCommutator
    DaggerCommutators
    AngMom
)

add_library(
    DarkMatterNREFT
    DarkMatterNREFT.hh DarkMatterNREFT.cc
)
target_link_libraries(
    DarkMatterNREFT
    PUBLIC
    ModelSpace
    Operator
    PRIVATE
    GSL::gsl
    PhysicalConstants
)

add_library(
    Jacobi3BME
    Jacobi3BME.hh Jacobi3BME.cc
)
target_link_libraries(
    Jacobi3BME
    PUBLIC
    ModelSpace
    PRIVATE
    AngMom
    # This is safe because HartreeFock is a private dep of Jacobi3BME.
    # If both deps were public, we would have a problem.
    HartreeFock
    IMSRGProfiler
    OpenMP::OpenMP_CXX
)

add_library(
    HartreeFock
    HartreeFock.hh HartreeFock.cc
)
target_link_libraries(
    HartreeFock
    PUBLIC
    ${ARMADILLO_LIBS}
    ModelSpace
    Operator
    IMSRGProfiler
    Jacobi3BME
    ThreeBodyME
    PRIVATE
    OpenMP::OpenMP_CXX
    GSL::gsl
    AngMom
    PhysicalConstants
)

add_library(
    GaussLaguerre
    INTERFACE
)

# add_library(
#     Helicity
#     Helicity.hh Helicity.cc
# )

# target_link_libraries(
#     Helicity
#     PUBLIC
#     GSL::gsl
#     PhysicalConstants
#     PRIVATE
#     AngMom

# )

add_library(
    Pwd
    Pwd.hh Pwd.cc
)

target_link_libraries(
    Pwd
    PUBLIC
    GSL::gsl
    PhysicalConstants

)

add_library(
    M0nu
    M0nu.hh M0nu.cc
)
target_link_libraries(
    M0nu
    PUBLIC
    OpenMP::OpenMP_CXX
    GSL::gsl
    ModelSpace
    Operator
    imsrg_util
    PhysicalConstants
    Pwd
    PRIVATE
    AngMom
)

add_library(
    imsrg_util
    imsrg_util.hh imsrg_util.cc
)
target_link_libraries(
    imsrg_util
    PUBLIC
    ModelSpace
    Operator
    HartreeFock
    IMSRGSolver
    PhysicalConstants
    GSL::gsl
    PRIVATE
    OpenMP::OpenMP_CXX
    Commutator
    DarkMatterNREFT
    GaussLaguerre
    M0nu
)

add_library(
    Generator
    Generator.hh Generator.cc
)
target_link_libraries(
    Generator
    PUBLIC
    ModelSpace
    Operator
    PRIVATE
    GSL::gsl
    imsrg_util
    AngMom
    Commutator
    PhysicalConstants
    OpenMP::OpenMP_CXX
)

add_library(
    GeneratorPV
    GeneratorPV.hh GeneratorPV.cc
)
target_link_libraries(
    GeneratorPV
    PUBLIC
    ModelSpace
    Operator
    PRIVATE
    Generator
    GSL::gsl
    imsrg_util
    AngMom
    Commutator
    PhysicalConstants
    OpenMP::OpenMP_CXX
)

add_library(
    HFMBPT
    HFMBPT.hh HFMBPT.cc
)
target_link_libraries(
    HFMBPT
    PUBLIC
    ${ARMADILLO_LIBS}
    HartreeFock
    PRIVATE
    PhysicalConstants
    OpenMP::OpenMP_CXX
)

add_library(
    RPA
    RPA.hh RPA.cc
)
target_link_libraries(
    RPA
    PUBLIC
    ${ARMADILLO_LIBS}
    ModelSpace
    Operator
    PRIVATE
    PhysicalConstants
    AngMom
)

add_library(
    ReferenceImplementations
    ReferenceImplementations.hh ReferenceImplementations.cc
)
target_link_libraries(
    ReferenceImplementations
    PUBLIC
    ModelSpace
    Operator
    Commutator
    PRIVATE
    ${ARMADILLO_LIBS}
    PhysicalConstants
    Version
    imsrg_util
    AngMom
    OpenMP::OpenMP_CXX
)

add_library(
    UnitTest
    UnitTest.hh UnitTest.cc
)
target_link_libraries(
    UnitTest
    PUBLIC
    ModelSpace
    Operator
    Commutator
    PRIVATE
    ${ARMADILLO_LIBS}
    PhysicalConstants
    Version
    imsrg_util
    AngMom
    OpenMP::OpenMP_CXX
    ReferenceImplementations
)

add_library(
    IMSRG
    INTERFACE
)
target_link_libraries(
    IMSRG
    INTERFACE
    ReadWrite
    ModelSpace
    TwoBodyME
    ThreeBodyME
    Operator
    HartreeFock
    Commutator
    IMSRGSolver
    IMSRGSolverPV
    Generator
    GeneratorPV
    imsrg_util
    AngMom
    IMSRGProfiler
    Jacobi3BME
    DarkMatterNREFT
    HFMBPT
    UnitTest
    PhysicalConstants
    RPA
)

add_executable(
    imsrg++
    imsrg++.cc
)
target_link_libraries(
    imsrg++
    PUBLIC
    IMSRG
    Parameters
    PhysicalConstants
    Version
    OpenMP::OpenMP_CXX
)


target_link_libraries(
    UnitTest
    PUBLIC
    IMSRG
    Parameters
    PhysicalConstants
    Version
    OpenMP::OpenMP_CXX
)


# Install imsrg executable
install(TARGETS imsrg++ 
        DESTINATION ${INSTDIR}/bin 
        PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ  GROUP_EXECUTE WORLD_READ WORLD_EXECUTE) 

# Install library
install(TARGETS IMSRG  
        DESTINATION ${INSTDIR}/lib 
        PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ  GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

# Install the header files
file(GLOB HEADERS *.hh)
install(FILES ${HEADERS} 
        DESTINATION ${INSTDIR}/include
        PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ  GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
