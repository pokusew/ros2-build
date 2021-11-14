# ros2-build

This a ROS 2 workspace for building ROS 2 (Galactic) and/or additional packages (such as Stage simulator).

**🚧 NOTE:** This documentation will be improved. See
also [my notes on Building ROS 2 on NVIDIA Jetson TX2][jetson-tx2-ros2-build-notes]
(some parts will be merged here in the future).


## Installation


### Usage

The project is a normal colcon workspace. But it contains a [Makefile](./Makefile)
to **automate** **cloning** the sources (using [vcstool](https://github.com/dirk-thomas/vcstool)),
**patching** the sources and **building** and **cleaning** the workspace.

**Requirements:**
* https://github.com/dirk-thomas/vcstool
* colcon and ROS 2 tools as described [here][ros2-tools-setup] _(TODO: document better)_

**make commands:**
* `make clone-ros2`
* `make clone-ros2-mini`
* `make clone-additional`
* `make clone-auto`
* `make clone-stage`
* `make patch-stage`
* `make build`
* `make build-no-db`
* `make clean`

See the [Makefile](./Makefile) for detailed info.


### stage

Here are described some additional dependencies that needs to be installed when building _stage_ packages:

* on macOS:
	* TODO
* on Ubuntu 20.04.2:
	* assuming that build tools like cmake and build-essentials are already installed
	* these are already present: `libgl1-mesa-dev libglu1-mesa-dev libpng12-dev libtool` (`libpng16` also works)
	* `sudo apt install libfltk1.1-dev`
* on NVIDIA Jetson TX2 Jetpack 4.5.1 (L4T 32.5.1) (Ubuntu 18.04.5):
	* `sudo apt install libfltk1.1-dev libjpeg-dev`


### additional

Here are described some additional dependencies that needs to be installed when building _additional_ packages:

* on macOS:

  **If you are on macOS < 10.15, see [pluginlib build on macOS < 10.15](./patches/pluginlib-macOS-10.14.md).**

  _TODO: Document adapting brew's boost-python3 formula for Python 3.8_

* on NVIDIA Jetson TX2 Jetpack 4.5.1 (L4T 32.5.1) (Ubuntu 18.04.5):

  Run:
  ```bash
  rosdep check -i --from-path src --skip-keys 'stage'
  ```

  Expected output:
  ```
  apt     libboost-python-dev
  apt     libboost-python1.65.1
  apt     python3-opencv
  ```

  Then install the missing dependencies using:
  ```bash
  rosdep install -i --from-path src --skip-keys 'stage'
  ```


## Notes


### `stage` build warning

TODO: Can we use GLVND for OpenGL and GLX for `stage` package build?

 ```
--- stderr: stage                                
CMake Warning (dev) at /usr/share/cmake-3.16/Modules/FindOpenGL.cmake:275 (message):
  Policy CMP0072 is not set: FindOpenGL prefers GLVND by default when
  available.  Run "cmake --help-policy CMP0072" for policy details.  Use the
  cmake_policy command to set the policy and suppress this warning.

  FindOpenGL found both a legacy GL library:

    OPENGL_gl_LIBRARY: /usr/lib/x86_64-linux-gnu/libGL.so

  and GLVND libraries for OpenGL and GLX:

    OPENGL_opengl_LIBRARY: /usr/lib/x86_64-linux-gnu/libOpenGL.so
    OPENGL_glx_LIBRARY: /usr/lib/x86_64-linux-gnu/libGLX.so

  OpenGL_GL_PREFERENCE has not been set to "GLVND" or "LEGACY", so for
  compatibility with CMake 3.10 and below the legacy GL library will be used.
Call Stack (most recent call first):
  /usr/share/cmake-3.16/Modules/FindFLTK.cmake:83 (find_package)
  CMakeLists.txt:100 (find_package)
This warning is for project developers.  Use -Wno-dev to suppress it.

---
```

[jetson-tx2-ros2-build-notes]: https://github.com/pokusew/ubuntu-ros/blob/master/nvidia-jetson-tx2/SETUP.md#install-ros-2

[ros2-tools-setup]: https://docs.ros.org/en/foxy/Installation/Ubuntu-Development-Setup.html#system-setup
