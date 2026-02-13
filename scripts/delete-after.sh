#!/usr/bin/env bash
set -e

usage() {
  echo "Usage: $0 <command> [args]"
  echo ""
  echo "Commands:"
  echo "  add <file>   Mark a file/directory for deletion (90 days)"
  echo "  list         List all files marked for deletion"
  echo "  rm <file>    Remove a marked file and its symlink"
  exit 1
}

cmd_add() {
  local source="$1"

  if [ -z "$source" ]; then
    echo "Usage: $0 add <file>"
    exit 1
  fi

  if [ ! -e "$source" ]; then
    echo "Error: File or directory '$source' does not exist."
    exit 1
  fi

  # Rename file by suffixing with .delete-after-yyyy-mm-dd with a date 90 days in the future
  delete_after_date=$(date -d "+90 days" +"%Y-%m-%d")
  destination="${source}.delete-after-${delete_after_date}"
  mv -v "$source" "$destination"

  full_path=$(realpath "$destination")

  # Create a symlink in ~/DELETEAFTER pointing to the file
  ln -s "$full_path" "$HOME/DELETEAFTER/$(basename "$destination")"
}

cmd_list() {
  ls -l "$HOME/DELETEAFTER/"
}

cmd_rm() {
  local target="$1"

  if [ -z "$target" ]; then
    echo "Usage: $0 rm <file>"
    exit 1
  fi

  # Check if the delete-after date is still in the future
  local delete_date
  delete_date=$(basename "$target" | grep -oP '\d{4}-\d{2}-\d{2}$')
  if [ -n "$delete_date" ]; then
    local today
    today=$(date +"%Y-%m-%d")
    if [[ "$today" < "$delete_date" ]]; then
      read -rp "File is not scheduled for deletion until $delete_date. Delete anyway? [y/N] " answer
      if [[ ! "$answer" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
      fi
    fi
  fi

  local actual_file symlink

  if [ -L "$target" ]; then
    # Target is a symlink (e.g. from ~/DELETEAFTER/) — resolve to actual file
    symlink="$target"
    actual_file="$(readlink -f "$target")"
  else
    # Target is the actual file — find its symlink in ~/DELETEAFTER/
    actual_file="$(realpath "$target")"
    symlink=""
    for link in "$HOME/DELETEAFTER/"*; do
      if [ -L "$link" ] && [ "$(readlink -f "$link")" = "$actual_file" ]; then
        symlink="$link"
        break
      fi
    done
  fi

  if [ -e "$actual_file" ]; then
    rm -v "$actual_file"
  else
    echo "Warning: actual file '$actual_file' not found."
  fi

  if [ -n "$symlink" ] && [ -L "$symlink" ]; then
    rm -v "$symlink"
  elif [ -n "$symlink" ]; then
    echo "Warning: symlink '$symlink' not found."
  fi
}

if [ $# -eq 0 ]; then
  usage
fi

command="$1"
shift

case "$command" in
  add)  cmd_add "$@" ;;
  list) cmd_list ;;
  rm)   cmd_rm "$@" ;;
  *)    echo "Unknown command: $command"; usage ;;
esac
