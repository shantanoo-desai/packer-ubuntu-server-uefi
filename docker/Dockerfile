FROM hashicorp/packer:1.10
ENV PACKER_CACHE_DIR=/app/packer_cache
ENV PACKER_CONFIG_DIR=/app

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
        wget \
        py3-netifaces

WORKDIR /app

ENTRYPOINT ["/bin/sh", "-c"]
