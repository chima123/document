#!/bin/sh


# export QNX7_ROOT="/home/ad/Projects/as/as-houyi-honda/toolchain/prebuilt_QHS220"
export QNX7_ROOT="/home/ad/Projects/as/as-houyi-honda/toolchain/qnx710"

source ${QNX7_ROOT}/qnxsdp-env.sh

export BUILD_TYPE=release
export BUILD_ARCH=qnx710
build_path=build__${BUILD_TYPE}_${BUILD_ARCH}
release_path=release__${BUILD_TYPE}_${BUILD_ARCH}
echo $build_path

CUR_PATH="$(realpath $(dirname ${0}))"
export TOOLCHAIN_PATH=$CUR_PATH/build_qnx7.cmake
echo $TOOLCHAIN_PATH

# rm -r $build_path

# export LD_LIBRARY_PATH=$TOOLCHAINS/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

cmake -B ${build_path} \
    -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_PATH} \
    -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
    -DEVENT__BUILD_SHARED_LIBRARIES:BOOL=ON \
    -DOPENSSL_ROOT_DIR="/home/ad/Downloads/release_qnx_1.1.1" \
    -DOPENSSL_CRYPTO_LIBRARY="/home/ad/Downloads/release_qnx_1.1.1/lib/libcrypto.so" \
    -DOPENSSL_SSL_LIBRARY="/home/ad/Downloads/release_qnx_1.1.1/lib/libssl.so" \
    -DOPENSSL_INCLUDE_DIR="/home/ad/Downloads/release_qnx_1.1.1/include" \
    -DEVENT__DISABLE_TESTS:BOOL=ON \
    -DEVENT__DISABLE_SAMPLES:BOOL=ON \
    -DEVENT__DISABLE_BENCHMARK:BOOL=ON \
    -DEVENT__FORCE_KQUEUE_CHECK:BOOL=OFF \
    -DCMAKE_INSTALL_PREFIX=${release_path}

    # -DEVENT__HAVE_DECL_CTL_KERN:BOOL=OFF \

if [ $? -eq 0 ] ; then 
    echo "CMAKE SUCCSUCCSUCCSUCCSUCC"
else
    echo "CMAKE ERRORERRORERRORERROR"
fi

make -C ${build_path} -j`nproc` 

echo "begin make install"
make -C ${build_path} install