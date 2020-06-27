# Readme

Things that to relate to compiling MPD from source.

## sources

Source code links:

* https://github.com/MusicPlayerDaemon/MPD
* https://www.musicpd.org/doc/html/user.html
* https://mesonbuild.com/ - MPD uses the Meson build system

Debian pacakge sources:

* https://packages.debian.org/source/buster/mpd
* https://packages.debian.org/source/buster/mpc

### use

Create the build container:

```
docker build -t mpcontainer-mpdbuild:latest .
```

Run container and login:

```
docker run -it mpcontainer-mpdbuild /bin/bash
```

## build

build script:

```
./build.sh
```

---

notes / to-do / check lists:

* do [Reproducuble builds](https://reproducible-builds.org/)

* checks for elf hardening options like [relo](https://www.redhat.com/en/blog/hardening-elf-binaries-using-relocation-read-only-relro), [PIC](https://wiki.gentoo.org/wiki/Hardened/Position_Independent_Code_internals), and [PIE](https://wiki.ubuntu.com/SecurityTeam/PIE)

* play with some [Fuzzing](https://en.wikipedia.org/wiki/Fuzzing), learn about fuzzing and see if anything falls out of MPD

* addresssanitizer builds ([ASan](https://en.wikipedia.org/wiki/AddressSanitizer)) for dev/test deploys?
