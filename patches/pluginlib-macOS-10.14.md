# ROS 2 Foxy pluginlib build on macOS < 10.15

**Note:** This only applies to the pluginlib **foxy** version. In the **galactic**, the problematic filesystem impl.
header file was [replaced](https://github.com/ros/pluginlib/commit/202d1721036807ffb0f8fdc70a52d28b8c97e38f)
in favor of [rcpputils's](https://github.com/ros2/rcpputils)
[filesystem_helper.hpp](https://github.com/ros2/rcpputils/blob/master/include/rcpputils/filesystem_helper.hpp)
and [filesystem_helper.cpp](https://github.com/ros2/rcpputils/blob/master/src/filesystem_helper.cpp), which do **not**
do any feature detection (that's the thing that was broken in foxy) and instead always emulate `std::filesystem`.


## Problem

ROS Foxy's [pluginlib](https://github.com/ros/pluginlib/tree/foxy) package tries to use `std::filesystem`
or `std::experimental::filesystem`.

However, when building pluginlib on macOS < 10.15 (e.g. macOS 10.14 Mojave), clang compiler
evaluates [this line](https://github.com/ros/pluginlib/blob/foxy/pluginlib/include/pluginlib/impl/filesystem_helper.hpp#L52)
with ` __has_include(<experimental/filesystem>)` as `true` so the `#include <experimental/filesystem>`
with `std::experimental::filesystem` is used.

And when the build targets macOS < 10.15, the implementation of `std::experimental::filesystem`
is not included and the build fails with multiple errors `... is unavailable: introduced in macOS 10.15`. We could solve
this with the compilation flag `-mmacosx-version-min=10.15`
but then the resulting executable could not run on macOS < 10.15 (and that's not what we want).


## Solution

The correct solution is to let
the [filesystem_helper.hpp](https://github.com/ros/pluginlib/blob/foxy/pluginlib/include/pluginlib/impl/filesystem_helper.hpp#L76)
use its emulated version of `std::filesystem`.

**You can use the following command** to apply **[the patch](./pluginlib-macOS-10.14.patch)** to
the [filesystem_helper.hpp](https://github.com/ros/pluginlib/blob/foxy/pluginlib/include/pluginlib/impl/filesystem_helper.hpp):
```bash
patch /path/to/ros/foxy/include/pluginlib/impl/filesystem_helper.hpp patches/pluginlib-macOS-10.14.patch
```


### Explanation of the patch file

We need to
alter [this line](https://github.com/ros/pluginlib/blob/foxy/pluginlib/include/pluginlib/impl/filesystem_helper.hpp#L52)
so the `std::experimental::filesystem` is not used on macOS < 10.15:

```c
# elif __has_include(<experimental/filesystem>) && (!defined(__MAC_OS_X_VERSION_MIN_REQUIRED) || __MAC_OS_X_VERSION_MIN_REQUIRED >= 101500)
```

In order to be able to use `__MAC_OS_X_VERSION_MIN_REQUIRED` we need to add a conditional include at the top of the
file:

```c
#ifdef __APPLE__ || __OSX__
# include <Availability.h>
#endif
```


## Related info

* https://github.com/ros/pluginlib/issues/215
* https://github.com/ros-perception/image_common/issues/139

---

_Just for reference:_ macOS 10.14.6 with XCode 11.3.1 (11C504) `clang -v` prints:

```
Apple clang version 11.0.0 (clang-1100.0.33.17)
Target: x86_64-apple-darwin18.7.0
Thread model: posix
InstalledDir: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bi
```
