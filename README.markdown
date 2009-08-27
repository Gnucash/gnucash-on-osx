#Building GnuCash with GTK-OSX#

##Overview##
GnuCash can be built to run more or less natively on OSX -- meaning
without X11. Better yet, the build is almost automatic.

This is tested and works for Macinstosh OSX Versions 10.4 (Tiger) and
10.5 (Leopard) on both PowerPC and Intel. It does not create universal
binaries.

##Binaries available for download##

Precompiled app bundles are available from
http://gnucash.sourceforge.net, and users who are simply interested in
running Gnucash on their Macs should obtain the latest stable release
from there.

##Preliminaries##
Tiger or newer is <em>required</em> for gtk-osx.

You need Python 2.5 to run jhbuild. This is already part of Leopard
(OSX 10.5), but Tiger (10.4) provided Python 2.3, so the gtk-osx
maintainer has included logic to make a new python for Tiger users.
You will also need Git (http://metastatic.org/source/git-osx.html) and Tiger users will need Subversion (http://www.open.collab.net/downloads/community/)

If you haven't already done so, retrieve this package:
    git clone git://github.com/jralls/gnucash-on-osx.git

Copy the .jhbuildrc-custom into your home directory.

Note that by default, jhbuild will put everything into your home
directory. I prefer to build and install into /usr/local, so you'll
find commented out settings to do it that way at the top of
.jhbuildrc-custom. You can uncomment these and change them to whatever
you like -- or leave them as they are.

Go to http://sourceforge.net/apps/trac/gtk-osx/wiki//Build and follow
the instructions. <b><em>Don't run jhbuild build yet!</em></b>

Tiger users will need to retrieve and install
http://downloads.sourceforge.net/cups/cups-1.2.12.dmg

##Alternate Versions##

There are modules provided for building the latest stable release (gnucash), the latest unstable (development) release (gnucash-unstable), and the current subversion trunk (gnucash-svn). Just edit the "modules = " line in .jhbuildrc-custom to point at the one you want.

##AQBanking and Qt##

With an additional dependency, you can build in the setup wizard for
AQBanking. This depends on Nokia's Qt library (the same one that KDE
uses). First, you must download and install the latest MacOSX Qt4
package from https://qt.nokia.com/downloads/downloads#lgpl

Edit gnucash-on-osx/modulesets/gnucash-modules so that the dependency
for aqbanking in the gnucash module that you want to build is
aqbanking-qt. There's a commented out dependency; just uncomment it
and comment out the plain aqbanking one.

Edit gnucash-on-osx/gnucash-bundler/gnucash.bundle and uncomment the 4
Qt framework elements.

##Building##

Once all of the preliminaries are complete, run:
	$> jhbuild build

You also need to 
    	 $> mkdir $PREFIX/tmp 

##Running from the commandline##

Now you're ready to try it out:
	$> $PREFIX/bin/gnucash

($PREFIX is the path to where you've built gtk; you can fill it in yourself or use jhbuild shell to set it for you.) 

##Making a Bundle##

So far so good, but you don't really want to have to open a Terminal
window every time you want to use GnuCash, now do you? Of course
not. You want a nice icon in your Applications folder (and maybe in
the Dock) to click on when you run GnuCash. Here's how to do this:

 * Download the bundler from http://downloads.sourceforge.net/sourceforge/gtk-osx/ige-mac-bundler-0.5.tar.gz unpack it, cd into the ige-mac-bundler directory, and

	make install
 * 
	<tt>$> cd gnucash-on-osx/gnucash-bundler</tt>
 * Look through gnucash-launcher and gnucash.bundle and adjust the paths to match your installation.
 * If you built a gnucash-unstable or gnucash-svn, edit Info.plist to have the right version information.
 * make gnucash-launcher executable :
	<tt>$> chmod +x gnucash-launcher</tt>
 * execute 
 	<tt>jhbuild shell</tt>
   to set up the environment for the bundler
 * while in the shell, execute 
	<tt>ige-mac-bundler gnucash.bundle</tt>
 * exit the shell

And your bundle should be ready to go.
Try <tt>GnuCash.app/Contents/MacOSX/GnuCash</tt> from the command-line so that you can see any error messages. If that works, try <tt>open GnuCash.app</tt>. If that works, then you can move GnuCash.app to your Applications folder and it's ready to use. <em>Don't move or remove the installation directory (~/gtk/inst by default): Both dbus and GnuCash have links pointing into it which can't at present be changed.</em>

