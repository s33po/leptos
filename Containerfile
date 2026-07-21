ARG BASE_IMG
ARG CHUNKAH_CONFIG_STR

FROM quay.io/centos-bootc/centos-bootc:stream10 AS imagectl
FROM ${BASE_IMG} AS builder

RUN dnf install -y rpm-ostree selinux-policy-targeted python3

COPY --from=imagectl /usr/share/doc/bootc-base-imagectl/ /usr/share/doc/bootc-base-imagectl/
COPY --from=imagectl /usr/libexec/bootc-base-imagectl /usr/libexec/bootc-base-imagectl
RUN chmod +x /usr/libexec/bootc-base-imagectl

COPY leptos.yaml /usr/share/doc/bootc-base-imagectl/manifests/

RUN /usr/libexec/bootc-base-imagectl build-rootfs --no-initramfs --reinject --manifest=leptos /target-rootfs

###

FROM scratch
COPY --from=builder /target-rootfs/ /

RUN --mount=type=bind,source=build_files,target=/build_files \
    --mount=type=tmpfs,dst=/boot \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /build_files/build.sh

# Final cleanup
RUN rm -rf /boot /var /tmp && mkdir -p /boot /var /var/tmp /tmp

RUN --mount=type=tmpfs,target=/run bootc container lint

ENV container=oci

LABEL containers.bootc=1
LABEL ostree.bootable=1

STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
