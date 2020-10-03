# Readme

Things that to relate to compiling MPD from source.

note: currently MPContainer uses MPD from Debian's apt.

## sources

Source code links:

* https://github.com/MusicPlayerDaemon/MPD
* https://www.musicpd.org/doc/html/user.html
* https://mesonbuild.com/ - MPD uses the Meson build system

Debian pacakge sources:

* https://packages.debian.org/source/buster/mpd
* https://packages.debian.org/source/buster/mpc

### container

Create the build container:

```shell
docker build -t mpcontainer-mpdbuild:latest .
```

Run container and login:

```shell
docker run -it mpcontainer-mpdbuild /bin/bash
```

#### build mpd

Run the build script:

```shell
./build.sh
```

to do: spit out a .zip or .deb that can be used.

## notes

A to do list, things to check, and otehr random information.

* do [Reproducuble builds](https://reproducible-builds.org/)

* checks for elf hardening options like [relo](https://www.redhat.com/en/blog/hardening-elf-binaries-using-relocation-read-only-relro), [PIC](https://wiki.gentoo.org/wiki/Hardened/Position_Independent_Code_internals), and [PIE](https://wiki.ubuntu.com/SecurityTeam/PIE)

* play with some [Fuzzing](https://en.wikipedia.org/wiki/Fuzzing), learn about fuzzing and see if anything falls out of MPD

* addresssanitizer builds ([ASan](https://en.wikipedia.org/wiki/AddressSanitizer)) for dev/test deploys?
