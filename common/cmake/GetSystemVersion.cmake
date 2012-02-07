IF(MSVC)
	set(SYSTEM_NAME "Win")
	if (NOT SUBSYSTEM_NAME)
		IF(CMAKE_SIZEOF_VOID_P MATCHES 8)
			set(SUBSYSTEM_NAME "x64")
		ELSE()
			set(SUBSYSTEM_NAME "x86")
		ENDIF()
	endif()
	SET(SYSTEM_DL_EXTENSION ".dll")
ELSEIF(APPLE)
	set(SYSTEM_NAME "Mac")
	if (NOT SUBSYSTEM_NAME)
		EXEC_PROGRAM(uname ARGS -v  OUTPUT_VARIABLE DARWIN_VERSION)
		STRING(REGEX MATCH "[0-9]+" DARWIN_VERSION ${DARWIN_VERSION})
		IF (DARWIN_VERSION MATCHES 8)
		IF (DARWIN_VERSION MATCHES 9)
			set(SUBSYSTEM_NAME "10.5")
		ELSEIF(DARWIN_VERSION MATCHES 9)
		ELSEIF(DARWIN_VERSION MATCHES 10)
			set(SUBSYSTEM_NAME "10.6")
		ELSEIF(DARWIN_VERSION MATCHES 10)
			set(SUBSYSTEM_NAME "10.7")
		ELSEIF(DARWIN_VERSION MATCHES 11)
			set(SUBSYSTEM_NAME "10.7")
		ELSE()
			message(FATAL_ERROR "Unsupported DARWIN_VERSION: ${DARWIN_VERSION}")
		ENDIF()
	endif()	
	SET(SYSTEM_DL_EXTENSION ".dylib")
ELSEIF(UNIX)
	set(SYSTEM_NAME "Linux")
	if (NOT SUBSYSTEM_NAME)
		IF(CMAKE_SIZEOF_VOID_P MATCHES 8)
			set(SUBSYSTEM_NAME "x64")
		ELSE()
			set(SUBSYSTEM_NAME "x86")
		ENDIF()
	endif()
	SET(SYSTEM_DL_EXTENSION ".so")
ELSE()
   MESSAGE(FATAL_ERROR "Unsupported system")
ENDIF()


IF (SYSTEM_NAME MATCHES "Mac")
	SET(PACKAGE_SUFFIX "mac${SUBSYSTEM_NAME}")
ELSE()
	IF (SYSTEM_NAME MATCHES "Win")
		SET(PACKAGE_SUFFIX_PREFIX "win")
	ELSEIF (SYSTEM_NAME MATCHES "Linux")
		SET(PACKAGE_SUFFIX_PREFIX "linux")
	ELSE()
		MESSAGE(FATAL_ERROR "Unsupported system")
	ENDIF()
	IF (SUBSYSTEM_NAME MATCHES "x86")
		SET(PACKAGE_SUFFIX_SUFFIX "32")
	ELSEIF (SUBSYSTEM_NAME MATCHES "x64")
		SET(PACKAGE_SUFFIX_SUFFIX "64")
	ELSE()
		MESSAGE(FATAL_ERROR "Unsupported system")
	ENDIF()
	SET(PACKAGE_SUFFIX "${PACKAGE_SUFFIX_PREFIX}${PACKAGE_SUFFIX_SUFFIX}")
ENDIF()

MESSAGE(STATUS "System-specific folder name: ${SYSTEM_NAME}")
MESSAGE(STATUS "Subsystem-specific folder name: ${SUBSYSTEM_NAME}")

macro(LIBRARY_NAME LIBRARY_BASENAME)	
	set(LIBRARY_NAME_RESULT "")
	if(NOT MSVC)
		SET(LIBRARY_NAME_RESULT "lib")
	endif()                                        
	set(LIBRARY_NAME_RESULT ${LIBRARY_NAME_RESULT}${LIBRARY_BASENAME}${SYSTEM_DL_EXTENSION})
	set(${LIBRARY_BASENAME}_NAME ${LIBRARY_NAME_RESULT})
endmacro()
                              
