# packer-ubuntu-server-uefi
Templates for creating Ubuntu Live Server Images with Packer + QEMU + Autoinstall (cloud-init)

Currently Supported Images:

| Name                | Version       |
|:--------------------|:-------------:|
| __Focal Fossa__     |     `20.04.6` |
| __Jammy Jellyfish__ |     `22.04.4` |
| __Noble Numbat__    |     `24.04`   |

An accompanying blogpost is available [here][1]

## Usage

Use GNU-Make to perform validation / build images:

### Validation

To validate `cloud-init` and `ubuntu.pkr.hcl` template perform

```bash
make validate
```

To simply validate `cloud-init` against all distros

```bash
make validate-cloudinit
```

To validate `cloud-init` configuration of a specific distro (`focal`, `jammy`, `noble`)

```bash
make validate-cloudinit-<distroname> # <distroname> here is either focal, jammy or noble
```

To simply validate `ubuntu.pkr.hcl` template against all distros

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

to build Ubuntu 24.04 (Noble) image

```bash
make build-noble
```

## UEFI BootLoader Sequence Determination

see the `late-commands` in the `user-data` file. This is determined by installing `efibootmgr` on the live
image and performing `sudo efibootmgr`. This lists what are the sequences and when should the image be booted.

> NOTE: there seems to be compatibility issue between Ubuntu 24.04 and older Ubuntu LTS version in terms of
> output from the `efibootmgr`, namely, Capitalization. Hence each Cloud-Init `user-data` now is in a 
> separate directory under the `http` directory in the repo.

[1]: https://shantanoo-desai.github.io/posts/technology/packer-ubuntu-qemu/
