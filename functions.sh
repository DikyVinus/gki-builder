#!/usr/bin/env bash

log() { echo "[LOG] $*"; }
error() { echo "ERROR: $*" && exit 1; }
upload_file() { :; }
send_msg() { :; }
simplify_gh_url() { echo "$1"; }
ksu_included() { [ "$KSU" = "yes" ]; }
susfs_included() { [ "$KSU_SUSFS" = "true" ]; }
