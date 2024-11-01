#!/bin/bash
set -e

# UMOUNT
swapoff /mnt/swap/swapfile
umount -R /mnt
cryptsetup close root

