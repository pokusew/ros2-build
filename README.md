# ros2-additions

This a ROS 2 workspace containing additional packages for ROS 2 (Foxy).

TODO: document purpose, content, usage


## Installation

**Requirements:**
* https://github.com/dirk-thomas/vcstool


### Stage

* on macOS:
    * TODO
* on Ubuntu 20.04.2:
    * assuming that build tools like cmake and build-essentials are already installed
    * these are already present: `libgl1-mesa-dev libglu1-mesa-dev libpng12-dev libtool` (`libpng16` also works)
    * `sudo apt install libfltk1.1-dev`  
* on NVIDIA Jetson TX2 Jetpack 4.5.1 (L4T 32.5.1) (Ubuntu 18.04.5):
    * `sudo apt install libfltk1.1-dev libjpeg-dev`


### All

* on macOS: TODO

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


### Stage build warning

TODO: Can we use GLVND for OpenGL and GLX for Stage build?

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
