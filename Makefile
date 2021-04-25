# useful shortcuts

clone-ros2:
	@echo "cloning ros2 packages ..."
	vcs import src < repos/ros2.repos

clone-ros2-mini:
	@echo "cloning ros2-mini packages ..."
	vcs import src < repos/ros2-mini.repos

clone-additional:
	@echo "cloning additional packages ..."
	vcs import src < repos/all.repos

clone-stage:
	@echo "cloning stage-related packages ..."
	vcs import src < repos/stage.repos

patch-stage:
	@echo "patching stage-related packages ..."
	git apply --directory src patches/Fix_stage_CMakeLists_txt_Fix_stage_ros2_CMakeLists_txt.patch

build:
	@echo "building the whole workspace (with compilation db)..."
	colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=1

build-no-db:
	@echo "building the whole workspace (without compilation db)..."
	colcon build --symlink-install

clean:
	rm -rf build/ install/ log/ compile_commands.json .vscode/

.PHONY: clone-ros2 clone-ros2-mini clone-additional clone-stage patch-stage build build-no-db clean
