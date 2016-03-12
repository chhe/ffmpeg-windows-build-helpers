#!/bin/bash

echo "packaging ffmpeg"

FFMPEG_32_INSTALLED=./sandbox/win32/ffmpeg_git_with_fdk_aac_shared.installed
FFMPEG_64_INSTALLED=./sandbox/x86_64/ffmpeg_git_with_fdk_aac_shared.installed

if [ ! -d ${FFMPEG_32_INSTALLED} ]; then
    echo "ERROR: ${FFMPEG_32_INSTALLED} not found!"
    exit -1
fi

if [ ! -d ${FFMPEG_64_INSTALLED} ]; then
    echo "ERROR: ${FFMPEG_64_INSTALLED} not found!"
    exit -1
fi

FFMPEG_32_VERSION=$(grep FFMPEG_VERSION sandbox/win32/ffmpeg_git_with_fdk_aac_shared/libavutil/ffversion.h | cut -c 24- | tr -d '"')
FFMPEG_64_VERSION=$(grep FFMPEG_VERSION sandbox/x86_64/ffmpeg_git_with_fdk_aac_shared/libavutil/ffversion.h | cut -c 24- | tr -d '"')

if [ ! -z "${FFMPEG_32_VERSION}" ]; then
    FFMPEG_32_ZIPNAME=ffmpeg-${FFMPEG_32_VERSION}_win32.7z
    echo "... doing 32-bit package"
    if ls ${FFMPEG_32_INSTALLED}/bin/*.lib 1> /dev/null 2>&1; then
        echo "... ... moving .lib to proper diretcory"
        mv -v ${FFMPEG_32_INSTALLED}/bin/*.lib ${FFMPEG_32_INSTALLED}/lib/
    fi
    if [ -f "${FFMPEG_32_ZIPNAME}" ]; then
        echo "... ... ${FFMPEG_32_ZIPNAME} already exists so i'm removing it!"
        rm -v ${FFMPEG_32_ZIPNAME}
    fi
    echo "... ... 7ziping everyting we need"
    7z a -r -mx9 -ms=on -mmt ${FFMPEG_32_ZIPNAME} ${FFMPEG_32_INSTALLED}/* > /dev/null
fi

if [ ! -z "${FFMPEG_64_VERSION}" ]; then
    FFMPEG_64_ZIPNAME=ffmpeg-${FFMPEG_64_VERSION}_win64.7z
    echo "... doing 64-bit package"
    if ls ${FFMPEG_64_INSTALLED}/bin/*.lib 1> /dev/null 2>&1; then
        echo "... ... moving .lib to proper diretcory"
        mv -v ${FFMPEG_64_INSTALLED}/bin/*.lib ${FFMPEG_64_INSTALLED}/lib/
    fi
    if [ -f "${FFMPEG_64_ZIPNAME}" ]; then
        echo "... ... ${FFMPEG_64_ZIPNAME} already exists so i'm removing it!"
        rm -v ${FFMPEG_64_ZIPNAME}
    fi
    echo "... ... 7ziping everyting we need"
    7z a -r -mx9 -ms=on -mmt ${FFMPEG_64_ZIPNAME} ${FFMPEG_64_INSTALLED}/*  > /dev/null
fi

echo "done."
