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
CMAKE_BINARY_DIR = /Users/antoinebelley/Documents/TRIUMF/imsrg/build

# Include any dependencies generated for this target.
include CMakeFiles/Operator.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/Operator.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/Operator.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/Operator.dir/flags.make

CMakeFiles/Operator.dir/Operator.cc.o: CMakeFiles/Operator.dir/flags.make
CMakeFiles/Operator.dir/Operator.cc.o: /Users/antoinebelley/Documents/TRIUMF/imsrg/src/Operator.cc
CMakeFiles/Operator.dir/Operator.cc.o: CMakeFiles/Operator.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/antoinebelley/Documents/TRIUMF/imsrg/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/Operator.dir/Operator.cc.o"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/Operator.dir/Operator.cc.o -MF CMakeFiles/Operator.dir/Operator.cc.o.d -o CMakeFiles/Operator.dir/Operator.cc.o -c /Users/antoinebelley/Documents/TRIUMF/imsrg/src/Operator.cc

CMakeFiles/Operator.dir/Operator.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/Operator.dir/Operator.cc.i"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/antoinebelley/Documents/TRIUMF/imsrg/src/Operator.cc > CMakeFiles/Operator.dir/Operator.cc.i

CMakeFiles/Operator.dir/Operator.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/Operator.dir/Operator.cc.s"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/antoinebelley/Documents/TRIUMF/imsrg/src/Operator.cc -o CMakeFiles/Operator.dir/Operator.cc.s

# Object files for target Operator
Operator_OBJECTS = \
"CMakeFiles/Operator.dir/Operator.cc.o"

# External object files for target Operator
Operator_EXTERNAL_OBJECTS =

libOperator.a: CMakeFiles/Operator.dir/Operator.cc.o
libOperator.a: CMakeFiles/Operator.dir/build.make
libOperator.a: CMakeFiles/Operator.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/antoinebelley/Documents/TRIUMF/imsrg/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library libOperator.a"
	$(CMAKE_COMMAND) -P CMakeFiles/Operator.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/Operator.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/Operator.dir/build: libOperator.a
.PHONY : CMakeFiles/Operator.dir/build

CMakeFiles/Operator.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/Operator.dir/cmake_clean.cmake
.PHONY : CMakeFiles/Operator.dir/clean

CMakeFiles/Operator.dir/depend:
	cd /Users/antoinebelley/Documents/TRIUMF/imsrg/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/build /Users/antoinebelley/Documents/TRIUMF/imsrg/build /Users/antoinebelley/Documents/TRIUMF/imsrg/build/CMakeFiles/Operator.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/Operator.dir/depend

