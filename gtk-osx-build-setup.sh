#!/bin/sh
#
# Script that sets up jhbuild for GTK+ OS X building. Run this to
# checkout jhbuild and the required configuration.
#
# Copyright 2007, 2008 Imendio AB
#
# Run this whenever you want to update jhbuild or the jhbuild setup;
# it is safe to run it repeatedly. Note that it overwrites
# ~/.jhbuildrc however. Custom settings should be kept in
# ~/.jhbuildrc-custom.
#
# You need Mac OS X 10.4 or newer and Xcode 2.5 or newer. Make sure
# you have subversion (svn) installed, 10.5 has it by default.
#
# Quick HOWTO:
#
# sh gtk-osx-build-setup.sh
#
# jhbuild bootstrap
# jhbuild build meta-gtk-osx-bootstrap
# jhbuild build
#
# See http://developer.imendio.com/projects/gtk-macosx for more information.
#

SOURCE=/usr/local/src
BASEURL=http://people.imendio.com/richard

do_exit()
{
    echo $1
    exit 1
}

if test x`which svn` == x; then
    do_exit "Svn (subversion) is not available, please install it and try again."
fi

mkdir -p $SOURCE 2>/dev/null || do_exit "The directory $SOURCE could not be created. Check permissions and try again."

if ! test -d $SOURCE/jhbuild; then
    echo "Checking out jhbuild from subversion..."
    svn co http://svn.gnome.org/svn/jhbuild/trunk $SOURCE/jhbuild >/dev/null
else
    echo "Updating jhbuild from subversion..."
    (cd $SOURCE/jhbuild && svn up >/dev/null)
fi

echo "Installing jhbuild..."
(cd $SOURCE/jhbuild && sudo make -f Makefile.plain DISABLE_GETTEXT=1 install >/dev/null)

echo "Installing jhbuild configuration..."
curl -s $BASEURL/gtk-osx-build/jhbuildrc-gtk-osx -o $HOME/.jhbuildrc
curl -s $BASEURL/gtk-osx-build/jhbuildrc-gtk-osx-fw-10.4 -o $HOME/.jhbuildrc-fw-10.4
if [ ! -f $HOME/.jhbuildrc-custom ]; then
    curl -s $BASEURL/gtk-osx-build/jhbuildrc-gtk-osx-custom-example -o $HOME/.jhbuildrc-custom
fi

#if test "x`echo $PATH | grep $HOME/bin`" == x; then
#    echo "PATH does not contain $HOME/bin, it is recommended that you add that."
#    echo 
#fi

echo "Done."
