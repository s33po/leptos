FROM scratch AS ctx
COPY build_files /build_files

FROM quay.io/almalinuxorg/almalinux-bootc:10-kitten

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/boot \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build_files/build.sh

CMD ["/sbin/init"]

RUN bootc container lint
