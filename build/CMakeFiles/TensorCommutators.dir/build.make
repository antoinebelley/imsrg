# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.27

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
CMAKE_COMMAND = /usr/local/Cellar/cmake/3.27.7/bin/cmake

# The command to remove a file.
RM = /usr/local/Cellar/cmake/3.27.7/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/antoinebelley/Documents/TRIUMF/imsrg/src

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/antoinebelley/Documents/TRIUMF/imsrg/build

# Include any dependencies generated for this target.
include CMakeFiles/TensorCommutators.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/TensorCommutators.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/TensorCommutators.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/TensorCommutators.dir/flags.make

CMakeFiles/TensorCommutators.dir/TensorCommutators.cc.o: CMakeFiles/TensorCommutators.dir/flags.make
CMakeFiles/TensorCommutators.dir/TensorCommutators.cc.o: /Users/antoinebelley/Documents/TRIUMF/imsrg/src/TensorCommutators.cc
CMakeFiles/TensorCommutators.dir/TensorCommutators.cc.o: CMakeFiles/TensorCommutators.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/Users/antoinebelley/Documents/TRIUMF/imsrg/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/TensorCommutators.dir/TensorCommutators.cc.o"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/TensorCommutators.dir/TensorCommutators.cc.o -MF CMakeFiles/TensorCommutators.dir/TensorCommutators.cc.o.d -o CMakeFiles/TensorCommutators.dir/TensorCommutators.cc.o -c /Users/antoinebelley/Documents/TRIUMF/imsrg/src/TensorCommutators.cc

CMakeFiles/TensorCommutators.dir/TensorCommutators.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/TensorCommutators.dir/TensorCommutators.cc.i"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/antoinebelley/Documents/TRIUMF/imsrg/src/TensorCommutators.cc > CMakeFiles/TensorCommutators.dir/TensorCommutators.cc.i

CMakeFiles/TensorCommutators.dir/TensorCommutators.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/TensorCommutators.dir/TensorCommutators.cc.s"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/antoinebelley/Documents/TRIUMF/imsrg/src/TensorCommutators.cc -o CMakeFiles/TensorCommutators.dir/TensorCommutators.cc.s

# Object files for target TensorCommutators
TensorCommutators_OBJECTS = \
"CMakeFiles/TensorCommutators.dir/TensorCommutators.cc.o"

# External object files for target TensorCommutators
TensorCommutators_EXTERNAL_OBJECTS =

libTensorCommutators.a: CMakeFiles/TensorCommutators.dir/TensorCommutators.cc.o
libTensorCommutators.a: CMakeFiles/TensorCommutators.dir/build.make
libTensorCommutators.a: CMakeFiles/TensorCommutators.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/Users/antoinebelley/Documents/TRIUMF/imsrg/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library libTensorCommutators.a"
	$(CMAKE_COMMAND) -P CMakeFiles/TensorCommutators.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/TensorCommutators.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/TensorCommutators.dir/build: libTensorCommutators.a
.PHONY : CMakeFiles/TensorCommutators.dir/build

CMakeFiles/TensorCommutators.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/TensorCommutators.dir/cmake_clean.cmake
.PHONY : CMakeFiles/TensorCommutators.dir/clean

CMakeFiles/TensorCommutators.dir/depend:
	cd /Users/antoinebelley/Documents/TRIUMF/imsrg/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/build /Users/antoinebelley/Documents/TRIUMF/imsrg/build /Users/antoinebelley/Documents/TRIUMF/imsrg/build/CMakeFiles/TensorCommutators.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : CMakeFiles/TensorCommutators.dir/depend

