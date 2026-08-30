FROM scratch AS ctx
COPY build_files /build_files

FROM ghcr.io/s33po/leptos-base:main AS unchunked

RUN --mount=type=bind,from=ctx,source=/build_files,target=/build_files \
    --mount=type=tmpfs,dst=/boot \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/run \
    --mount=type=tmpfs,dst=/tmp \
    /build_files/build.sh

RUN bootc container lint

# Rechunk image using chunkah
FROM quay.io/coreos/chunkah AS chunkah
RUN --mount=from=unchunked,src=/,target=/chunkah,ro \
    --mount=type=bind,target=/run/src,rw \
    chunkah build \
        --max-layers 127 \
        --prune /sysroot/ \
        --label ostree.commit- \
        --label ostree.final-diffid- \
        --output oci:/run/src/out

# Create the final image from the rechunked oci output
FROM oci:out AS chunked

LABEL containers.bootc=1
ENV container=oci
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
