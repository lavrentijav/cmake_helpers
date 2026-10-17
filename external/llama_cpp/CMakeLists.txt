# Optional in-process llama.cpp (TeleForge links llama + llama-common into Telegram).

if (NOT DESKTOP_APP_USE_LLAMA_CPP)
    return()
endif()

set(_default_llama_root "${CMAKE_SOURCE_DIR}/../Libraries/win64/llama.cpp")
set(LLAMA_CPP_ROOT "${_default_llama_root}" CACHE PATH "Path to a checked-out ggml-org/llama.cpp tree")

if (NOT EXISTS "${LLAMA_CPP_ROOT}/CMakeLists.txt")
    message(WARNING "DESKTOP_APP_USE_LLAMA_CPP is ON but LLAMA_CPP_ROOT has no CMakeLists.txt: ${LLAMA_CPP_ROOT}")
    return()
endif()

message(STATUS "Building llama.cpp (TeleForge in-process) from LLAMA_CPP_ROOT=${LLAMA_CPP_ROOT}")

set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)

set(LLAMA_BUILD_COMMON ON CACHE BOOL "" FORCE)
set(LLAMA_BUILD_TOOLS OFF CACHE BOOL "" FORCE)
set(LLAMA_BUILD_SERVER OFF CACHE BOOL "" FORCE)
set(LLAMA_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(LLAMA_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(LLAMA_BUILD_WEBUI OFF CACHE BOOL "" FORCE)

add_subdirectory("${LLAMA_CPP_ROOT}" "${CMAKE_BINARY_DIR}/third_party/llama_cpp_build" EXCLUDE_FROM_ALL)
