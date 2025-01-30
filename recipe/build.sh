#!/bin/sh
set -ex

if [[ "${target_platform}" == osx-* ]]; then
    # See https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
    CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

ENABLE_MFRONT="OFF"
if [[ "${target_platform}" == linux-* ]]; then
    ENABLE_MFRONT="ON"
    export CONDA_PREFIX=${PREFIX}
fi

mkdir build
cd build
cmake -LAH -G Ninja ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_PREFIX_PATH=${PREFIX} \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_INSTALL_RPATH=${PREFIX}/lib \
    -DOGS_BUILD_TESTING=OFF \
    -DOGS_VERSION=${PKG_VERSION} \
    -DOGS_INSTALL_DEPENDENCIES=OFF \
    -DOGS_CPU_ARCHITECTURE=OFF \
    -DBUILD_SHARED_LIBS=ON \
    -DCONDA_BUILD=ON \
    -DOGS_EIGEN_DYNAMIC_SHAPE_MATRICES=ON \
    -DPython_EXECUTABLE=${PYTHON} \
    -DOGS_USE_MFRONT=${ENABLE_MFRONT} \
    ..

cmake --build . --target install -j${CPU_COUNT}

