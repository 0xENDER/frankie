# Check the build mode
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    # Store output files in the 'Debug' subfolder
    set(FRANKIE_BINARY_MODE "Debug")
    message(STATUS "[BUILD] Build set to 'Debug' mode.")
else()
    if(NOT CMAKE_BUILD_TYPE STREQUAL "Release")
        message(WARNING "[BUILD] Invalid build mode detected! Defaulting to the 'Release' build mode.")
    else()
        message(STATUS "[BUILD] Detected the 'Release' build mode.")
    endif()
    # Store output files in the 'Release' subfolder
    set(FRANKIE_BINARY_MODE "Release")
    message(STATUS "[BUILD] Build set to 'Release' mode.")
endif()

# Get the current build architecture
project(ArchitectureSpecificBuild)
if(CMAKE_GENERATOR_PLATFORM)
    if(${CMAKE_GENERATOR_PLATFORM} STREQUAL "Win32")
        set(FRANKIE_BINARY_PLATFORM "x86_32")
    elseif(${CMAKE_GENERATOR_PLATFORM} STREQUAL "x64")
        set(FRANKIE_BINARY_PLATFORM "x86_64")
#    elseif(${CMAKE_GENERATOR_PLATFORM} STREQUAL "ARM") # Not supported on GitHub Actions
#        set(FRANKIE_BINARY_PLATFORM "arm32")
#    elseif(${CMAKE_GENERATOR_PLATFORM} STREQUAL "ARM64") # Not supported on GitHub Actions
#        set(FRANKIE_BINARY_PLATFORM "arm64")
    else()
        message(FATAL_ERROR "[BUILD] Couldn't determine the target architecture for the build on Windows.")
    endif()
elseif(CMAKE_UNIX_GENERATOR_PLATFORM)
    if(${CMAKE_UNIX_GENERATOR_PLATFORM} STREQUAL "x86")
        add_c_cpp_global_flag("-arch x86_32")
        add_c_cpp_global_flag("-m32")
        set(FRANKIE_BINARY_PLATFORM "x86_32")
    elseif(${CMAKE_UNIX_GENERATOR_PLATFORM} STREQUAL "x64")
        add_c_cpp_global_flag("-arch x86_64")
        add_c_cpp_global_flag("-m64")
        add_c_cpp_global_flag("-march=x86-64")
        set(FRANKIE_BINARY_PLATFORM "x86_64")
    elseif(${CMAKE_UNIX_GENERATOR_PLATFORM} STREQUAL "ARM")
        add_c_cpp_global_flag("-arch arm64")
        add_c_cpp_global_flag("-marm")
        add_c_cpp_global_flag("-march=armv7-a")
        set(FRANKIE_BINARY_PLATFORM "arm32")
    elseif(${CMAKE_UNIX_GENERATOR_PLATFORM} STREQUAL "ARM64")
        add_c_cpp_global_flag("-arch arm64")
        add_c_cpp_global_flag("-mabi=lp64")
        add_c_cpp_global_flag("-mfpu=neon-fp-armv8")
        add_c_cpp_global_flag("-march=armv8-a")
        set(FRANKIE_BINARY_PLATFORM "arm64")
    else()
        message(FATAL_ERROR "[BUILD] Couldn't determine the target architecture for the build on Windows.")
    endif()
else()
    message(FATAL_ERROR "[BUILD] Couldn't determine the target architecture for the build.")
endif()

# Set the desired CMake binary output directory
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${FRANKIE_BINARY_DIR}/${FRANKIE_BINARY_MODE}/${FRANKIE_BINARY_PLATFORM}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${FRANKIE_BINARY_DIR}/${FRANKIE_BINARY_MODE}/${FRANKIE_BINARY_PLATFORM}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${FRANKIE_BINARY_DIR}/${FRANKIE_BINARY_MODE}/${FRANKIE_BINARY_PLATFORM}/lib)

# Clear configuration-specific variables
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${FRANKIE_BINARY_DIR}/Debug/${FRANKIE_BINARY_PLATFORM}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${FRANKIE_BINARY_DIR}/Release/${FRANKIE_BINARY_PLATFORM}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${FRANKIE_BINARY_DIR}/Debug/${FRANKIE_BINARY_PLATFORM}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${FRANKIE_BINARY_DIR}/Release/${FRANKIE_BINARY_PLATFORM}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${FRANKIE_BINARY_DIR}/Debug/${FRANKIE_BINARY_PLATFORM}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${FRANKIE_BINARY_DIR}/Release/${FRANKIE_BINARY_PLATFORM}/lib)

# Libraries
if(WIN32)
    set(CMAKE_SHARED_LIBRARY_SUFFIX ".dll")
endif()
