IMAGE_NAME ?= localhost/leptos:latest
BASE_IMAGE ?= ghcr.io/s33po/leptos-base:main
REMOTE_IMG ?= ghcr.io/s33po/leptos:main

.PHONY: build
build:
	podman build \
		--cap-add=all \
		--security-opt=label=type:disable \
		--device /dev/fuse \
		--pull=newer \
		--target unchunked \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		-f ./Containerfile \
		-t $(IMAGE_NAME) .

.PHONY: chunk
chunk:
	podman run --rm \
		"--mount=type=image,src=$(IMAGE_NAME),target=/chunkah" \
		-e CHUNKAH_CONFIG_STR="$$(podman inspect $(IMAGE_NAME))" \
		quay.io/coreos/chunkah build \
		--prune /sysroot/ --label ostree.commit- --label ostree.final-diffid- \
		--compressed --max-layers 256 \
		--tag "$(IMAGE_NAME)" \
		| podman load

.PHONY: run
run:
	podman run --rm \
		-it $(IMAGE_NAME) bash

.PHONY: iso-build
iso-build:
	mkdir -p ./output
	sudo podman pull $(REMOTE_IMG)
	sed 's|$${TARGET_IMAGE}|$(REMOTE_IMG)|g' bib-iso-config.toml > output/bib-iso-config.toml
	sudo podman run \
		--rm \
		-it \
		--privileged \
		--pull=newer \
		--security-opt label=type:unconfined_t \
		-v ./output:/output \
		-v ./output/bib-iso-config.toml:/config.toml:ro \
		-v /var/lib/containers/storage:/var/lib/containers/storage \
		quay.io/centos-bootc/bootc-image-builder:latest \
		--type anaconda-iso \
		--rootfs xfs \
		--use-librepo=True \
		--chown "$(id -u):$(id -g)" \
		$(REMOTE_IMG)

.PHONY: clean
clean:
	sudo rm -rf ./output ./out || true
	podman rmi localhost/leptos || true
	podman image prune -f || true
	sudo podman image prune -a -f || true

