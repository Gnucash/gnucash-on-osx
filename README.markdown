#Building GnuCash with GTK-OSX#
##Overview##

GnuCash can be built to run more or less natively on OSX -- meaning
without X11. Better yet, the build is almost automatic.

I've succeeded in building this under various incarnations of Leopard
while perfecting the modulesets, always on a Mac Pro... but it ought
to work on any Mac running Tiger or Leopard.

The default configuration builds in your home folder. On my system, I
build in /usr/local/src/gnome and install to /usr/local/gtk. If you
want to do that, uncomment the checkoutroot and prefix lines in
.jhbuildrc-custom, then create the folders up front and give yourself
ownership. If you don't know how to do that, then you should probably
leave it the way it is.

##Preliminaries##
Tiger or newer is <em>required</em> for gtk-osx.

You need Python 2.5 to run jhbuild. This is already part of Leopard
(OSX 10.5), but Tiger (10.4) provided Python 2.3, so the gtk-osx
maintainer has included logic to make a new python for Tiger users.

Download
	http://github.com/jralls/gnucash-on-osx/raw/master/.jhbuildrc-custom
into your home directory.

Note that by default, jhbuild will put everything into your home
directory. I prefer to build and install into /usr/local, so you'll
find commented out settings to do it that way at the top of
.jhbuildrc-custom. You can uncomment these and change them to whatever
you like -- or leave them as they are.

Go to http://live.gnome.org/GTK%2B/OSX/BuildInstructions and follow
the instructions. <b><em>Don't run jhbuild build yet!</em></b>

At the moment, in order to build gtk-doc (which is required by a bunch
of packages), you need python bindings for libxml2. For Leopard users,
if you don't have this installed somewhere on your $PYTHONPATH, and
for all Tiger users, run

	$> jhbuild buildone libxml-py

##Building##

Once all of the preliminaries are complete, run:
	$> jhbuild build

##Running from the commandline##

Now you're ready to try it out:
	$> $PREFIX/bin/gnucash

##Making a Bundle##

So far so good, but you don't really want to have to open a Terminal
window every time you want to use GnuCash, now do you? Of course
not. You want a nice icon in your Applications folder (and maybe in
the Dock) to click on when you run GnuCash. Here's how to do this:

 * Download the bundler from http://github.com/jralls/gnucash-on-osx/raw/master/ige-mac-bundler.tar.gz, unpack it, cd into the ige-mac-bundler directory, and
	make install
 * Download http://github.com/jralls/gnucash-on-osx/raw/master/gnucash-bundler.tar.gz and unpack it.
 * 
	cd gnucash-bundler</tt> 
 * Look through gnucash-launcher and gnucash.bundle and adjust the paths to match your installation.
 * make gnucash-launcher executable :
	chmod +x gnucash-launcher
 * execute 
	jhbuild shell
   to set up the environment for the bundler
 * while in the shell, execute 
	ige-mac-bundler gnucash.bundle
 * exit the shell

And your bundle should be ready to go.
Try <tt>GnuCash.app/Contents/MacOSX/GnuCash</tt> from the command-line so that you can see any error messages. If that works, try <tt>open GnuCash.app</tt>. If that works, then you can move GnuCash.app to your Applications folder and it's ready to use. <em>Don't move or remove the installation directory (~/gtk/inst by default): Both dbus and GnuCash have links pointing into it which can't at present be changed.</em>

