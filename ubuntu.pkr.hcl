# Copyright 2022 Shantanoo 'Shan' Desai <sdes.softdev@gmail.com>

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#       http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#  limitations under the License.


## Variable will be set via the Command line defined under the `vars` directory
variable "ubuntu_version" {
    type = string
}

variable "ubuntu_iso_file" {
    type = string
}

variable "vm_template_name" {
    type = string
    default = "packerubuntu"
}

locals {
    vm_name = "${var.vm_template_name}-${var.ubuntu_version}"
    output_dir = "output/${local.vm_name}"
}

source "qemu" "custom_image" {
    vm_name     = "${local.vm_name}"
    
    iso_url      = "https://releases.ubuntu.com/${var.ubuntu_version}/${var.ubuntu_iso_file}"
    iso_checksum = "file:https://releases.ubuntu.com/${var.ubuntu_version}/SHA256SUMS"

    # Location of Cloud-Init / Autoinstall Configuration files
    # Will be served via an HTTP Server from Packer
    http_directory = "http"

    # Boot Commands when Loading the ISO file with OVMF.fd file (Tianocore) / GrubV2
    boot_command = [
        "<spacebar><wait><spacebar><wait><spacebar><wait><spacebar><wait><spacebar><wait>",
        "e<wait>",
        "<down><down><down><end>",
        " autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
        "<f10>"
    ]
    
    boot_wait = "5s"

    # QEMU specific configuration
    cpus             = 4
    memory           = 4096
    accelerator      = "kvm" # use none here if not using KVM
    disk_size        = "30G"
    disk_compression = true

    # Use the UEFI Bootloader OVMF file on the Build Machine
    qemuargs         = [
        ["-bios", "/usr/share/OVMF/OVMF_CODE.fd"]
    ]

    # Final Image will be available in `output/packerubuntu-*/`
    output_directory = "${local.output_dir}"

    # SSH configuration so that Packer can log into the Image
    ssh_password    = "packerubuntu"
    ssh_username    = "admin"
    ssh_timeout     = "20m"
    shutdown_command = "echo 'packerubuntu' | sudo -S shutdown -P now"
    headless        = false # NOTE: set this to true when using in CI Pipelines
}

build {
    name    = "custom_build"
    sources = [ "source.qemu.custom_image" ]

    # Wait till Cloud-Init has finished setting up the image on first-boot
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for Cloud-Init...'; sleep 1; done" 
        ]
    }

    # Finally Generate a Checksum (SHA256) which can be used for further stages in the `output` directory
    post-processor "checksum" {
        checksum_types      = [ "sha256" ]
        output              = "${local.output_dir}/${local.vm_name}.{{.ChecksumType}}"
        keep_input_artifact = true
    }
}
