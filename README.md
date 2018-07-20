# install-DC-toolchain

Compiles and installs a Dreamcast toolchain and KallistiOS libraries for homebrew 
development on the Dreamcast platform. Largely derived by automating the steps 
laid out in this tutorial:

[Beginning Game Development - A Dreamcast Dev Guide](http://www.racketboy.com/forum/viewtopic.php?t=50699)

And further information from:

[Compiling KOS on Linux](http://dcemulation.org/?title=Compiling_KOS_on_Linux)

## Usage

N.B: requires that /opt/toolchains exists and is writable by current user.

```
$ cp install-DC-toolchain.sh /opt/toolchains/ && cd /opt/toolchains/ && ./install-DC-toolchain.sh
```

## Compilation

After running the script to install the toolchain the KallistiOS examples can be built with:

* Source the environment:

```
$ source /opt/toolchain/dc/environ.sh
```

* Launch top-level build script:

```
$ cd /opt/toolchains/dc/kos/examples
$ make all
```

## Other tooling

Kos and kos-ports contains almost everything I needed to start writing code targetted 
at the Dreamcast. In addition to the build tools I want to be able to execute code 
on an emulator to shorten development cycles.

### Reicast

Checkout code and follow compilation instructions at the [reicast-emulator GitHub page](https://github.com/reicast/reicast-emulator).

### img4dc

img4dc contains an application, cdi4dc, which can convert a standard ISO into a .cdi 
image suitable for burning or running with an emulator. To install:

1) Checkout img4dc:

```
$ git clone https://github.com/Kazade/img4dc.git
```

2) Generate make files:

```
$ cd ./img4dc
$ mkdir build && cd build
$ cmake ../
```

3) Execute build:

```
$ make
```

4) (Optional) Install cdi4dc system-wide:

```
$ sudo cp ./cdi4dc/cdi4dc /usr/bin
```

## Further reading

[DCEmulation Wiki: Dreamcast development](http://dcemulation.org/?title=Development)

[Dreamcast Programming](http://mc.pp.se/dc/)

