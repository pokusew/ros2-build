# ros2-build

This a ROS 2 workspace for building ROS 2 together with additional packages from sources.

**🚧 NOTE:** This documentation will be improved. See
also [my notes on Building ROS 2 on NVIDIA Jetson TX2][jetson-tx2-ros2-build-notes]
(some parts will be merged here in the future).


## Usage

The project is a normal [colcon workspace][colcon-workspace]. But it contains a [Makefile](./Makefile)
to **automate** **cloning** the sources (using [vcstool]),
**patching** the sources and **building** and **cleaning** the workspace.


### Requirements

* [vcstool]
* colcon and ROS 2 tools as described [here][ros2-tools-setup]


### Workflow

1. `make init`

2. Obtain ROS 2 sources _(skip if you don't want to build ROS 2 from sources)_:
   ```bash
   # replace <distro> with distro name: master (for rolling), humble, galactic, foxy, etc.
   make distro=galactic clone-ros
   ```
   _Note:_ The make rule is merely a shortcut
   for `vcs import src --input https://raw.githubusercontent.com/ros2/ros2/<distro>/ros2.repos` that also automatically
   creates `src` directory if it does not exist.

3. Obtain the sources of packages you want to build _(together with ROS 2)_:
	* CTU's F1Tenth
		* (rolling, humble) `make clone-auto-additional` – additional packages when ROS 2 apt binary packages are not
		  available or ROS 2 is built from sources
		* (galactic) `make clone-auto-additional.galactic` – additional packages when ROS 2 apt binary packages are not
		  available or ROS 2 is built from sources
	* Stage simulator
		* `make clone-stage-additional` – additional packages when ROS 2 apt binary packages are not available or ROS 2
		  is built from sources

4. Build the workspace using `colcon`. You can also use the following shortcuts:
	* `make build`
	* `make build-no-db`
	* `make build-merge-install`
	* `make clean`

See the [Makefile](./Makefile) for detailed info.


### stage

Here are described some additional dependencies that needs to be installed when building _stage_ packages:

* on macOS:
	* TODO
* on Ubuntu 20.04:
	* assuming that build tools like cmake and build-essentials are already installed
	* these are already present: `libgl1-mesa-dev libglu1-mesa-dev libpng12-dev libtool` (`libpng16` also works)
	* `sudo apt install libfltk1.1-dev`
* on NVIDIA Jetson TX2 Jetpack 4.5.x (L4T 32.5.x) (Ubuntu 18.04):
	* `sudo apt install libfltk1.1-dev libjpeg-dev`


### stage-additional

Here are described some additional dependencies that needs to be installed when building _stage-additional_ packages:

* on macOS:

  **TODO: Update notes for Galactic**

  **Foxy: If you are on macOS < 10.15, see [pluginlib build on macOS < 10.15](./patches/pluginlib-macOS-10.14.md).**

  _TODO: Foxy: Document adapting brew's boost-python3 formula for Python 3.8_

* on NVIDIA Jetson TX2 Jetpack 4.5.x (L4T 32.5.x) (Ubuntu 18.04):

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

[jetson-tx2-ros2-build-notes]: https://github.com/pokusew/ros-setup/blob/main/nvidia-jetson-tx2/SETUP.md#install-ros-2

[ros2-tools-setup]: https://docs.ros.org/en/galactic/Installation/Alternatives/Ubuntu-Development-Setup.html#system-setup

[colcon]: https://colcon.readthedocs.io/

[colcon-workspace]: https://colcon.readthedocs.io/en/released/user/what-is-a-workspace.html

[vcstool]: https://github.com/dirk-thomas/vcstool
