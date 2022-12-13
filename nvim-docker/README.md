To create and run the container:
```
docker run -d --name nvim-docker -v /mnt/c/Projects.Git:/mnt/c/Projects.Git killerrat/nvim-docker:latest
```

To get into the container:
```
docker exec -it nvim-docker /bin/zsh
```

Then start tmux, with unicode otherwise characters display funny:
```
tmux -u
```

This image also comes with [upterm](https://github.com/owenthereal/upterm), which lets you host a shared SSH session without having to open special firewall ports and such:
```
upterm host zsh
```
Or forcing a tmux session:
```
upterm host --force-command 'tmux -u attach -t pair-programming' -- tmux new -t pair-programming
```

