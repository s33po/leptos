FROM scratch AS ctx
COPY build_files /build_files

FROM quay.io/almalinuxorg/almalinux-bootc:10

RUN --mount=type=bind,from=ctx,source=/build_files,target=/build_files \
    --mount=type=tmpfs,dst=/boot \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /build_files/build.sh

RUN bootc container lint

ENV container=oci

LABEL containers.bootc=1
LABEL ostree.bootable=1

STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
