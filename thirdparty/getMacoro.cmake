
set(GIT_REPOSITORY      "https://github.com/ladnir/macoro.git")

if(DEFINED MACORO_GIT_TAG)
    set(GIT_TAG ${MACORO_GIT_TAG})
else()
    set(GIT_TAG "961fe590ffd2837435fba154f012a67c9a0c5cff" )
endif()

set(CLONE_DIR "${COPROTO_THIRDPARTY_CLONE_DIR}/macoro")
set(BUILD_DIR "${CLONE_DIR}/out/build/${COPROTO_CONFIG}")
set(LOG_FILE  "${CMAKE_CURRENT_LIST_DIR}/log-macoro.txt")

include("${CMAKE_CURRENT_LIST_DIR}/fetch.cmake")


    if(NOT DEFINED COPROTO_STAGE)
        message(FATAL_ERROR "COPROTO_STAGE not defined")
    endif()

    find_program(GIT git REQUIRED)
    set(DOWNLOAD_CMD  ${GIT} clone ${GIT_REPOSITORY})
    set(CHECK_TAG_CMD  ${GIT} show-ref --tags ${GIT_TAG} --quiet)
    set(CHECKOUT_CMD  ${GIT} checkout ${GIT_TAG})

    message("============= Building macoro =============")
    if(NOT EXISTS ${CLONE_DIR})
        run(NAME "Cloning ${GIT_REPOSITORY}" CMD ${DOWNLOAD_CMD} WD ${COPROTO_THIRDPARTY_CLONE_DIR})
    endif()

    execute_process(
        COMMAND ${CHECK_TAG_CMD}
        WORKING_DIRECTORY ${CLONE_DIR}
        RESULT_VARIABLE CHECK_TAG_REUSLT
        COMMAND_ECHO STDOUT
    )

    if(GIT_TAG)
        run(NAME "Checkout ${GIT_TAG} " CMD ${CHECKOUT_CMD}  WD ${CLONE_DIR})
    endif()

    set(MACORO_NO_SYSTEM_PATH ${COPROTO_NO_SYSTEM_PATH})
    set(MACORO_FETCH_AUTO true)
    set(MACORO_CPP_VER ${COPROTO_CPP_VER})
    set(MACORO_PIC ${COPROTO_PIC})
    set(MACORO_ASAN ${COPROTO_ASAN})
    set(MACORO_THIRDPARTY_CLONE_DIR ${COPROTO_THIRDPARTY_CLONE_DIR})
    add_subdirectory(${CLONE_DIR})

#install(CODE "
#    if(NOT CMAKE_INSTALL_PREFIX STREQUAL \"${COPROTO_STAGE}\")
#        execute_process(
#            COMMAND ${SUDO} \${CMAKE_COMMAND} --install ${BUILD_DIR} --config #${CMAKE_BUILD_TYPE} --prefix \${CMAKE_INSTALL_PREFIX}
#            WORKING_DIRECTORY ${CLONE_DIR}
#            RESULT_VARIABLE RESULT
#            COMMAND_ECHO STDOUT
#        )
#    endif()
#")
