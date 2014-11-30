#! /bin/bash
###############################################################################
# deb-cryptlvm-nokvm
#
# automated install of remotely unlocked encrypted rootfs systems
# 
# Copyright (C) 2014 nipil (nipil@users.noreply.github.com)
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
###############################################################################

########################################################################################
# load configuration file
#
source template.conf

########################################################################################
# show usage
#

usage()
{
	echo -ne "Usage: ${0} operation [args]\n" \
	  "\tconfig\n" \
	  "\tprereq\n" \
	  "\tusage\n"

}

########################################################################################
# dump loaded configuration
#

config()
{

DCN="DCN_DISK DCN_FSTYPE DCN_VG_NAME DCN_ROOTFS_SIZE DCN_SWAP_SIZE \
     DCN_BOOTSTRAP_MIRROR DCN_BOOTSTRAP_ARCH DCN_BOOTSTRAP_RELEASE \
     DCN_INSTALL_RECOMMENDS DCN_INSTALL_ETCKEEPER DCN_HOST_NAME \
     DCN_HOST_IFACE DCN_HOST_IP DCN_HOST_MASK DCN_HOST_GW \
     DCN_SSH_PORT_PREBOOT DCN_SSH_PORT_BOOTED DCN_SSH_AUTHKEYS_SRCFILE"

for i in ${DCN}; do
	echo "${i}=${!i}"
done

echo "DCN_PARTITIONS=("
for i in ${DCN_PARTITIONS[@]}; do
	echo ${i}
done
echo ")"

}

########################################################################################
# verify that the required tools are available
#

prereq()
{

PREREQ="fdisk mkfs.ext4 cryptsetup pvcreate vgcreate lvcreate mkswap \
        mkdir mount swapon chmod grep awk debootstrap chroot umount swapoff \
        vgchange"

for i in ${PREREQ}; do
	j=`which ${i}`
	if [[ ! -x ${j} ]]; then
		echo "${i} not found"
		exit 1
	else
		echo "found ${i} at ${j}"
	fi
done

}

########################################################################################
# main part
#

case "${1}" in
	usage)
		usage
		exit 0
		;;
	config)
		config
		exit 0
		;;
	prereq)
		prereq
		exit 0
		;;
	*)
		usage
		exit 0
		;;
esac

