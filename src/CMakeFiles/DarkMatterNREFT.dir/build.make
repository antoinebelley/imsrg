# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.23

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
CMAKE_COMMAND = /cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/cmake/3.23.1/bin/cmake

# The command to remove a file.
RM = /cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/cmake/3.23.1/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/belleya/projects/def-holt/belleya/imsrg/src

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/belleya/projects/def-holt/belleya/imsrg/src

# Include any dependencies generated for this target.
include CMakeFiles/DarkMatterNREFT.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/DarkMatterNREFT.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/DarkMatterNREFT.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/DarkMatterNREFT.dir/flags.make

CMakeFiles/DarkMatterNREFT.dir/DarkMatterNREFT.cc.o: CMakeFiles/DarkMatterNREFT.dir/flags.make
CMakeFiles/DarkMatterNREFT.dir/DarkMatterNREFT.cc.o: DarkMatterNREFT.cc
CMakeFiles/DarkMatterNREFT.dir/DarkMatterNREFT.cc.o: CMakeFiles/DarkMatterNREFT.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/belleya/projects/def-holt/belleya/imsrg/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/DarkMatterNREFT.dir/DarkMatterNREFT.cc.o"
	/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/DarkMatterNREFT.dir/DarkMatterNREFT.cc.o -MF CMakeFiles/DarkMatterNREFT.dir/DarkMatterNREFT.cc.o.d -o CMakeFiles/DarkMatterNREFT.dir/DarkMatterNREFT.cc.o -c /home/belleya/projects/def-holt/belleya/imsrg/src/DarkMatterNREFT.cc

CMakeFiles/DarkMatterNREFT.dir/DarkMatterNREFT.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/DarkMatterNREFT.dir/DarkMatterNREFT.cc.i"
	/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/belleya/projects/def-holt/belleya/imsrg/src/DarkMatterNREFT.cc > CMakeFiles/DarkMatterNREFT.dir/DarkMatterNREFT.cc.i

CMakeFiles/DarkMatterNREFT.dir/DarkMatterNREFT.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/DarkMatterNREFT.dir/DarkMatterNREFT.cc.s"
	/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/belleya/projects/def-holt/belleya/imsrg/src/DarkMatterNREFT.cc -o CMakeFiles/DarkMatterNREFT.dir/DarkMatterNREFT.cc.s

# Object files for target DarkMatterNREFT
DarkMatterNREFT_OBJECTS = \
"CMakeFiles/DarkMatterNREFT.dir/DarkMatterNREFT.cc.o"

# External object files for target DarkMatterNREFT
DarkMatterNREFT_EXTERNAL_OBJECTS =

libDarkMatterNREFT.a: CMakeFiles/DarkMatterNREFT.dir/DarkMatterNREFT.cc.o
libDarkMatterNREFT.a: CMakeFiles/DarkMatterNREFT.dir/build.make
libDarkMatterNREFT.a: CMakeFiles/DarkMatterNREFT.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/belleya/projects/def-holt/belleya/imsrg/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library libDarkMatterNREFT.a"
	$(CMAKE_COMMAND) -P CMakeFiles/DarkMatterNREFT.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/DarkMatterNREFT.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/DarkMatterNREFT.dir/build: libDarkMatterNREFT.a
.PHONY : CMakeFiles/DarkMatterNREFT.dir/build

CMakeFiles/DarkMatterNREFT.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/DarkMatterNREFT.dir/cmake_clean.cmake
.PHONY : CMakeFiles/DarkMatterNREFT.dir/clean

CMakeFiles/DarkMatterNREFT.dir/depend:
	cd /home/belleya/projects/def-holt/belleya/imsrg/src && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/belleya/projects/def-holt/belleya/imsrg/src /home/belleya/projects/def-holt/belleya/imsrg/src /home/belleya/projects/def-holt/belleya/imsrg/src /home/belleya/projects/def-holt/belleya/imsrg/src /home/belleya/projects/def-holt/belleya/imsrg/src/CMakeFiles/DarkMatterNREFT.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/DarkMatterNREFT.dir/depend

