# packer-ubuntu-server-uefi
Templates for creating Ubuntu Live Server Images (20.04.5 / 22.04.1) with Packer + QEMU + Autoinstall (cloud-init)

An accompanying blogpost is available [here][1]

## Usage

Use GNU-Make to perform validation / build images:

### Validation

To validate `cloud-init` and `ubuntu.pkr.hcl` template perform

```bash
make validate
```

To simply validate `cloud-init`

```bash
make validate-cloudinit
```

To simply validate `ubuntu.pkr.hcl` template (against both `focal` and `jammy`)

```bash
make validate-packer
```

### Build Images

to build Ubuntu 20.04 (Focal) image

```bash
make build-focal
```

to build Ubuntu 22.04 (Jammy) image

```bash
make build-jammy
```

## UEFI BootLoader Sequence Determination

see the `late-commands` in the `user-data` file. This is determined by installing `efibootmgr` on the live
image and performing `sudo efibootmgr`. This lists what are the sequences and when should the image be booted.

[1]: https://shantanoo-desai.github.io/posts/technology/packer-ubuntu-qemu/
