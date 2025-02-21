# .dotfiles

This is my .dotfiles.  It's as multi platform as I could make it, up to a point.  You will find
dotfiles for Linux, MacOS, and Windows in here.

# Installation

## Linux
### Arch
Installing arch using archinstall:
```bash
# Points at Github using a shortener
curl -L https://k.gouws.org/install-arch | bash
```
Then run the scripts in order:
```bash
./install-arch2.10-partition.sh
./install-arch2.20-mount.sh
./install-arch2.30-install.sh
./install-arch2.50-arch-chroot.sh
```

### Debian Server
```bash
    curl -LOJ https://k.gouws.org/install-debian-server
    chmod u+x install-debian-server
    ./install-debian-server
```

### Debian
```bash
    curl -LOJ https://k.gouws.org/install-debian
    chmod u+x install-debian
    ./install-debian
```

### Neovim
```bash
    curl -L https://k.gouws.org/install-neovim | bash
```

# SSH Auth using Yubikey
```
eval $(ssh-agent -s)
ssh-add -K
```

# Key Bindings

The notation for `Ctrl` is `<c-x>` and `Alt` is `<m-x>` (Alt means meta, hence the m).  The notation for `Shift` is just a capital
letter. e.g <m-H> is `alt + shift + h`.

 - [i3](docs/i3.md)
