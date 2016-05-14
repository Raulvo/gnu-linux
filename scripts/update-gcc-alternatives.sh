#!/bin/bash

# Repository of GCC Ubuntu toolchains: 
# deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu trusty main
# deb-src http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu trusty main

## Adding a version of gcc to your alternatives:
# update-gcc-alternatives.sh --add=6 --priority=60
## Switching from current gcc version to GCC 6:
# update-gcc-alternatives.sh --switch-to=6
## Removing a version of gcc from your alternatives:
# update-gcc-alternatives.sh --remove=4.8

function usage() {
    echo "Usage $0: [--add=version --priority| --remove=version| --switch-to=version]"    
}

function switch() {
    if [ ${1} == "" ]; then
        usage
        exit 1
    fi
    for i in gcc gcc-ar gcc-nm gcc-ranlib g++ gfortran gcov; do
        sudo update-alternatives --set ${i} "/usr/bin/${i}-${1}"
    done
    
}

function remove() {
    if [ ${1} == "" ]; then
        usage
        exit 1
    fi

    for i in gcc gcc-ar gcc-nm gcc-ranlib g++ gfortran gcov; do
        sudo update-alternatives --remove ${i} "/usr/bin/${i}-${1}"
    done
}

function add() {
    if [[ ${1} == "" || ${2} == "" ]]; then
        usage
        exit 1
    fi
    for i in gcc gcc-ar gcc-nm gcc-ranlib g++ gfortran gcov; do
        sudo update-alternatives --install "/usr/bin/$i" "$i" "/usr/bin/$i-${1}" ${2} --slave "/usr/share/man/man1/${i}.1.gz" "man-$i" "/usr/share/man/man1/$i-${1}.1.gz"

    done
}


for i in $@; do
    case $i in
        --priority=*)
            PRIORITY=$(echo $i | cut -d\= -f2)
            ;;
        --switch-to=*)
            SWITCH=$(echo $i | cut -d\= -f2)
            ;;
        --add=*)
            ADD=$(echo $i | cut -d\= -f2)
            ;;
        --remove=*)
            REMOVE=$(echo $i | cut -d\= -f2)
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

if [[ ${SWITCH} ]]; then
    switch ${SWITCH}
fi

if [[ ${ADD} && ${PRIORITY} ]]; then
    add ${ADD} ${PRIORITY}
fi

if [[ ${REMOVE} ]]; then
    remove ${REMOVE}
fi
