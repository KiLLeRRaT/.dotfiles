#!/bin/bash

swapoff /mnt/swap/swapfile
umount -R /mnt
cryptsetup close root

