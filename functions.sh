#!/usr/bin/env bash

log() {
  echo "[LOG] $*"
}

error() {
  echo "[ERROR] $*"
  return 0
}

_error() {
  echo "[ERROR] $*"
  return 0
}

upload_file() {
  return 0
}

send_msg() {
  return 0
}

simplify_gh_url() {
  echo "$1"
}

ksu_included() {
  [ "$KSU" = "yes" ]
}

susfs_included() {
  [ "$KSU_SUSFS" = "true" ]
}
