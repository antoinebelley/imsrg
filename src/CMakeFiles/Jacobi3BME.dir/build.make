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
include CMakeFiles/Jacobi3BME.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/Jacobi3BME.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/Jacobi3BME.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/Jacobi3BME.dir/flags.make

CMakeFiles/Jacobi3BME.dir/Jacobi3BME.cc.o: CMakeFiles/Jacobi3BME.dir/flags.make
CMakeFiles/Jacobi3BME.dir/Jacobi3BME.cc.o: Jacobi3BME.cc
CMakeFiles/Jacobi3BME.dir/Jacobi3BME.cc.o: CMakeFiles/Jacobi3BME.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/antoinebelley/Documents/TRIUMF/imsrg/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/Jacobi3BME.dir/Jacobi3BME.cc.o"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/Jacobi3BME.dir/Jacobi3BME.cc.o -MF CMakeFiles/Jacobi3BME.dir/Jacobi3BME.cc.o.d -o CMakeFiles/Jacobi3BME.dir/Jacobi3BME.cc.o -c /Users/antoinebelley/Documents/TRIUMF/imsrg/src/Jacobi3BME.cc

CMakeFiles/Jacobi3BME.dir/Jacobi3BME.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/Jacobi3BME.dir/Jacobi3BME.cc.i"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/antoinebelley/Documents/TRIUMF/imsrg/src/Jacobi3BME.cc > CMakeFiles/Jacobi3BME.dir/Jacobi3BME.cc.i

CMakeFiles/Jacobi3BME.dir/Jacobi3BME.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/Jacobi3BME.dir/Jacobi3BME.cc.s"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/antoinebelley/Documents/TRIUMF/imsrg/src/Jacobi3BME.cc -o CMakeFiles/Jacobi3BME.dir/Jacobi3BME.cc.s

# Object files for target Jacobi3BME
Jacobi3BME_OBJECTS = \
"CMakeFiles/Jacobi3BME.dir/Jacobi3BME.cc.o"

# External object files for target Jacobi3BME
Jacobi3BME_EXTERNAL_OBJECTS =

libJacobi3BME.a: CMakeFiles/Jacobi3BME.dir/Jacobi3BME.cc.o
libJacobi3BME.a: CMakeFiles/Jacobi3BME.dir/build.make
libJacobi3BME.a: CMakeFiles/Jacobi3BME.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/antoinebelley/Documents/TRIUMF/imsrg/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library libJacobi3BME.a"
	$(CMAKE_COMMAND) -P CMakeFiles/Jacobi3BME.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/Jacobi3BME.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/Jacobi3BME.dir/build: libJacobi3BME.a
.PHONY : CMakeFiles/Jacobi3BME.dir/build

CMakeFiles/Jacobi3BME.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/Jacobi3BME.dir/cmake_clean.cmake
.PHONY : CMakeFiles/Jacobi3BME.dir/clean

CMakeFiles/Jacobi3BME.dir/depend:
	cd /Users/antoinebelley/Documents/TRIUMF/imsrg/src && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src/CMakeFiles/Jacobi3BME.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/Jacobi3BME.dir/depend

