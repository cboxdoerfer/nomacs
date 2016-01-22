add_definitions(-DWITH_PLUGINS)

include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
if(COMPILER_SUPPORTS_CXX11)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
elseif(COMPILER_SUPPORTS_CXX0X)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
else()
  message(STATUS "The compiler ${CMAKE_CXX_COMPILER} has no C++11 support. Please use a different C++ compiler.")
endif()
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unknown-pragmas")

# create the targets
set(BINARY_NAME ${CMAKE_PROJECT_NAME})
set(DLL_CORE_NAME ${CMAKE_PROJECT_NAME}Core)
set(DLL_LOADER_NAME ${CMAKE_PROJECT_NAME}Loader)
set(DLL_NAME ${CMAKE_PROJECT_NAME}Gui)

#binary
link_directories(${LIBRAW_LIBRARY_DIRS} ${OpenCV_LIBRARY_DIRS} ${EXIV2_LIBRARY_DIRS} ${CMAKE_BINARY_DIR})
add_executable(${BINARY_NAME} WIN32  MACOSX_BUNDLE ${NOMACS_EXE_SOURCES} ${NOMACS_EXE_HEADERS} ${NOMACS_QM} ${NOMACS_TRANSLATIONS} ${NOMACS_RC} ${QUAZIP_SOURCES} ${WEBP_SOURCE})  
target_link_libraries(${BINARY_NAME} ${DLL_NAME} ${DLL_CORE_NAME} ${DLL_LOADER_NAME} ${EXIV2_LIBRARIES} ${LIBRAW_LIBRARIES} ${OpenCV_LIBS} ${VERSION_LIB} ${TIFF_LIBRARIES} ${HUPNP_LIBS} ${HUPNPAV_LIBS} ${QUAZIP_LIBRARIES} ${WEBP_LIBRARIES} ${WEBP_STATIC_LIBRARIES} ${ZLIB_LIBRARY} ${LIBQPSD_LIBRARY})


set_target_properties(${BINARY_NAME} PROPERTIES COMPILE_FLAGS "-DDK_DLL_IMPORT -DNOMINMAX")
set_target_properties(${BINARY_NAME} PROPERTIES IMPORTED_IMPLIB "")

# add core
add_library(${DLL_CORE_NAME} SHARED ${CORE_SOURCES} ${NOMACS_UI} ${CORE_HEADERS} ${NOMACS_RCC} ${NOMACS_RC})
target_link_libraries(${DLL_CORE_NAME} ${VERSION_LIB} ${OpenCV_LIBS}) 

# add loader
add_library(${DLL_LOADER_NAME} SHARED ${LOADER_SOURCES} ${NOMACS_UI} ${NOMACS_RCC} ${LOADER_HEADERS} ${AUTOFLOW_RC} ${QUAZIP_SOURCES} ${WEBP_SOURCE} ${LIBQPSD_SOURCES} ${LIBQPSD_HEADERS})
target_link_libraries(${DLL_LOADER_NAME} ${DLL_CORE_NAME} ${EXIV2_LIBRARIES} ${LIBRAW_LIBRARIES} ${OpenCV_LIBS} ${VERSION_LIB} ${TIFF_LIBRARIES} ${HUPNP_LIBS} ${HUPNPAV_LIBS} ${QUAZIP_LIBRARIES} ${WEBP_LIBRARY}) 

# add GUI
add_library(${DLL_NAME} SHARED ${GUI_SOURCES} ${NOMACS_UI} ${NOMACS_RCC} ${GUI_HEADERS} ${NOMACS_RC})
target_link_libraries(${DLL_NAME} ${DLL_CORE_NAME} ${DLL_LOADER_NAME} ${EXIV2_LIBRARIES} ${LIBRAW_LIBRARIES} ${OpenCV_LIBS} ${VERSION_LIB} ${TIFF_LIBRARIES} ${HUPNP_LIBS} ${HUPNPAV_LIBS} ${QUAZIP_LIBRARIES} ${WEBP_LIBRARIES} ${WEBP_STATIC_LIBRARIES}) 


add_dependencies(${DLL_LOADER_NAME} ${DLL_CORE_NAME})
add_dependencies(${DLL_NAME} ${DLL_LOADER_NAME} ${DLL_CORE_NAME})
add_dependencies(${BINARY_NAME} ${DLL_NAME} ${DLL_LOADER_NAME} ${DLL_CORE_NAME} ${QUAZIP_DEPENDENCY} ${LIBQPSD_LIBRARY} ${WEBP_LIBRARY} ${WEBP_STATIC_LIBRARIES}) 

qt5_use_modules(${BINARY_NAME} 		Widgets Gui Network LinguistTools PrintSupport Concurrent Svg)
qt5_use_modules(${DLL_NAME} 		Widgets Gui Network LinguistTools PrintSupport Concurrent Svg)
qt5_use_modules(${DLL_LOADER_NAME} 	Widgets Gui Network LinguistTools PrintSupport Concurrent Svg)
qt5_use_modules(${DLL_CORE_NAME} 	Widgets Gui Network LinguistTools PrintSupport Concurrent Svg)

