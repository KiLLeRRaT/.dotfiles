#!/bin/bash

completeCt()
{
    # Return early when the first argument (the name of the command) matches the
    # last argument (the word preceding the one being completed). This is the
    # case for the first argument to the command. Returning an empty result will
    # trigger readline's default completion.
    if [[ "$1" == "${@: -1}" ]]; then
        return
    fi

    # For arguments after the first, find the working directories of all bash
    # processes and filter them by the word currently being completed.
    COMPREPLY=($( \
        ps au \
        | awk '$11 == "-bash" || $11 == "/bin/bash" { print $2 }' \
        | xargs pwdx \
        | awk '{ print $2 }' \
        | sed -n "\|^${2}.*|p" \
        | sort \
        | uniq ))
}

alias ct='cp'
# complete -o default -F completeCt ct
complete -o filenames -o dirnames -F completeCt ct

