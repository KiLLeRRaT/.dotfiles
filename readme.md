# .dotfiles

This is my .dotfiles.  It's as multi platform as I could make it, up to a point.  You will find
dotfiles for Linux, MacOS, and Windows in here.

# Installation

## Linux
### Arch
Installing arch using archinstall:
```bash
archinstall --config https://u.gouws.org/archinstall
```

Then say no to entering `chroot`, reboot, and run the following:

```bash
    curl -LOJ https://u.gouws.org/install-arch.sh
    chmod u+x install-arch.sh
    ./install-arch.sh
```

### Debian Server
```bash
    curl -LOJ https://u.gouws.org/install-debian-server.sh
    chmod u+x install-arch.sh
    ./install-arch.sh
```

### Debian
```bash
    curl -LOJ https://u.gouws.org/install-debian.sh
    chmod u+x install-arch.sh
    ./install-arch.sh
```

# Key Bindings

The notation for `Ctrl` is `<c-x>` and `Alt` is `<m-x>` (Alt means meta, hence the m).  The notation for `Shift` is just a capital
letter. e.g <m-H> is `alt + shift + h`.

 - [i3](docs/i3.md)
