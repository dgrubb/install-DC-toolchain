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

## Further reading

[Dreamcast development](http://dcemulation.org/?title=Development)

