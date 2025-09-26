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
   Change GNC_VERSION in depstarball.sh to match the current or next
   release as appropriate. If that's not changing consider adding a
   suffix (e.g. 5.13-1) so that the new and old can coexist on sourceforge.
2. Build the dependencies:
   ```
   cd /Users/runner
   jhbuild --prefix /Users/runner/gnucash bootstrap-gtk-osx
   jhbuild --prefix /Users/runner/gnucash --moduleset=/Path/to/gnucash-on-osx/modules/gnucash.modules build meta-gnucash-dependencies
   ```
3. Run `depstarball.sh`. It uses absolute paths so it can be run from
   any directory. If GnuCash compiles and all the tests pass,
   proceed. If not then diagnose the problem, adjust dependencies.txt
   as needed, and try again.

##### Finish up #####
1. Upload the result to the Dependencies folder in GnuCash's
   Sourceforge project.
2. Change the dependencies file URI in
   `gnucash-git/.github/workflows/macos-tests.yaml` to match the file you
   just made, commit the result, and push it.
3. Commit and push any changes you made to `dependencies.txt` and `depstarball.sh`.
