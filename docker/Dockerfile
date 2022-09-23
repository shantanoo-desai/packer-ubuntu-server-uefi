FROM hashicorp/packer:1.8
ENV PACKER_CACHE_DIR=/app/packer_cache

RUN apk add --no-cache --update \
        make \
        cloud-init \
        qemu \
        qemu-system-x86_64 \
        qemu-img \
        qemu-modules \
        openrc \
        libvirt-daemon \
        openssh \
        python3 \
        py3-pip \
        unzip \
        wget

WORKDIR /app

ENTRYPOINT ["/bin/sh", "-c"]
