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
include CMakeFiles/Helicity.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/Helicity.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/Helicity.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/Helicity.dir/flags.make

CMakeFiles/Helicity.dir/Helicity.cc.o: CMakeFiles/Helicity.dir/flags.make
CMakeFiles/Helicity.dir/Helicity.cc.o: Helicity.cc
CMakeFiles/Helicity.dir/Helicity.cc.o: CMakeFiles/Helicity.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/antoinebelley/Documents/TRIUMF/imsrg/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/Helicity.dir/Helicity.cc.o"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/Helicity.dir/Helicity.cc.o -MF CMakeFiles/Helicity.dir/Helicity.cc.o.d -o CMakeFiles/Helicity.dir/Helicity.cc.o -c /Users/antoinebelley/Documents/TRIUMF/imsrg/src/Helicity.cc

CMakeFiles/Helicity.dir/Helicity.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/Helicity.dir/Helicity.cc.i"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/antoinebelley/Documents/TRIUMF/imsrg/src/Helicity.cc > CMakeFiles/Helicity.dir/Helicity.cc.i

CMakeFiles/Helicity.dir/Helicity.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/Helicity.dir/Helicity.cc.s"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/antoinebelley/Documents/TRIUMF/imsrg/src/Helicity.cc -o CMakeFiles/Helicity.dir/Helicity.cc.s

# Object files for target Helicity
Helicity_OBJECTS = \
"CMakeFiles/Helicity.dir/Helicity.cc.o"

# External object files for target Helicity
Helicity_EXTERNAL_OBJECTS =

libHelicity.a: CMakeFiles/Helicity.dir/Helicity.cc.o
libHelicity.a: CMakeFiles/Helicity.dir/build.make
libHelicity.a: CMakeFiles/Helicity.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/antoinebelley/Documents/TRIUMF/imsrg/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library libHelicity.a"
	$(CMAKE_COMMAND) -P CMakeFiles/Helicity.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/Helicity.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/Helicity.dir/build: libHelicity.a
.PHONY : CMakeFiles/Helicity.dir/build

CMakeFiles/Helicity.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/Helicity.dir/cmake_clean.cmake
.PHONY : CMakeFiles/Helicity.dir/clean

CMakeFiles/Helicity.dir/depend:
	cd /Users/antoinebelley/Documents/TRIUMF/imsrg/src && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src/CMakeFiles/Helicity.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/Helicity.dir/depend

