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
include CMakeFiles/HFMBPT.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/HFMBPT.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/HFMBPT.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/HFMBPT.dir/flags.make

CMakeFiles/HFMBPT.dir/HFMBPT.cc.o: CMakeFiles/HFMBPT.dir/flags.make
CMakeFiles/HFMBPT.dir/HFMBPT.cc.o: HFMBPT.cc
CMakeFiles/HFMBPT.dir/HFMBPT.cc.o: CMakeFiles/HFMBPT.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/antoinebelley/Documents/TRIUMF/imsrg/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/HFMBPT.dir/HFMBPT.cc.o"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/HFMBPT.dir/HFMBPT.cc.o -MF CMakeFiles/HFMBPT.dir/HFMBPT.cc.o.d -o CMakeFiles/HFMBPT.dir/HFMBPT.cc.o -c /Users/antoinebelley/Documents/TRIUMF/imsrg/src/HFMBPT.cc

CMakeFiles/HFMBPT.dir/HFMBPT.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/HFMBPT.dir/HFMBPT.cc.i"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/antoinebelley/Documents/TRIUMF/imsrg/src/HFMBPT.cc > CMakeFiles/HFMBPT.dir/HFMBPT.cc.i

CMakeFiles/HFMBPT.dir/HFMBPT.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/HFMBPT.dir/HFMBPT.cc.s"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/antoinebelley/Documents/TRIUMF/imsrg/src/HFMBPT.cc -o CMakeFiles/HFMBPT.dir/HFMBPT.cc.s

# Object files for target HFMBPT
HFMBPT_OBJECTS = \
"CMakeFiles/HFMBPT.dir/HFMBPT.cc.o"

# External object files for target HFMBPT
HFMBPT_EXTERNAL_OBJECTS =

libHFMBPT.a: CMakeFiles/HFMBPT.dir/HFMBPT.cc.o
libHFMBPT.a: CMakeFiles/HFMBPT.dir/build.make
libHFMBPT.a: CMakeFiles/HFMBPT.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/antoinebelley/Documents/TRIUMF/imsrg/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library libHFMBPT.a"
	$(CMAKE_COMMAND) -P CMakeFiles/HFMBPT.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/HFMBPT.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/HFMBPT.dir/build: libHFMBPT.a
.PHONY : CMakeFiles/HFMBPT.dir/build

CMakeFiles/HFMBPT.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/HFMBPT.dir/cmake_clean.cmake
.PHONY : CMakeFiles/HFMBPT.dir/clean

CMakeFiles/HFMBPT.dir/depend:
	cd /Users/antoinebelley/Documents/TRIUMF/imsrg/src && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src /Users/antoinebelley/Documents/TRIUMF/imsrg/src/CMakeFiles/HFMBPT.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/HFMBPT.dir/depend
