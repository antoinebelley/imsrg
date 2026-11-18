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

if(USE_ARMADILLO_EXTERN)
    list(APPEND ARMADILLO_LIBS armadillo)
else()
    list(APPEND ARMADILLO_LIBS ${ARMADILLO_LIBRARIES})
endif()

add_subdirectory(Commutator)
add_subdirectory(ReferenceImplementations)
add_subdirectory(ThreeBodyME)
add_subdirectory(imsrg_util)

# add_subdirectory(profiling)

# Add a custom command that produces version.cpp, plus
# a dummy output that's not actually produced, in order
# to force version.cmake to always be re-run before the build
ADD_CUSTOM_COMMAND(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/version.cc
           ${CMAKE_CURRENT_BINARY_DIR}/_version.cc
    COMMAND ${CMAKE_COMMAND} -P
            ${CMAKE_CURRENT_SOURCE_DIR}/git_version.cmake)


add_library(
    AngMom  OBJECT
    AngMom.hh AngMom.cc
    AngMomCache.hh AngMomCache.cc
)
target_link_libraries(
    AngMom
    PRIVATE
    GSL::gsl
)


add_library(
    IMSRGProfiler OBJECT
    IMSRGProfiler.hh IMSRGProfiler.cc
)
target_link_libraries(
    IMSRGProfiler
    PRIVATE
    OpenMP::OpenMP_CXX
)

add_library(
    ModelSpace  OBJECT
    ModelSpace.hh ModelSpace.cc
    TwoBodyChannel.cc
    ThreeBodyChannel.cc
)
target_link_libraries(
    ModelSpace
    PUBLIC
    ${ARMADILLO_LIBS}
    IMSRGProfiler
    AngMom
    PRIVATE
    OpenMP::OpenMP_CXX
)

add_library(
    PhysicalConstants
    INTERFACE
    PhysicalConstants.hh
)

add_library(
    TwoBodyME  OBJECT
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
    ThreeLegME OBJECT
    ThreeLegME.hh ThreeLegME.cc
)
target_link_libraries(
    ThreeLegME
    PUBLIC
    ${ARMADILLO_LIBS}
    ModelSpace
    PRIVATE
    # ${ARMADILLO_LIBRARIES}
    PhysicalConstants
)


#add_library(
#    ThreeBodyME OBJECT
#    ThreeBodyME.hh                           ThreeBodyME_dir/ThreeBodyME.cc
#    ThreeBodyStorage.hh      ThreeBodyME_dir/ThreeBodyStorage.cc
#    ThreeBodyME_dir/ThreeBodyStorage_pn.hh   ThreeBodyME_dir/ThreeBodyStorage_pn.cc
#    ThreeBodyME_dir/ThreeBodyStorage_no2b.hh ThreeBodyME_dir/ThreeBodyStorage_no2b.cc
#    ThreeBodyME_dir/ThreeBodyStorage_mono.hh ThreeBodyME_dir/ThreeBodyStorage_mono.cc
#    ThreeBodyME_dir/ThreeBodyStorage_iso.hh  ThreeBodyME_dir/ThreeBodyStorage_iso.cc
#)
#target_include_directories(
#    ThreeBodyME
#    PRIVATE
#    ${CMAKE_CURRENT_SOURCE_DIR}
#    ${CMAKE_CURRENT_SOURCE_DIR}/ThreeBodyME_dir
#)
#target_link_libraries(
#    ThreeBodyME
#    PUBLIC
#    ModelSpace
#    IMSRGBoostZip
#    HalfPrecision
#    PRIVATE
#    IMSRGProfiler
#    AngMom
#    OpenMP::OpenMP_CXX
#)

add_library(
    Parameters
    INTERFACE
)

add_library(
    Operator  OBJECT
    Operator.hh Operator.cc
)
target_include_directories(
    Operator
    PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/ThreeBodyME
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
    Version  OBJECT
    version.hh
    ${CMAKE_CURRENT_BINARY_DIR}/version.cc
)
target_include_directories(
    Version
    PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
)

