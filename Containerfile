FROM quay.io/centos-bootc/centos-bootc:stream10 AS imagectl
FROM quay.io/centos/centos:stream10 AS builder

RUN dnf install -y rpm-ostree selinux-policy-targeted python3

COPY --from=imagectl /usr/share/doc/bootc-base-imagectl/ /usr/share/doc/bootc-base-imagectl/
COPY --from=imagectl /usr/libexec/bootc-base-imagectl /usr/libexec/bootc-base-imagectl
RUN chmod +x /usr/libexec/bootc-base-imagectl

COPY leptos.yaml /usr/share/doc/bootc-base-imagectl/manifests/

RUN /usr/libexec/bootc-base-imagectl build-rootfs --reinject --manifest=leptos /target-rootfs

###

FROM scratch
COPY --from=builder /target-rootfs/ /

RUN --mount=type=bind,source=build_files,target=/ctx/build_files \
    --mount=type=tmpfs,dst=/boot \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build_files/build.sh

LABEL containers.bootc 1
LABEL ostree.bootable 1

ENV container=oci

STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]

RUN --mount=type=tmpfs,target=/run bootc container lint --fatal-warnings
