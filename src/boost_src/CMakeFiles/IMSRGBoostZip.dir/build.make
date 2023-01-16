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
include boost_src/CMakeFiles/IMSRGBoostZip.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include boost_src/CMakeFiles/IMSRGBoostZip.dir/compiler_depend.make

# Include the progress variables for this target.
include boost_src/CMakeFiles/IMSRGBoostZip.dir/progress.make

# Include the compile flags for this target's objects.
include boost_src/CMakeFiles/IMSRGBoostZip.dir/flags.make

boost_src/CMakeFiles/IMSRGBoostZip.dir/gzip.cpp.o: boost_src/CMakeFiles/IMSRGBoostZip.dir/flags.make
boost_src/CMakeFiles/IMSRGBoostZip.dir/gzip.cpp.o: boost_src/gzip.cpp
boost_src/CMakeFiles/IMSRGBoostZip.dir/gzip.cpp.o: boost_src/CMakeFiles/IMSRGBoostZip.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/belleya/projects/def-holt/belleya/imsrg/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object boost_src/CMakeFiles/IMSRGBoostZip.dir/gzip.cpp.o"
	cd /home/belleya/projects/def-holt/belleya/imsrg/src/boost_src && /cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT boost_src/CMakeFiles/IMSRGBoostZip.dir/gzip.cpp.o -MF CMakeFiles/IMSRGBoostZip.dir/gzip.cpp.o.d -o CMakeFiles/IMSRGBoostZip.dir/gzip.cpp.o -c /home/belleya/projects/def-holt/belleya/imsrg/src/boost_src/gzip.cpp

boost_src/CMakeFiles/IMSRGBoostZip.dir/gzip.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/IMSRGBoostZip.dir/gzip.cpp.i"
	cd /home/belleya/projects/def-holt/belleya/imsrg/src/boost_src && /cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/belleya/projects/def-holt/belleya/imsrg/src/boost_src/gzip.cpp > CMakeFiles/IMSRGBoostZip.dir/gzip.cpp.i

boost_src/CMakeFiles/IMSRGBoostZip.dir/gzip.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/IMSRGBoostZip.dir/gzip.cpp.s"
	cd /home/belleya/projects/def-holt/belleya/imsrg/src/boost_src && /cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/belleya/projects/def-holt/belleya/imsrg/src/boost_src/gzip.cpp -o CMakeFiles/IMSRGBoostZip.dir/gzip.cpp.s

boost_src/CMakeFiles/IMSRGBoostZip.dir/zlib.cpp.o: boost_src/CMakeFiles/IMSRGBoostZip.dir/flags.make
boost_src/CMakeFiles/IMSRGBoostZip.dir/zlib.cpp.o: boost_src/zlib.cpp
boost_src/CMakeFiles/IMSRGBoostZip.dir/zlib.cpp.o: boost_src/CMakeFiles/IMSRGBoostZip.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/belleya/projects/def-holt/belleya/imsrg/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object boost_src/CMakeFiles/IMSRGBoostZip.dir/zlib.cpp.o"
	cd /home/belleya/projects/def-holt/belleya/imsrg/src/boost_src && /cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT boost_src/CMakeFiles/IMSRGBoostZip.dir/zlib.cpp.o -MF CMakeFiles/IMSRGBoostZip.dir/zlib.cpp.o.d -o CMakeFiles/IMSRGBoostZip.dir/zlib.cpp.o -c /home/belleya/projects/def-holt/belleya/imsrg/src/boost_src/zlib.cpp

boost_src/CMakeFiles/IMSRGBoostZip.dir/zlib.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/IMSRGBoostZip.dir/zlib.cpp.i"
	cd /home/belleya/projects/def-holt/belleya/imsrg/src/boost_src && /cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/belleya/projects/def-holt/belleya/imsrg/src/boost_src/zlib.cpp > CMakeFiles/IMSRGBoostZip.dir/zlib.cpp.i

boost_src/CMakeFiles/IMSRGBoostZip.dir/zlib.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/IMSRGBoostZip.dir/zlib.cpp.s"
	cd /home/belleya/projects/def-holt/belleya/imsrg/src/boost_src && /cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/belleya/projects/def-holt/belleya/imsrg/src/boost_src/zlib.cpp -o CMakeFiles/IMSRGBoostZip.dir/zlib.cpp.s

# Object files for target IMSRGBoostZip
IMSRGBoostZip_OBJECTS = \
"CMakeFiles/IMSRGBoostZip.dir/gzip.cpp.o" \
"CMakeFiles/IMSRGBoostZip.dir/zlib.cpp.o"

# External object files for target IMSRGBoostZip
IMSRGBoostZip_EXTERNAL_OBJECTS =

boost_src/libIMSRGBoostZip.a: boost_src/CMakeFiles/IMSRGBoostZip.dir/gzip.cpp.o
boost_src/libIMSRGBoostZip.a: boost_src/CMakeFiles/IMSRGBoostZip.dir/zlib.cpp.o
boost_src/libIMSRGBoostZip.a: boost_src/CMakeFiles/IMSRGBoostZip.dir/build.make
boost_src/libIMSRGBoostZip.a: boost_src/CMakeFiles/IMSRGBoostZip.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/belleya/projects/def-holt/belleya/imsrg/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking CXX static library libIMSRGBoostZip.a"
	cd /home/belleya/projects/def-holt/belleya/imsrg/src/boost_src && $(CMAKE_COMMAND) -P CMakeFiles/IMSRGBoostZip.dir/cmake_clean_target.cmake
	cd /home/belleya/projects/def-holt/belleya/imsrg/src/boost_src && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/IMSRGBoostZip.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
boost_src/CMakeFiles/IMSRGBoostZip.dir/build: boost_src/libIMSRGBoostZip.a
.PHONY : boost_src/CMakeFiles/IMSRGBoostZip.dir/build

boost_src/CMakeFiles/IMSRGBoostZip.dir/clean:
	cd /home/belleya/projects/def-holt/belleya/imsrg/src/boost_src && $(CMAKE_COMMAND) -P CMakeFiles/IMSRGBoostZip.dir/cmake_clean.cmake
.PHONY : boost_src/CMakeFiles/IMSRGBoostZip.dir/clean

boost_src/CMakeFiles/IMSRGBoostZip.dir/depend:
	cd /home/belleya/projects/def-holt/belleya/imsrg/src && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/belleya/projects/def-holt/belleya/imsrg/src /home/belleya/projects/def-holt/belleya/imsrg/src/boost_src /home/belleya/projects/def-holt/belleya/imsrg/src /home/belleya/projects/def-holt/belleya/imsrg/src/boost_src /home/belleya/projects/def-holt/belleya/imsrg/src/boost_src/CMakeFiles/IMSRGBoostZip.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : boost_src/CMakeFiles/IMSRGBoostZip.dir/depend

