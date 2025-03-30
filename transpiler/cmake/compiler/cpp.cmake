# Check for C++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++17" CXX_17_FLAG)
CHECK_CXX_COMPILER_FLAG("-std:c++17" CXX_17_FLAG_MSVC)
if(NOT (CXX_17_FLAG OR CXX_17_FLAG_MSVC))
    message(FATAL_ERROR "[C++] C++17 is not supported by the compiler. Please use a compiler that supports C++17.")
endif()

# Force PIC
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Set character set flags based on compiler (Must be set to UTF-8)
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    # GCC or Clang
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -finput-charset=UTF-8 -fexec-charset=UTF-8")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    # MSVC
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /utf-8")
else()
    # Other compilers (optional)
    message(FATAL_ERROR "[C++] Compiler ${CMAKE_CXX_COMPILER_ID} not recognized. Character set flags not set.")
endif()

# Warning flags (only for internal targets)
function(add_internal_target_cxx_flags TARGET)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        # GCC or Clang
        target_compile_options(${TARGET} PRIVATE
            -Wall
            -Wshadow
            -Wpointer-arith
            -Wcast-align
            -Wstrict-overflow=4
            -Wwrite-strings
            -Wcast-qual
            -Wconversion
            -Wunreachable-code
        )
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        # MSVC
        target_compile_options(${TARGET} PRIVATE
            /W4

            /weC4456 # Declaration of identifier hides previous local declaration.
            /weC4457 # Declaration of member hides previous local declaration.
            /weC4458 # Declaration of identifier hides class member.
            /weC4459 # Declaration of formal parameter shadows global declaration.

            /weC4826 # Conversion from type 'type1' to type 'type2' requires reinterpretation of object representation.

            /weC4230 # nonstandard extension used: string literal used for array initialization.
            /weC4244 # conversion from 'const char [N]' to 'char *', possible loss of data.

            /weC4180 # qualifier applied to function type has no meaning; ignored.
            /weC4190 # 'identifier' has C-linkage specified, but returns UDT 'type' which is not C-linkage-compatible.

            /weC4244 # conversion from 'type1' to 'type2', possible loss of data.
            /weC4242 # conversion from 'type1' to 'type2', possible loss of data.

            /weC4702 # unreachable code.
        )
    else()
        # Other compilers (optional)
        message(FATAL_ERROR "[C++] Compiler ${CMAKE_CXX_COMPILER_ID} not recognized. Can't set the proper warning flags.")
    endif()
endfunction()

# Treat compiler warnings as errors
set(CMAKE_COMPILE_WARNING_AS_ERROR ON)

# Check for VS
# (MSVC)
#find_package(Visual Studio)
#if(MSVC)
#    message(SEND_WARNING "[DEPENDENCIES] What version of Visual Studio version do you use? (Professional/Community - default is Community):")
#    set(BUILD_VS_EDITION "Community" CACHE STRING "Professional" FORCE)
#endif()

# Make adding global C/C++ flags easier
function(add_c_cpp_global_flag flag)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${flag}")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${flag}")
endfunction()

# Make adding global compile definitions easier
function(add_global_compile_definition definition)
    get_property(targets GLOBAL PROPERTY ALL_TARGETS)
    foreach(target ${targets})
        if(TARGET ${target})
            target_compile_definitions(${target} PRIVATE ${definition})
        endif()
    endforeach()
endfunction()

include(CheckCCompilerFlag)

# Test for address sanitizer support
set(CMAKE_REQUIRED_FLAGS "-fsanitize=address")
check_c_compiler_flag("-fsanitize=address" CMAKE_CXX_SUPPORTS_FSANITIZE_ADDRESS)
# Test for undefined behavior sanitizer support
set(CMAKE_REQUIRED_FLAGS "-fsanitize=undefined")
check_c_compiler_flag("-fsanitize=undefined" CMAKE_CXX_SUPPORTS_FSANITIZE_UNDEFINED)
# Test for thread sanitizer support
set(CMAKE_REQUIRED_FLAGS "-fsanitize=thread")
check_c_compiler_flag("-fsanitize=thread" CMAKE_CXX_SUPPORTS_FSANITIZE_THREAD)
# Test for memory sanitizer support
set(CMAKE_REQUIRED_FLAGS "-fsanitize=memory")
check_c_compiler_flag("-fsanitize=memory" CMAKE_CXX_SUPPORTS_FSANITIZE_MEMORY)
# Test for leak sanitizer support
set(CMAKE_REQUIRED_FLAGS "-fsanitize=leak")
check_c_compiler_flag("-fsanitize=leak" CMAKE_CXX_SUPPORTS_FSANITIZE_LEAK)
# Test for address and undefined sanitizer support combined.
set(CMAKE_REQUIRED_FLAGS "-fsanitize=address,undefined")
check_c_compiler_flag("-fsanitize=address,undefined" CMAKE_CXX_SUPPORTS_FSANITIZE_ADDRESS_UNDEFINED)
