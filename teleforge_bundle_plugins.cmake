# TeleForge: copy shipped .py plugins into the runtime plugins/ folder.
#
# Expected -D variables:
#   PLUGINS_SRC - directory containing *.py plugin sources
#   EXE_DIR     - directory containing the built executable

file(MAKE_DIRECTORY "${EXE_DIR}/plugins")
file(GLOB _plugins "${PLUGINS_SRC}/*.py")
foreach (_plugin ${_plugins})
    get_filename_component(_name "${_plugin}" NAME)
    file(COPY "${_plugin}" DESTINATION "${EXE_DIR}/plugins")
    message(STATUS "TeleForge: plugin ${_name} -> ${EXE_DIR}/plugins/")
endforeach()
