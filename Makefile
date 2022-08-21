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

.PHONY: build-focal build-jammy validate-packer validate-cloudinit validate

TEMPLATE_FILE:=ubuntu.pkr.hcl

build-focal:
	PACKER_LOG=1 packer build -force -var-file=./vars/focal.pkrvars.hcl ${TEMPLATE_FILE}

build-jammy:
	PACKER_LOG=1 packer build -force -var-file=./vars/jammy.pkrvars.hcl ${TEMPLATE_FILE}

validate-focal:
	packer validate -var-file=./vars/focal.pkrvars.hcl ${TEMPLATE_FILE}

validate-jammy:
	packer validate -var-file=./vars/jammy.pkrvars.hcl ${TEMPLATE_FILE}

validate-packer: validate-focal validate-jammy

validate-cloudinit:
	cloud-init schema -c http/user-data

validate: validate-cloudinit validate-packer
