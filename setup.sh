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

# load configuration file
source template.conf

# debug
echo "$DCN_DISK"
echo "$DCN_FSTYPE"
echo "$DCN_VG_NAME"
echo "$DCN_ROOTFS_SIZE"
echo "$DCN_SWAP_SIZE"
for i in ${DCN_PARTITIONS[@]}; do
	echo $i
done
echo "$DCN_BOOTSTRAP_MIRROR"
echo "$DCN_BOOTSTRAP_ARCH"
echo "$DCN_BOOTSTRAP_RELEASE"
echo "$DCN_INSTALL_RECOMMENDS"
echo "$DCN_INSTALL_ETCKEEPER"
echo "$DCN_HOST_NAME"
echo "$DCN_HOST_IFACE"
echo "$DCN_HOST_IP"
echo "$DCN_HOST_MASK"
echo "$DCN_HOST_GW"
echo "$DCN_SSH_PORT_PREBOOT"
echo "$DCN_SSH_PORT_BOOTED"
echo "$DCN_SSH_AUTHKEYS_SRCFILE"

