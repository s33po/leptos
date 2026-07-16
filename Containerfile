FROM quay.io/centos/centos:stream10 AS repos
FROM quay.io/centos-bootc/centos-bootc:stream10 AS imagectl
FROM quay.io/centos/centos:stream10 AS builder

RUN dnf install -y \
    podman \
    bootc \
    ostree \
    rpm-ostree \
    && dnf clean all

COPY --from=imagectl /usr/share/doc/bootc-base-imagectl/ /usr/share/doc/bootc-base-imagectl/
COPY --from=imagectl /usr/libexec/bootc-base-imagectl /usr/libexec/bootc-base-imagectl
RUN chmod +x /usr/libexec/bootc-base-imagectl

RUN rm -rf /etc/yum.repos.d/*
RUN rm -rf /etc/pki/rpm-gpg/*

COPY --from=repos /etc/yum.repos.d/*.repo /etc/yum.repos.d/
COPY --from=repos /etc/pki/rpm-gpg/ /etc/pki/rpm-gpg/

COPY leptos.yaml /usr/share/doc/bootc-base-imagectl/manifests/

RUN /usr/libexec/bootc-base-imagectl build-rootfs --reinject --manifest=leptos /target-rootfs

###

FROM scratch AS ctx
COPY build_files /build_files/

###

FROM scratch
COPY --from=builder /target-rootfs/ /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/boot \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build_files/build.sh

LABEL containers.bootc="1" \
      ostree.bootable="1" \
      org.opencontainers.image.version="10" \
      version="10"

ENV container=oci

STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]

RUN --mount=type=tmpfs,target=/run --network=none bootc container lint
