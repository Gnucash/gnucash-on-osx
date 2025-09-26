#!/usr/bin/env bash
if [ -z "$JHBUILD_PREFIX" ]; then
    echo "This script requires that you be in a JHBuild shell for making dependencies"
    exit -1
fi

GC_VERSION="5.13"
SRC_URI="https://github.com/gnucash/gnucash"
#Paths:
ROOT_DIR="/Users/runner/gnucash"
INST_DIR="$ROOT_DIR/inst"
PARK_DIR="$ROOT_DIR/parked"
TAR_DIR="$ROOT_DIR/gc-tarball"
SRC_DIR="$ROOT_DIR/src/gnucash-git"
BUILD_DIR="$ROOT_DIR/build/gnucash-git"
DEPS_FILE="$HOME/Development/GTK-OSX/gnucash-on-osx/dependencies.txt"
TARBALL="$HOME/gnucash-$GC_VERSION-mac-dependencies.tar"
COMP_TARBALL="$TARBALL.xz"

if [ ! -d $INST_DIR ]; then
    mkdir -p $INST_DIR
fi
if [ ! -d $PARK_DIR ]; then
    mkdir -p $PARK_DIR
fi
if [ ! -d $TAR_DIR ]; then
    mkdir -p $TAR_DIR
fi
if [ ! -d $BUILD_DIR ]; then
    if [ ! -d $SRC_DIR ]; then
        mkdir -p $SRC_DIR
        pushd $SRC_DIR
        git clone $SRC_URI
        popd
    fi
    mkdir -p $BUILD_DIR
fi

function reset_from_tarball
{
    pushd $INST_DIR
    rm bin include lib share
    mv "$PARK_DIR/bin" .
    mv "$PARK_DIR/include" .
    mv "$PARK_DIR/lib" .
    mv "$PARK_DIR/share" .
    popd
}

function enable_tarball
{
    pushd $INST_DIR
    mv bin "$PARK_DIR"
    mv include "$PARK_DIR"
    mv lib "$PARK_DIR"
    mv share "$PARK_DIR"
    ln -s "$TAR_DIR/bin" .
    ln -s "$TAR_DIR/include" .
    ln -s "$TAR_DIR/lib" .
    ln -s "$TAR_DIR/share" .
    popd
}

function create_tarball
{
    pushd "$INST_DIR"
    if [ -f "$COMP_TARBALL" ]; then
        rm "$COMP_TARBALL"
    fi
    xargs < "$DEPS_FILE" tar -rf "$TARBALL"
    xz "$TARBALL"
    popd
}

function test_tarball
{
    pushd "$TAR_DIR"
    rm -rf *
    tar -xf "$COMP_TARBALL"
    popd
    enable_tarball
    pushd "$BUILD_DIR"
    rm -rf *
    cmake -G Ninja -DPython3_ROOT_DIR=$PREFIX -DPKG_CONFIG_EXECUTABLE=$PREFIX/bin/pkgconf -DCMAKE_PREFIX_PATH=$PRFIX -DCMAKE_INSTALL_PREFIX=$PREFIX \
          -DGTEST_ROOT=$SRCROOT/googletest -DWITH_PYTHON=YES $SRCROOT/gnucash-git \
        && ninja && ninja check
    popd
    reset_from_tarball
}

if [ "x$1" = "xuse_tarball" ] ; then
    enable_tarball
    exit 0
fi

if [ "x$1" = "xrestore" ] ; then
    reset_from_tarball
    exit 0
fi

if [ "x$1" = "xbuild" ] ; then
       test_tarball
       exit 0
fi

if [ -L "$INST_DIR/bin" ]; then
    reset_from_tarball
fi
create_tarball
test_tarball
exit 0
