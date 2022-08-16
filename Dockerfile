FROM actions/npm:6.14.4-focal3 as build

ARG REQUIRED_PACKAGES=""
ARG IMAGE_NAME=""

ENV ROOTFS /build/rootfs
ENV DEBIAN_FRONTEND=noninteractive

SHELL ["bash", "-Eeuc"]

RUN mkdir -p ${ROOTFS}/{usr/local/lib,usr/local/bin} \
      && npm --force --unsafe-perm --prefix ${ROOTFS}/usr/local install -g ${REQUIRED_PACKAGES}

COPY ${IMAGE_NAME}.entrypoint.sh ${ROOTFS}/usr/local/bin/entrypoint.sh
RUN chmod +x ${ROOTFS}/usr/local/bin/entrypoint.sh

FROM actions/node:10.19.0-focal2
LABEL maintainer = "ilja+docker@bobkevic.com"

ARG ROOTFS=/build/rootfs

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

COPY --from=build ${ROOTFS} /

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
