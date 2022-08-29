#!/bin/bash

for LIB in androidx.camera_camera-camera2 \
androidx.camera_camera-core \
androidx.camera_camera-extensions \
androidx.camera_camera-lifecycle \
androidx.camera_camera-video \
androidx.camera_camera-view; do
    PKGNAME=$(echo $LIB | cut -f1 -d '_')
    NAME=$(echo $LIB | cut -f2 -d '_')

    VERSION=$(cat $(dirname $0)/../app/build.gradle.kts | grep "implementation(\"$PKGNAME:$NAME:" \
            | cut -f3 -d ':' | cut -f1 -d '"')
    if [ $PKGNAME = "androidx.camera" ]; then
        VERSION=$(cat $(dirname $0)/../app/build.gradle.kts | grep "val cameraVersion =" | cut -f2 -d '"')
    fi

    FILEEXT=$(ls ${PKGNAME}_${NAME}.* | rev | cut -f1 -d '.' | rev)
    wget -O ${PKGNAME}_${NAME}.${FILEEXT} \
            https://maven.google.com/$(echo $PKGNAME | sed 's|\.|/|g')/${NAME}/${VERSION}/${NAME}-${VERSION}.${FILEEXT}

    if [ $NAME = "camera-core" ]; then
        pushd androidx.camera_camera-core
        unzip ../${PKGNAME}_${NAME}.${FILEEXT} "jni/*/libimage_processing_util_jni.so"
        popd
    fi
done
