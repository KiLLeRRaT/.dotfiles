To create and run the container:
# Linux or MacOS
```
sudo docker run -d --name nvim-docker -v /mnt/c/Projects.Git:/mnt/c/Projects.Git killerrat/nvim-docker:latest
```
# Windows
```
docker run -d --name nvim-docker -v C:\Projects.Git:/mnt/c/Projects.Git killerrat/nvim-docker:latest
```


# To get into the container
```
docker exec -it nvim-docker /bin/zsh
```
Then start tmux, with unicode otherwise characters display funny:
```
tmux
```

This image also comes with [upterm](https://github.com/owenthereal/upterm), which lets you host a shared SSH session without having to open special firewall ports and such:
```
upterm host zsh
```
Or forcing a tmux session:
```
upterm host --force-command 'tmuxu attach -t pair-programming' -- tmux new -t pair-programming
```

# Nuget Package Source
```
dotnet nuget add source https://pkgs.dev.azure.com/sandfield/_packaging/Sandfield.Nuget/nuget/v3/index.json --name Sandfield.Nuget
```

To install a package (basically to authenticate):
```
dotnet add package Sandfield.Data.Dynamic --interactive
```
