#!/bin/sh

if [ $# != 1 ];then
    echo "USAGE: $0 BOX_NAME"
    echo "  eg.: $0 C1010A"
    echo ""
    echo "The optional BOX are:
                 ALL, C1010A, C1010B"
    exit 1;
fi

if [[ $1 != "C1010A" && $1 != "C1010B" && $1 != "ALL" ]];then
    echo "The Box Name is invalid."
    exit 1;
fi

TOP_DIR=${PWD}
SW_VERSION=1.2.2

if [[ $1 == "ALL" ]];then
    platformlist="C1010A C1010B"
else
    platformlist=$1
fi

rm -rf images
mkdir images
for platform in ${platformlist}
do
    cd os/${platform}
    make all 
    cp images/connetos.tar.gz ${TOP_DIR}/images/
    sed -i '1i\\x7f\x45\x4c\x46\x03\x0F\x0E\x0E\x05\x14\x0F\0x13' ${TOP_DIR}/images/connetos.tar.gz
    BUILD_VERSION=`cat ${TOP_DIR}/switch/BUILD_CODE`
    cd ${TOP_DIR}/images
    mv  connetos.tar.gz ConnetOS_${platform}_${SW_VERSION}_${BUILD_VERSION}.bin
    cd ${TOP_DIR}
    echo "build ${platform} image ok"
done
