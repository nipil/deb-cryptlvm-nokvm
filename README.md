# What is it good for ?

Let's say you have a server you want to run debian on. Let's say you want to have
the filesystems encrypted, all of them, including the root. Let's say you can't 
access the local screen/console/kvm to type the passphrase needed to unlock the disks.

Then what you need is a way of entering the passphrase remotely, via SSH. But that's a
difficult thing to setup, even more on a remote, cloud-based system.

This is why i wrote these scripts, which enable me to install a secure debian system
at my hosting provider (who doesn't provide any console/screen/KVM)

