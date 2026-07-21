IMAGE_NAME ?= localhost/leptos:latest
REMOTE_IMG ?= ghcr.io/s33po/leptos:main

.PHONY: build
build:
	podman build \
		--cap-add=all \
		--security-opt=label=type:container_runtime_t \
		--device /dev/fuse \
		--pull=newer \
		-t $(IMAGE_NAME) .

.PHONY: buildah
buildah:
	buildah bud \
		--cap-add=all \
		--security-opt=label=type:container_runtime_t \
		--skip-unused-stages=false \
		--device /dev/fuse \
		--pull=newer \
		-t $(IMAGE_NAME) .

.PHONY: chunkah
chunkah:
	export CHUNKAH_CONFIG_STR="$$(podman inspect $(IMAGE_NAME))"
	podman run --rm \
		"--mount=type=image,src=$(IMAGE_NAME),target=/chunkah" \
		-e CHUNKAH_CONFIG_STR quay.io/coreos/chunkah build \
		--prune /sysroot/ --label ostree.commit- --label ostree.final-diffid- \
		--label containers.bootc=1 --compressed --max-layers 128 \
		--tag "$(IMAGE_NAME)" \
		| podman load

.PHONY: run
run:
	podman run --rm \
		-it $(IMAGE_NAME) bash

.PHONY: build-iso
build-iso:
	mkdir -p ./output
	sudo podman pull $(REMOTE_IMG)
	sudo podman run \
		--rm \
		-it \
		--privileged \
		--pull=newer \
		--security-opt label=type:unconfined_t \
		-v ./output:/output \
		-v ./bib.iso.config.toml:/config.toml:ro \
		-v /var/lib/containers/storage:/var/lib/containers/storage \
		quay.io/centos-bootc/bootc-image-builder:latest \
		--type anaconda-iso \
		--rootfs xfs \
		--use-librepo=True \
		--chown "$(id -u):$(id -g)" \
		$(REMOTE_IMG)

.PHONY: clean
clean:
	sudo rm -rf ./output || true
	rm -f config.toml
	podman rmi localhost/leptos || true
	podman image prune -f || true
	sudo podman image prune -a -f || true
	echo "Cleanup complete!"
