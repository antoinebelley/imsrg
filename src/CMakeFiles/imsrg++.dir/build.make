# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.22

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/Cellar/cmake/3.22.1/bin/cmake

# The command to remove a file.
RM = /usr/local/Cellar/cmake/3.22.1/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/antoinebelley/Documents/TRIUMF/imsrg/src

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/antoinebelley/Documents/TRIUMF/imsrg/src

# Include any dependencies generated for this target.
include CMakeFiles/imsrg++.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/imsrg++.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/imsrg++.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/imsrg++.dir/flags.make

CMakeFiles/imsrg++.dir/imsrg++.cc.o: CMakeFiles/imsrg++.dir/flags.make
CMakeFiles/imsrg++.dir/imsrg++.cc.o: imsrg++.cc
CMakeFiles/imsrg++.dir/imsrg++.cc.o: CMakeFiles/imsrg++.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/antoinebelley/Documents/TRIUMF/imsrg/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/imsrg++.dir/imsrg++.cc.o"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/imsrg++.dir/imsrg++.cc.o -MF CMakeFiles/imsrg++.dir/imsrg++.cc.o.d -o CMakeFiles/imsrg++.dir/imsrg++.cc.o -c /Users/antoinebelley/Documents/TRIUMF/imsrg/src/imsrg++.cc

CMakeFiles/imsrg++.dir/imsrg++.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/imsrg++.dir/imsrg++.cc.i"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/antoinebelley/Documents/TRIUMF/imsrg/src/imsrg++.cc > CMakeFiles/imsrg++.dir/imsrg++.cc.i

CMakeFiles/imsrg++.dir/imsrg++.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/imsrg++.dir/imsrg++.cc.s"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/antoinebelley/Documents/TRIUMF/imsrg/src/imsrg++.cc -o CMakeFiles/imsrg++.dir/imsrg++.cc.s

# Object files for target imsrg++
imsrg_______OBJECTS = \
"CMakeFiles/imsrg++.dir/imsrg++.cc.o"

# External object files for target imsrg++
imsrg_______EXTERNAL_OBJECTS =

imsrg++: CMakeFiles/imsrg++.dir/imsrg++.cc.o
imsrg++: CMakeFiles/imsrg++.dir/build.make
imsrg++: libVersion.a
imsrg++: libHFMBPT.a
imsrg++: libUnitTest.a
imsrg++: libReferenceImplementations.a
imsrg++: libIMSRGSolver.a
imsrg++: libGenerator.a
imsrg++: libimsrg_util.a
imsrg++: libM0nu.a
imsrg++: libIMSRGSolver.a
imsrg++: libGenerator.a
imsrg++: libimsrg_util.a
imsrg++: libM0nu.a
imsrg++: libReadWrite.a
imsrg++: libVersion.a
imsrg++: libHartreeFock.a
imsrg++: libJacobi3BME.a
imsrg++: libHartreeFock.a
imsrg++: libJacobi3BME.a
imsrg++: libCommutator.a
imsrg++: libCommutator232.a
imsrg++: libDarkMatterNREFT.a
imsrg++: libPwd.a
imsrg++: libRPA.a
imsrg++: libOperator.a
imsrg++: libTwoBodyME.a
imsrg++: libThreeBodyME.a
imsrg++: libThreeBodyStorage_iso.a
imsrg++: libThreeBodyStorage_pn.a
imsrg++: libThreeBodyStorage_no2b.a
imsrg++: libThreeBodyStorage_mono.a
imsrg++: boost_src/libIMSRGBoostZip.a
imsrg++: /Library/Developer/CommandLineTools/SDKs/MacOSX12.1.sdk/usr/lib/libz.tbd
imsrg++: libThreeBodyStorage.a
imsrg++: libThreeLegME.a
imsrg++: libModelSpace.a
imsrg++: libIMSRGProfiler.a
imsrg++: /usr/local/lib/libomp.dylib
imsrg++: libAngMomCache.a
imsrg++: libAngMom.a
imsrg++: /usr/local/Cellar/gsl/2.7/lib/libgsl.dylib
imsrg++: /usr/local/Cellar/gsl/2.7/lib/libgslcblas.dylib
imsrg++: /usr/local/opt/openblas/lib/libopenblas.dylib
imsrg++: CMakeFiles/imsrg++.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/antoinebelley/Documents/TRIUMF/imsrg/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable imsrg++"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/imsrg++.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/imsrg++.dir/build: imsrg++
.PHONY : CMakeFiles/imsrg++.dir/build

CMakeFiles/imsrg++.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/imsrg++.dir/cmake_clean.cmake
.PHONY : CMakeFiles/imsrg++.dir/clean

CMakeFiles/imsrg++.dir/depend:
	cd /Users/antoinebelley/Documents/TRIUMF/imsrg/src && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src/CMakeFiles/imsrg++.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/imsrg++.dir/depend

