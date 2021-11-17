# useful shortcuts

src:
	@echo "creating src dir ..."
	mkdir -p src

.PHONY: clone-ros2
clone-ros2: src
	@echo "cloning ros2 packages ..."
	vcs import src < repos/ros2.repos

# .PHONY: clone-ros2-mini
# clone-ros2-mini: src
# 	@echo "cloning ros2-mini packages ..."
# 	vcs import src < repos/ros2-mini.repos

.PHONY: clone-auto-additional
clone-auto-additional: src
	@echo "cloning auto-additional packages ..."
	vcs import src < repos/auto-additional.repos

.PHONY: clone-stage
clone-stage: src
	@echo "cloning stage packages ..."
	vcs import src < repos/stage.repos

.PHONY: clone-stage-additional
clone-stage-additional: src
	@echo "cloning stage-additional packages ..."
	vcs import src < repos/stage-additional.repos

.PHONY: patch-stage
patch-stage:
	@echo "patching stage and stage_ros2 packages ..."
	git apply --directory src patches/Fix_stage_CMakeLists_txt_Fix_stage_ros2_CMakeLists_txt.patch

.PHONY: build
build:
	@echo "building the whole workspace (with compilation db)..."
	colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=1

.PHONY: build-no-db
build-no-db:
	@echo "building the whole workspace (without compilation db)..."
	colcon build --symlink-install

.PHONY: build-merge-install
build-merge-install:
	@echo "building the whole workspace (without compilation db) and using --merge-install..."
	colcon build --merge-install

.PHONY: clean
clean:
	rm -rf build/ install/ log/ compile_commands.json .vscode/ .env

.PHONY: clean-all
clean-all: clean
	rm -rf src/
