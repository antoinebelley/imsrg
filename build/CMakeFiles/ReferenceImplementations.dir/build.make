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
include CMakeFiles/ReferenceImplementations.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/ReferenceImplementations.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/ReferenceImplementations.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/ReferenceImplementations.dir/flags.make

CMakeFiles/ReferenceImplementations.dir/ReferenceImplementations.cc.o: CMakeFiles/ReferenceImplementations.dir/flags.make
CMakeFiles/ReferenceImplementations.dir/ReferenceImplementations.cc.o: /Users/antoinebelley/Documents/TRIUMF/imsrg/src/ReferenceImplementations.cc
CMakeFiles/ReferenceImplementations.dir/ReferenceImplementations.cc.o: CMakeFiles/ReferenceImplementations.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/antoinebelley/Documents/TRIUMF/imsrg/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/ReferenceImplementations.dir/ReferenceImplementations.cc.o"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/ReferenceImplementations.dir/ReferenceImplementations.cc.o -MF CMakeFiles/ReferenceImplementations.dir/ReferenceImplementations.cc.o.d -o CMakeFiles/ReferenceImplementations.dir/ReferenceImplementations.cc.o -c /Users/antoinebelley/Documents/TRIUMF/imsrg/src/ReferenceImplementations.cc

CMakeFiles/ReferenceImplementations.dir/ReferenceImplementations.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/ReferenceImplementations.dir/ReferenceImplementations.cc.i"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/antoinebelley/Documents/TRIUMF/imsrg/src/ReferenceImplementations.cc > CMakeFiles/ReferenceImplementations.dir/ReferenceImplementations.cc.i

CMakeFiles/ReferenceImplementations.dir/ReferenceImplementations.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/ReferenceImplementations.dir/ReferenceImplementations.cc.s"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/antoinebelley/Documents/TRIUMF/imsrg/src/ReferenceImplementations.cc -o CMakeFiles/ReferenceImplementations.dir/ReferenceImplementations.cc.s

# Object files for target ReferenceImplementations
ReferenceImplementations_OBJECTS = \
"CMakeFiles/ReferenceImplementations.dir/ReferenceImplementations.cc.o"

# External object files for target ReferenceImplementations
ReferenceImplementations_EXTERNAL_OBJECTS =

libReferenceImplementations.a: CMakeFiles/ReferenceImplementations.dir/ReferenceImplementations.cc.o
libReferenceImplementations.a: CMakeFiles/ReferenceImplementations.dir/build.make
libReferenceImplementations.a: CMakeFiles/ReferenceImplementations.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/antoinebelley/Documents/TRIUMF/imsrg/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library libReferenceImplementations.a"
	$(CMAKE_COMMAND) -P CMakeFiles/ReferenceImplementations.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/ReferenceImplementations.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/ReferenceImplementations.dir/build: libReferenceImplementations.a
.PHONY : CMakeFiles/ReferenceImplementations.dir/build

CMakeFiles/ReferenceImplementations.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/ReferenceImplementations.dir/cmake_clean.cmake
.PHONY : CMakeFiles/ReferenceImplementations.dir/clean

CMakeFiles/ReferenceImplementations.dir/depend:
	cd /Users/antoinebelley/Documents/TRIUMF/imsrg/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/build /Users/antoinebelley/Documents/TRIUMF/imsrg/build /Users/antoinebelley/Documents/TRIUMF/imsrg/build/CMakeFiles/ReferenceImplementations.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/ReferenceImplementations.dir/depend
