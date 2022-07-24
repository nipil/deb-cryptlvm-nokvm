# OBSOLETE

This repository has been archived and will not be updated anymore.

# What is it good for ?

Let's say you have a server you want to run debian on. Let's say you
want to have the filesystems encrypted, all of them, including the root.
Let's say you can't access the local screen/console/kvm to type the
passphrase needed to unlock the disks.

Then what you need is a way of entering the passphrase remotely, via SSH.
But that setup is prone to errors, even more on a remote, cloud-based system.

This is why i wrote these scripts, which enable me to install a secure debian
system at my hosting provider (who doesn't provide any console/screen/KVM)

# Warning !

No confirmations or warning are issued. The very first operation just straight
away partitions your hard drive without interaction. So be sure of what drive
you are providing and don't forget that everything on that drive will be wiped.

# How to use

This  script is meant to be run from a live/rescue environment. First thing
needed is making sure that the target storage device is absolutely not
mounted, nor part of anything active on the system, ie that it can be
partitionned without interfering with anything running.

First you **HAVE TO** read/modify/configure the `template.conf` file.

It contains everything used to setup the target system. Failing to review
any of the included variables will surely have you wonder what happened
and why it doesn't "work"...

Then, running the script without arguments will give the usage informations.
There are two modes : an all-in-one "makeall", and each steps separately.

*Disclaimer* : if you decide to run as makeall for a first use, i advise you
against it, but if you do, then run it inside a script recording with bash
debugging turned on :

    script log.txt
    bash -x dcn makeall
    exit
    less log.txt

The recommended mode of using the script is to do step by step setup.
Calling the script without arguments will give a usage summary.

    ./dcn config     # dumps template configuration
    ./dcn prereq     # checks for required tools
    ./dcn partition  # create new partition table and 2 partitions
    ./dcn crypt      # create luks volume using cryptsetup and opens it
    ./dcn lvm_create # create requested volume group and logical volumes
    ./dcn mkfs       # create filesystems in the logical volumes
    ./dcn mount      # mount the filesystems in the requested paths
    ./dcn bootstrap  # install new system in the target environment
    ./dcn prechroot  # setup needed files for mount and boot
    ./dcn chrootops  # install all the actual boot related packages

And of course, inbetween two operations, review each line of the output for
eventual errors ! And be sure to not go forward unless you are confident that
the output is correct.

Finally, once everything is done and you're satisfied, simply `reboot`.

By the way, if/when you want to "restart" the procedure, make sure that you
release the disk structure before running the first steps again !

    ./dcn umount         # will unmount whatever anywhere on target system
    ./dcn lvm_deactivate # will disable the target volume group
    ./dcn lvm_destroy    # will destroy the logical volumes and volume group
    ./dcn cryptoff       # will close the target luks parition

In any case, you can prefix each invocation with `bash -x` to see the actual
commands being executed. If you want to provide feedback or signal bugs,
use `script` as mentionned above to be able to document what went wrong,
before providing the actual feedback.

# Booting the system

When your target system boots, it will load the kernel and initramfs, then it
run dropbear, and attempt to open your luks volume.

You will then connect to the dropbear ssh daemon, on port 22 by default, or
on the port you configured (see below in case of problems) using an ssh key
which is part of the authorization file you provided for install.

Once you're connected to the dropbear ssh daemon, you'll be presented with
a `~ #` prompt. Simply type `unlock` and press enter, then follow the onscreen
instructions.

Here is an example. First i tried to unlock, but entered the wrong passphrase.
Then i tried again, and entered the passphrase correctly.

    BusyBox v1.20.2 (Debian 1:1.20.0-7) built-in shell (ash)
    Enter 'help' for a list of built-in commands.
    
    ~ # unlock
    Enter passkey to unlock cryptroot, followed by Ctrl-D Ctrl-D:
    ..............................cryptroot not found, maybe wrong key ?
    ~ # unlock
    Enter passkey to unlock cryptroot, followed by Ctrl-D Ctrl-D:
    .......cryptroot unlocked, please type 'exit'
    ~ # exit

Please note the importance of the instructions displayed right above ! Why ?

You must enter your passphrase, **without hitting enter at the end**, but
entering *Ctrl-D* twice. That means pressing and holding the "control" key
of your keyboard, then hitting "d" "d", then releasing the "control" key.

I cannot stress this enough, otherwise you won't be able to unlock.

# Being resilient to dropbear package upgrades

Be aware that **IF** you configured to change unlock ssh daemon port, then
the script alters `/usr/share/initramfs-tools/scripts/init-premount/dropbear`

This is needed as dropbear, in initramfs, doesn't check environment
variables nor configuration files, nor anything outside of its command-line
arguments to decice how it will behave.

As a consequence, if/when an upgrade to that package is available in the
debian repository provides that script and you upgrade, then the customization
will be lost until it's restored.

This is why you might, in that very specific case, experience a port change
of the unlocking ssh daemon, which will "go back" to the default ssh port
which is port 22, until you reconfigure it, *again*.

To move dropbear back to your custom port :

- edit the above mentionned file as root
- the daemon invocation is usually `/sbin/dropbear` as a single line
- that single line is usually around the last line of the file
- change it to `/sbin/dropbear -p 12345` where 12345 is the port you want
- run `update-initramfs -u` as root to take the changes into account
- reboot to test your changes

That will do the job.

# A reminder on security

This setup is only as good as it is, and fundamentally is not and cannot 
be the "silver bullet" regarding data protection.

What is (definitly) secured :

- your root partition is crypted
- your swap partition is crypted
- all your other regular partition are crypted
- the passphrase needs to be entered remotely *on every boot*
- only the given SSH public keys can connect remotely to unlock

What is (inherently) **not** secured :

- there can't be no logging of ssh connections attempts
- there can't be no logging of passphrase attempts
- the boot partition is unencrypted

Furthermore, anyone with physical access to the hardware

- can install keyloggers/sniffer in the boot partition and get your passphrase
- has infinite guesses at the passphrase when attaching screen/console/kvm

As a consequence of the above, every time you enter your passhrase, to stay
safe you must be sure that the hardware has not been tampered with.

