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
include CMakeFiles/ThreeBodyStorage_no2b.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/ThreeBodyStorage_no2b.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/ThreeBodyStorage_no2b.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/ThreeBodyStorage_no2b.dir/flags.make

CMakeFiles/ThreeBodyStorage_no2b.dir/ThreeBodyStorage_no2b.cc.o: CMakeFiles/ThreeBodyStorage_no2b.dir/flags.make
CMakeFiles/ThreeBodyStorage_no2b.dir/ThreeBodyStorage_no2b.cc.o: ThreeBodyStorage_no2b.cc
CMakeFiles/ThreeBodyStorage_no2b.dir/ThreeBodyStorage_no2b.cc.o: CMakeFiles/ThreeBodyStorage_no2b.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/belleya/projects/def-holt/belleya/imsrg/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/ThreeBodyStorage_no2b.dir/ThreeBodyStorage_no2b.cc.o"
	/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/ThreeBodyStorage_no2b.dir/ThreeBodyStorage_no2b.cc.o -MF CMakeFiles/ThreeBodyStorage_no2b.dir/ThreeBodyStorage_no2b.cc.o.d -o CMakeFiles/ThreeBodyStorage_no2b.dir/ThreeBodyStorage_no2b.cc.o -c /home/belleya/projects/def-holt/belleya/imsrg/src/ThreeBodyStorage_no2b.cc

CMakeFiles/ThreeBodyStorage_no2b.dir/ThreeBodyStorage_no2b.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/ThreeBodyStorage_no2b.dir/ThreeBodyStorage_no2b.cc.i"
	/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/belleya/projects/def-holt/belleya/imsrg/src/ThreeBodyStorage_no2b.cc > CMakeFiles/ThreeBodyStorage_no2b.dir/ThreeBodyStorage_no2b.cc.i

CMakeFiles/ThreeBodyStorage_no2b.dir/ThreeBodyStorage_no2b.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/ThreeBodyStorage_no2b.dir/ThreeBodyStorage_no2b.cc.s"
	/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/belleya/projects/def-holt/belleya/imsrg/src/ThreeBodyStorage_no2b.cc -o CMakeFiles/ThreeBodyStorage_no2b.dir/ThreeBodyStorage_no2b.cc.s

# Object files for target ThreeBodyStorage_no2b
ThreeBodyStorage_no2b_OBJECTS = \
"CMakeFiles/ThreeBodyStorage_no2b.dir/ThreeBodyStorage_no2b.cc.o"

# External object files for target ThreeBodyStorage_no2b
ThreeBodyStorage_no2b_EXTERNAL_OBJECTS =

libThreeBodyStorage_no2b.a: CMakeFiles/ThreeBodyStorage_no2b.dir/ThreeBodyStorage_no2b.cc.o
libThreeBodyStorage_no2b.a: CMakeFiles/ThreeBodyStorage_no2b.dir/build.make
libThreeBodyStorage_no2b.a: CMakeFiles/ThreeBodyStorage_no2b.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/belleya/projects/def-holt/belleya/imsrg/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library libThreeBodyStorage_no2b.a"
	$(CMAKE_COMMAND) -P CMakeFiles/ThreeBodyStorage_no2b.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/ThreeBodyStorage_no2b.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/ThreeBodyStorage_no2b.dir/build: libThreeBodyStorage_no2b.a
.PHONY : CMakeFiles/ThreeBodyStorage_no2b.dir/build

CMakeFiles/ThreeBodyStorage_no2b.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/ThreeBodyStorage_no2b.dir/cmake_clean.cmake
.PHONY : CMakeFiles/ThreeBodyStorage_no2b.dir/clean

CMakeFiles/ThreeBodyStorage_no2b.dir/depend:
	cd /home/belleya/projects/def-holt/belleya/imsrg/src && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/belleya/projects/def-holt/belleya/imsrg/src /home/belleya/projects/def-holt/belleya/imsrg/src /home/belleya/projects/def-holt/belleya/imsrg/src /home/belleya/projects/def-holt/belleya/imsrg/src /home/belleya/projects/def-holt/belleya/imsrg/src/CMakeFiles/ThreeBodyStorage_no2b.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/ThreeBodyStorage_no2b.dir/depend

