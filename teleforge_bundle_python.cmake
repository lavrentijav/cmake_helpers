# TeleForge: bundle the embedded CPython runtime next to the executable.
#
# Invoked at build time via `cmake -P`. It is a no-op once the bundle exists,
# so normal incremental builds do not re-copy the (large) standard library.
#
# Expected -D variables:
#   PY_SRC  - CPython source/build root (contains Lib/ and PCbuild/amd64)
#   EXE_DIR - directory containing the built executable
#   PKG_SRC - path to the `teleforge` python package directory to ship

set(_modules "${EXE_DIR}/modules")
set(_marker "${_modules}/Lib/os.py")

# Always refresh the small teleforge package (cheap, lets API edits propagate).
if (EXISTS "${PKG_SRC}")
    file(COPY "${PKG_SRC}" DESTINATION "${_modules}")
endif()

# Runtime DLLs next to the exe (python314.dll + extension dependencies).
file(GLOB _dlls "${PY_SRC}/PCbuild/amd64/*.dll")
foreach (_dll ${_dlls})
    get_filename_component(_name "${_dll}" NAME)
    if (NOT EXISTS "${EXE_DIR}/${_name}")
        file(COPY "${_dll}" DESTINATION "${EXE_DIR}")
    endif()
endforeach()

if (EXISTS "${_marker}")
    return()
endif()

message(STATUS "TeleForge: bundling Python stdlib into ${_modules}")
file(MAKE_DIRECTORY "${_modules}")
file(COPY "${PY_SRC}/Lib" DESTINATION "${_modules}")

file(MAKE_DIRECTORY "${_modules}/DLLs")
file(GLOB _pyds "${PY_SRC}/PCbuild/amd64/*.pyd")
foreach (_pyd ${_pyds})
    file(COPY "${_pyd}" DESTINATION "${_modules}/DLLs")
endforeach()
