FROM actions/npm:3.5.2-1 as build

ARG REQUIRED_PACKAGES=""

ENV ROOTFS /build/rootfs
ENV DEBIAN_FRONTEND=noninteractive

RUN bash -c 'mkdir -p ${ROOTFS}/usr/local/bin' \
      && npm --force --prefix ${ROOTFS}/usr/local install -g ${REQUIRED_PACKAGES}

COPY entrypoint.sh ${ROOTFS}/usr/local/bin/entrypoint.sh
RUN chmod +x ${ROOTFS}/usr/local/bin/entrypoint.sh

FROM actions/node:8.10.0-3
LABEL maintainer = "ilja+docker@bobkevic.com"

ARG ROOTFS=/build/rootfs

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

COPY --from=build ${ROOTFS} /

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]