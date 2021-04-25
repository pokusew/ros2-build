# useful shortcuts

clone-all:
	@echo "cloning all packages ..."
	vcs import < repos/all.repos

clone-stage:
	@echo "cloning stage-related packages ..."
	vcs import < repos/stage.repos

patch-stage:
	@echo "patching stage-related packages ..."
	git apply --directory src patches/Fix_stage_CMakeLists_txt_Fix_stage_ros2_CMakeLists_txt.patch

build:
	@echo "building the whole workspace..."
	colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=1

clean:
	rm -rf build/ install/ log/ compile_commands.json .vscode/

.PHONY: clone-all cone-stage patch clean