# core flags
set_target_properties(${DLL_CORE_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${CMAKE_CURRENT_BINARY_DIR}/libs)
set_target_properties(${DLL_CORE_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${CMAKE_CURRENT_BINARY_DIR}/libs)
set_target_properties(${DLL_CORE_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_REALLYRELEASE ${CMAKE_CURRENT_BINARY_DIR}/libs)

set_target_properties(${DLL_CORE_NAME} PROPERTIES COMPILE_FLAGS "-DDK_CORE_DLL_EXPORT -DNOMINMAX")
set_target_properties(${DLL_CORE_NAME} PROPERTIES DEBUG_OUTPUT_NAME ${DLL_CORE_NAME}d)
set_target_properties(${DLL_CORE_NAME} PROPERTIES RELEASE_OUTPUT_NAME ${DLL_CORE_NAME})

# loader flags
set_target_properties(${DLL_LOADER_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${CMAKE_CURRENT_BINARY_DIR}/libs)
set_target_properties(${DLL_LOADER_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${CMAKE_CURRENT_BINARY_DIR}/libs)
set_target_properties(${DLL_LOADER_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_REALLYRELEASE ${CMAKE_CURRENT_BINARY_DIR}/libs)

set_target_properties(${DLL_LOADER_NAME} PROPERTIES COMPILE_FLAGS "-DDK_LOADER_DLL_EXPORT -DNOMINMAX")
set_target_properties(${DLL_LOADER_NAME} PROPERTIES DEBUG_OUTPUT_NAME ${DLL_LOADER_NAME}d)
set_target_properties(${DLL_LOADER_NAME} PROPERTIES RELEASE_OUTPUT_NAME ${DLL_LOADER_NAME})

# gui flags
set_target_properties(${DLL_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${CMAKE_CURRENT_BINARY_DIR}/libs)
set_target_properties(${DLL_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${CMAKE_CURRENT_BINARY_DIR}/libs)
set_target_properties(${DLL_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_REALLYRELEASE ${CMAKE_CURRENT_BINARY_DIR}/libs)

set_target_properties(${DLL_NAME} PROPERTIES COMPILE_FLAGS "-DDK_GUI_DLL_EXPORT -DNOMINMAX")
set_target_properties(${DLL_NAME} PROPERTIES DEBUG_OUTPUT_NAME ${DLL_NAME}d)
set_target_properties(${DLL_NAME} PROPERTIES RELEASE_OUTPUT_NAME ${DLL_NAME})

target_link_libraries(${DLL_NAME} ${QT_QTCORE_LIBRARY} ${QT_QTGUI_LIBRARY} ${QT_QTSVG_LIBRARY} ${QT_QTNETWORK_LIBRARY} ${QT_QTMAIN_LIBRARY} ${EXIV2_LIBRARIES} ${LIBRAW_LIBRARIES} ${OpenCV_LIBS} ${VERSION_LIB} ${TIFF_LIBRARIES} ${HUPNP_LIBS} ${HUPNPAV_LIBS} ${QUAZIP_LIBRARIES} ${WEBP_LIBRARY}) 

# installation
#  binary
install(TARGETS ${BINARY_NAME} ${DLL_NAME} DESTINATION bin LIBRARY DESTINATION lib${LIB_SUFFIX})
#  desktop file
install(FILES nomacs.desktop DESTINATION share/applications)
#  icon
install(FILES src/img/nomacs.svg DESTINATION share/pixmaps)
#  translations
install(FILES ${NOMACS_QM} DESTINATION share/nomacs/translations)
#  manpage
install(FILES Readme/nomacs.1 DESTINATION share/man/man1)
#  appdata
install(FILES nomacs.appdata.xml DESTINATION /usr/share/appdata/)


# "make dist" target
string(TOLOWER ${CMAKE_PROJECT_NAME} CPACK_PACKAGE_NAME)
set(CPACK_PACKAGE_VERSION "${NOMACS_VERSION}")
set(CPACK_SOURCE_GENERATOR "TBZ2")
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}")
set(CPACK_IGNORE_FILES "/CVS/;/\\\\.svn/;/\\\\.git/;\\\\.swp$;\\\\.#;/#;\\\\.tar.gz$;/CMakeFiles/;CMakeCache.txt;refresh-copyright-and-license.pl;build;release;")
set(CPACK_SOURCE_IGNORE_FILES ${CPACK_IGNORE_FILES})
include(CPack)
# simulate autotools' "make dist"
add_custom_target(dist COMMAND ${CMAKE_MAKE_PROGRAM} package_source)


# generate configuration file
set(NOMACS_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(NOMACS_BUILD_DIRECTORY ${CMAKE_BINARY_DIR})
set(NOMACS_LIBS ${CMAKE_PROJECT_NAME}lib)

configure_file(${NOMACS_SOURCE_DIR}/nomacs.cmake.in ${CMAKE_BINARY_DIR}/nomacsConfig.cmake)