add_library(
    ReadWrite  OBJECT
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
    BCH  OBJECT
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
    IMSRGSolver  OBJECT
    IMSRGSolver.hh IMSRGSolver.cc
    IMSRGSolverPV.hh IMSRGSolverPV.cc
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

#add_library(
#    IMSRGSolverPV  OBJECT
#    IMSRGSolverPV.hh IMSRGSolverPV.cc
#)
#target_link_libraries(
#    IMSRGSolverPV
#    PUBLIC
#    IMSRGSolver
#    GeneratorPV
#    PRIVATE
#    Commutator
#)

#add_library(
#    Commutator   OBJECT
#    Commutator.hh Commutator.cc
#    DaggerCommutators.hh DaggerCommutators.cc
#    TensorCommutators.hh TensorCommutators.cc
#    IMSRG3Commutators.hh IMSRG3Commutators.cc
#    FactorizedDoubleCommutator.hh FactorizedDoubleCommutator.cc
#)
#target_link_libraries(
#    Commutator
#    PUBLIC
#    armadillo
#    Operator
#    TwoBodyME
#    ThreeLegME
#    PRIVATE
#    OpenMP::OpenMP_CXX
#    # ${ARMADILLO_LIBRARIES}
#    PhysicalConstants
#    AngMom
#)


add_library(
    Jacobi3BME OBJECT
    Jacobi3BME.hh Jacobi3BME.cc
)
target_link_libraries(
    Jacobi3BME
    PUBLIC
    ModelSpace
    PRIVATE
    AngMom
    IMSRGProfiler
    OpenMP::OpenMP_CXX
)

add_library(
    HartreeFock OBJECT
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




#add_library(
#    imsrg_util OBJECT
#    imsrg_util.hh
#    imsrg_util_dir/imsrg_util.cc
#    imsrg_util_dir/GaussLaguerre.hh
#    imsrg_util_dir/M0nu.hh
#    imsrg_util_dir/M0nu.cc
#    imsrg_util_dir/DarkMatterNREFT.hh
#    imsrg_util_dir/DarkMatterNREFT.cc
#    imsrg_util_dir/Pwd.hh
#    imsrg_util_dir/Pwd.cc
#    imsrg_util_dir/Atomic.cc
##    Helicity.hh Helicity.cc
#)
#target_include_directories(
#    imsrg_util
#    PRIVATE
#    ${CMAKE_CURRENT_SOURCE_DIR}
#    ${CMAKE_CURRENT_SOURCE_DIR}/imsrg_util_dir
#)
#target_link_libraries(
#    imsrg_util
#    PUBLIC
#    ModelSpace
#    Operator
#    HartreeFock
#    PhysicalConstants
#    GSL::gsl
#    PRIVATE
#    OpenMP::OpenMP_CXX
#)

add_library(
    Generator OBJECT
    Generator.hh Generator.cc
    GeneratorPV.hh GeneratorPV.cc
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
#    Commutator
    PhysicalConstants
    OpenMP::OpenMP_CXX
)

#add_library(
#    GeneratorPV OBJECT
#    GeneratorPV.hh GeneratorPV.cc
#)
#target_link_libraries(
#    GeneratorPV
#    PUBLIC
#    ModelSpace
#    Operator
#    PRIVATE
#    Generator
#    GSL::gsl
#    imsrg_util
#    AngMom
##    Commutator
#    PhysicalConstants
#    OpenMP::OpenMP_CXX
#)

add_library(
    HFMBPT OBJECT
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
    Commutator
)



add_library(
    RPA OBJECT
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

#add_library(
#    ReferenceImplementations  OBJECT
#    ReferenceImplementations.hh 
#    ReferenceImplementations.cc
#    HFMBPT4.cc
#    IMSRG2Commutators.cc
#    IMSRG3Commutators.cc
#    IMSRG2TensorCommutators.cc
#    IMSRG3TensorCommutators.cc
#    FactorizedNestedCommutators.cc
#)
#
#target_link_libraries(
#    ReferenceImplementations
#    PUBLIC
#    ModelSpace
#    Operator
##    Commutator
#    PRIVATE
#    armadillo
#    PhysicalConstants
#    Version
#    imsrg_util
#    AngMom
#    OpenMP::OpenMP_CXX
#)

add_library(
    UnitTest  OBJECT
    UnitTest.hh UnitTest.cc
)
target_link_libraries(
    UnitTest
    PUBLIC
    ModelSpace
    Operator
    PRIVATE
    Commutator
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
    SHARED
)
target_link_libraries(
    IMSRG
#    INTERFACE
    Version
    ReadWrite
    ModelSpace
    TwoBodyME
    ThreeBodyME
    ThreeLegME
    Operator
    HartreeFock
    Commutator
    BCH
    IMSRGSolver
#    IMSRGSolverPV
    Generator
#    GeneratorPV
    imsrg_util
#    M0nu
#    Pwd
    AngMom
    IMSRGProfiler
    Jacobi3BME
#    DarkMatterNREFT
    HFMBPT
    UnitTest
    ReferenceImplementations
    PhysicalConstants
    RPA
)
set_target_properties(IMSRG PROPERTIES SUFFIX ".so")
set_target_properties(IMSRG PROPERTIES LINKER_LANGUAGE CXX)


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


#target_link_libraries(
#    UnitTest
#    PUBLIC
#    IMSRG
#    Parameters
#    PhysicalConstants
#    Version
#    OpenMP::OpenMP_CXX
#)


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

