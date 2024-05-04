# Building GnuCash with GTK-OSX #

GnuCash can be built to run more or less natively on OSX -- meaning
without X11. Better yet, the build is almost automatic.

Please see http://wiki.gnucash.org/wiki/MacOSX/Quartz for instructions.

#### Building the dependencies tarball for CI tests ####
The Github Mac runners are Apple Silicon so this must be done on an
Apple Silicon Mac.

##### Prerequisites #####
1. Set up [gtk-osx](https://gitlab.gnome.org/GNOME/gtk-osx/README.md)
on your system.
2. Clone this repository.
3. Create a build directory and change its ownership to you:
   ```
   sudo mkdir -p /Users/runner/gnucash/inst
   sudo chown -R <your userid> /Users/runner
   ```
##### Procedure #####
1. Change the file versions in dependencies.txt to match the versions
   in the build you just made.
2. Perform the following:
   ```
   cd /Users/runner
   jhbuild --prefix /Users/runner/gnucash bootstrap-gtk-osx
   jhbuild --prefix /Users/runner/gnucash --moduleset=/Path/to/gnucash-on-osx/modules/gnucash.modules build meta-gnucash-dependencies
   cd gnucash/inst
   xargs < /Path/to/gnucash-on-osx/dependencies.txt tar -rf ~/gnucash-<version>-mac-dependencies.tar
   jhbuild --prefix /Users/runner/gnucash shell
   xz ~/gnucash-<version>-mac-dependencies.tar
   ```
##### Testing the tarball #####
While still in the jhbuild shell:
```
cd /Users/runner/gnucash
mkdir parked
mkdir gc-tarball
cd gc-tarball
tar -xf gnucash-<version>-mac-dependencies.tar.xz
cd ../inst
mv lib ../parked
mv include ../parked
mv share ../parked
ln -s /Users/runner/gnucash/gc-tarball/include .
ln -s /Users/runner/gnucash/gc-tarball/lib .
ln -s /Users/runner/gnucash/gc-tarball/share .
cd ../src
git clone https://github.com/gnucash/gnucash
mkdir ../build/gnucash-git && cd ../build/gnucash-git
```
Configure, build, and test GnuCash. If things go wrong then you need
to figure out what's missing, add it to `dependencies.txt`, regenerate
the tarball, untar it in `gc-tarball` and try again.

##### Finish up #####
1. Upload the result to the Dependencies folder in GnuCash's
   Sourceforge project.
2. Change the dependencies file URI in
   `gnucash-git/.github/workflows/macos-tests.yaml` to match the file you
   just made, commit the result, and push it.
3. Commit and push any changes you made to `dependencies.txt`.
