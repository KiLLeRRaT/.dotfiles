# Wi-Fi investigation handoff

Current conclusion:

- Wi-Fi worked on `2026-03-10` or `2026-03-13`.
- The likely regression window is `2026-03-16`.
- `pacman.log` shows these were already attempted earlier on `2026-03-16`:
  - `linux-firmware-broadcom -> 20260110-1`
  - `linux-firmware -> 20260110-1`
  - full split firmware rollback to `20260110-1`
  - full split firmware rollback to `20251125-2`
  - `linux -> 6.18.9.arch1-2`
  - `linux -> 6.18.7.arch1-1`
- Remaining higher-value suspects/tests:
  - boot and verify `linux-lts`
  - downgrade `linux-lts` from `6.18.18-1` to `6.18.16-1`
  - downgrade `iwd` from `3.12-1` to `3.11-2`
  - if still broken, inspect config/runtime differences instead of repeating old downgrade loops

Files to read first next session:

- `wifi-downgrade-commands.md`
- `todo.md`

Suggested next action:

- Start with the revised order in `wifi-downgrade-commands.md`, not the older kernel/firmware-first order.

What to report back after reboot:

- Which step you ran
- Whether Wi-Fi worked after that step
- Output of:

```bash
uname -r
pacman -Q linux linux-lts linux-firmware linux-firmware-broadcom iwd networkmanager
sudo dmesg -T | grep -iE 'brcm|brcmfmac|firmware|wlan|wifi|80211|pcie'
```
