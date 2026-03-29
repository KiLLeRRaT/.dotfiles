# Wi-Fi downgrade test order

Known good window: Wi-Fi worked on `2026-03-10` or `2026-03-13`.

Likely regression window: `2026-03-16`.

Important: `pacman.log` shows that a lot of downgrade work was already done on `2026-03-16`. So this file now separates:

- what was already tried
- what is still worth testing

Test one change at a time in this order. After each change:

1. Reboot if noted.
2. Test Wi-Fi.
3. If Wi-Fi works again, that package is the likely culprit.
4. If Wi-Fi is still broken, continue to the next step.

## 0. Record current state

```bash
uname -r
pacman -Q linux linux-lts linux-firmware linux-firmware-broadcom iwd networkmanager
```

## Already tried earlier on 2026-03-16

These actions are visible in `pacman.log`, so do not repeat them first unless you want to explicitly re-test them after reboot:

- Downgraded `linux-firmware-broadcom` from `20260221-1` to `20260110-1`
- Downgraded `linux-firmware` from `20260221-1` to `20260110-1`
- Downgraded the full split firmware set to `20260110-1`
- Downgraded the full split firmware set again to `20251125-2`
- Downgraded `linux` from `6.19.6.arch1-1` to `6.18.9.arch1-2`
- Downgraded `linux` from `6.18.9.arch1-2` to `6.18.7.arch1-1`
- Then later upgraded back to:
  - `linux 6.19.8.arch1-1`
  - `linux-firmware-broadcom 20260309-1`
  - `linux-firmware 20260309-1`
  - `linux-lts 6.18.18-1`
  - `iwd 3.12-1`

Because you said those downgrade attempts were still broken, the most likely remaining suspects are now:

- `linux-lts 6.18.18-1` vs `6.18.16-1`
- `iwd 3.12-1`
- some non-package config/runtime change

## 1. Boot the `linux-lts` kernel first

Do this before changing packages. If Wi-Fi works on `linux-lts`, the culprit is probably the mainline `linux` kernel.

After booting, verify with:

```bash
uname -r
sudo dmesg -T | grep -iE 'brcm|brcmfmac|firmware|wlan|wifi|80211|pcie'
```

This is now the highest-value test if you have not already booted and verified `linux-lts`.

## 2. Downgrade `linux-lts` to `6.18.16-1`

`pacman.log` shows `linux-lts` was upgraded on March 16, but not later downgraded again.

```bash
sudo pacman -U /var/cache/pacman/pkg/linux-lts-6.18.16-1-x86_64.pkg.tar.zst
```

Reboot and test.

## 3. Downgrade `iwd` to `3.11-2`

`pacman.log` shows `iwd` was upgraded to `3.12-1` on March 16, and I do not see a later rollback.

```bash
sudo pacman -U /var/cache/pacman/pkg/iwd-3.11-2-x86_64.pkg.tar.zst
sudo systemctl restart iwd NetworkManager
```

If Wi-Fi behavior is flaky after the service restart, reboot and test again.

## 4. Re-test old firmware with old mainline kernel only if needed

Only do this if you want to confirm a mixed interaction after reboot, because the log only proves package changes happened, not exactly which booted combination was tested.

Try this combination:

```bash
sudo pacman -U \
  /var/cache/pacman/pkg/linux-6.18.7.arch1-1-x86_64.pkg.tar.zst \
  /var/cache/pacman/pkg/linux-headers-6.18.7.arch1-1-x86_64.pkg.tar.zst \
  /var/cache/pacman/pkg/linux-firmware-20260110-1-any.pkg.tar.zst \
  /var/cache/pacman/pkg/linux-firmware-broadcom-20260110-1-any.pkg.tar.zst
```

Reboot and test.

## 5. Re-test even older split firmware only if needed

If you want to verify the broadest old-firmware case after a reboot:

```bash
sudo pacman -U \
  /var/cache/pacman/pkg/linux-firmware-amdgpu-20251125-2-any.pkg.tar.zst \
  /var/cache/pacman/pkg/linux-firmware-atheros-20251125-2-any.pkg.tar.zst \
  /var/cache/pacman/pkg/linux-firmware-broadcom-20251125-2-any.pkg.tar.zst \
  /var/cache/pacman/pkg/linux-firmware-cirrus-20251125-2-any.pkg.tar.zst \
  /var/cache/pacman/pkg/linux-firmware-intel-20251125-2-any.pkg.tar.zst \
  /var/cache/pacman/pkg/linux-firmware-mediatek-20251125-2-any.pkg.tar.zst \
  /var/cache/pacman/pkg/linux-firmware-nvidia-20251125-2-any.pkg.tar.zst \
  /var/cache/pacman/pkg/linux-firmware-other-20251125-2-any.pkg.tar.zst \
  /var/cache/pacman/pkg/linux-firmware-radeon-20251125-2-any.pkg.tar.zst \
  /var/cache/pacman/pkg/linux-firmware-realtek-20251125-2-any.pkg.tar.zst \
  /var/cache/pacman/pkg/linux-firmware-whence-20251125-2-any.pkg.tar.zst
```

Reboot and test.

## Lower-priority old steps kept for reference

These are no longer first-line because the log shows they were already attempted as package changes:

## 6. Downgrade `linux` only to `6.19.6.arch1-1`

Most likely first test if Wi-Fi is broken only on the mainline kernel.

```bash
sudo pacman -U /var/cache/pacman/pkg/linux-6.19.6.arch1-1-x86_64.pkg.tar.zst
```

Reboot and test.

## 7. Downgrade `linux` only to `6.18.9.arch1-2`

If `6.19.6` still fails:

```bash
sudo pacman -U /var/cache/pacman/pkg/linux-6.18.9.arch1-2-x86_64.pkg.tar.zst
```

Reboot and test.

## 8. Downgrade `linux` only to `6.18.7.arch1-1`

If `6.18.9` still fails:

```bash
sudo pacman -U /var/cache/pacman/pkg/linux-6.18.7.arch1-1-x86_64.pkg.tar.zst
```

Reboot and test.

## 9. Downgrade `linux-firmware-broadcom` only to `20260221-1`

If kernel downgrades do not change anything, test the most targeted firmware package next:

```bash
sudo pacman -U /var/cache/pacman/pkg/linux-firmware-broadcom-20260221-1-any.pkg.tar.zst
```

Reboot and test.

## 10. Downgrade `linux-firmware-broadcom` only to `20260110-1`

If still broken:

```bash
sudo pacman -U /var/cache/pacman/pkg/linux-firmware-broadcom-20260110-1-any.pkg.tar.zst
```

Reboot and test.

## 11. Downgrade `linux-firmware-broadcom` only to `20251125-2`

If still broken:

```bash
sudo pacman -U /var/cache/pacman/pkg/linux-firmware-broadcom-20251125-2-any.pkg.tar.zst
```

Reboot and test.

## 12. Downgrade `linux-firmware` meta package to `20260110-1`

Only do this if the Broadcom package change alone did not fix it. This package may pull package relationships back into a more consistent state.

```bash
sudo pacman -U /var/cache/pacman/pkg/linux-firmware-20260110-1-any.pkg.tar.zst
```

Reboot and test.

## Notes

- New preferred order: `boot linux-lts` -> `downgrade linux-lts` -> `downgrade iwd` -> optional mixed kernel/firmware re-test.
- `networkmanager` itself did not change on March 16. The March 16 log only shows `networkmanager-l2tp` plugin upgrades.
- If none of the remaining tests help, next step is to compare runtime config and services, not keep looping through the same kernel/firmware downgrades.
