# Iterative Closest Point algorithm (point cloud matching) plugin for V-REP

### Compiling

1. Install required python packages for [v_repStubsGen](https://github.com/fferri/v_repStubsGen): see v_repStubsGen's [README](external/v_repStubsGen/README.md)
2. Checkout and compile
```
$ git clone --recursive https://github.com/fferri/v_repExtICP.git
$ make
```
or:
```
$ qmake && make
```
for building with `qmake` / *Qt Creator*
