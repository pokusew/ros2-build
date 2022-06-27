# useful shortcuts

src:
	@echo "creating src dir ..."
	mkdir -p src

.PHONY: init
init: src

.PHONY: pull
pull:
	@echo "running vcs pull --nested ..."
	vcs pull --nested

.PHONY: clone-ros
clone-ros: src
	@echo "cloning packages for ROS 2 distribution '$(distro)' ..."
	vcs import src --input https://raw.githubusercontent.com/ros2/ros2/$(distro)/ros2.repos

.PHONY: clone-auto-additional
clone-auto-additional: src
	@echo "cloning auto-additional packages ..."
	vcs import src < repos/auto-additional.repos

.PHONY: clone-auto-additional.galactic
clone-auto-additional.galactic: src
	@echo "cloning auto-additional.galactic packages ..."
	vcs import src < repos/auto-additional.galactic.repos

.PHONY: clone-stage-additional
clone-stage-additional: src
	@echo "cloning stage-additional packages ..."
	vcs import src < repos/stage-additional.repos

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
