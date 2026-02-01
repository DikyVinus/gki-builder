#!/usr/bin/env bash

# Define target defconfig location
DEFCONFIG="arch/arm64/configs/gki_defconfig"

echo "⚙️ Menambahkan konfigurasi KSU & SuSFS"

# Base KSU Config & Dependencies
cat >> $DEFCONFIG <<EOF
# ===============================================
# Konfigurasi KernelSU Base
CONFIG_KSU=y
CONFIG_KPM=y
# Kprobes is a hard dependency for KSU-Next
CONFIG_KPROBES=y
CONFIG_KPROBE_EVENTS=y
EOF

# Hook method selection logic based on KSU env
if [ "$KSU" == "SukiSU" ]; then
    # SUKISU SPECIAL HANDLING
    if [ "$KSU_SUSFS" = "true" ]; then
        echo "🔧 Mode: SukiSU + SuSFS Enabled"
        cat >> $DEFCONFIG <<EOF
# --- SuSFS Configuration for SukiSU ---
CONFIG_KSU_SUSFS=y
# Biarkan SukiSU mengatur detail hook & mount secara internal
EOF
    else
        echo "🔧 Mode: SukiSU Standard (No SuSFS)"
    fi

elif [ "$KSU_SUSFS" = "true" ]; then
  # LOGIC STANDARD FOR KSU NEXT, REGULAR, RISSU, RKSU
  echo "🔧 Mode: SuSFS Hook Enabled"
  cat >> $DEFCONFIG <<EOF
# --- SuSFS Configuration ---
    CONFIG_KSU_SUSFS=y
    CONFIG_KSU_SUSFS_HAS_MAGIC_MOUNT=y
    CONFIG_KSU_SUSFS_SUS_PATH=y
    CONFIG_KSU_SUSFS_SUS_MOUNT=y
    CONFIG_KSU_SUSFS_SUS_KSTAT_SPOOF_GENERIC=y
    CONFIG_KSU_SUSFS_SUS_KSTAT=y
    CONFIG_KSU_SUSFS_AUTO_ADD_SUS_KSU_DEFAULT_MOUNT=y
    CONFIG_KSU_SUSFS_AUTO_ADD_SUS_BIND_MOUNT=y
    CONFIG_KSU_SUSFS_AUTO_ADD_SUS_KSTAT=y
    CONFIG_KSU_SUSFS_SUS_OVERLAYFS=n
    CONFIG_KSU_SUSFS_TRY_UMOUNT=n
    CONFIG_KSU_SUSFS_AUTO_ADD_TRY_UMOUNT_FOR_BIND_MOUNT=n
    CONFIG_KSU_SUSFS_SPOOF_UNAME=y
    CONFIG_KSU_SUSFS_ENABLE_LOG=y
    CONFIG_KSU_SUSFS_HIDE_KSU_SUSFS_SYMBOLS=y
    CONFIG_KSU_SUSFS_SPOOF_CMDLINE_OR_BOOTCONFIG=y
    CONFIG_KSU_SUSFS_OPEN_REDIRECT=y
    CONFIG_KSU_MANUAL_HOOK=n
    CONFIG_KSU_HAS_MANUAL_HOOK=n
EOF

else
  # Standard Logic Without Susfs kprobes mode
  echo "🔧 Mode: Kprobes Hook Standard"
  cat >> $DEFCONFIG <<EOF
# --- Kprobes Hook Method ---
# Disable SuSFS and Manual Hook
    CONFIG_KSU_SUSFS=n
    CONFIG_KSU_SUSFS_SUS_SU=n
    CONFIG_KSU_MANUAL_HOOK=n
    CONFIG_KSU_HAS_MANUAL_HOOK=n
    CONFIG_KSU_SUSFS_HIDE_KSU_SUSFS_SYMBOLS=n
    CONFIG_KSU_SYSCALL_HOOK=n
EOF
fi

# --- Tambahan Universal Performance Tuning ---
echo "⚙️ Menambahkan Universal Performance Tuning"
cat >> $DEFCONFIG <<EOF
# --- Universal Performance Tuning ---
CONFIG_HZ=500
CONFIG_HZ_500=y
CONFIG_CPU_FREQ=y
CONFIG_HIGH_RES_TIMERS=y
# Optimasi addition
CONFIG_PSI=y
CONFIG_PSI_DEFAULT_DISABLED=n
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL=y
CONFIG_UCLAMP_TASK_GROUP=y
# config optimization
CONFIG_NO_HZ=n
CONFIG_SCHED_TUNE=y
EOF

# --- Tambahan LTO & Compiler Optimization ---
echo "⚙️ Menambahkan LTO & Compiler Optimization"
cat >> $DEFCONFIG <<EOF
# --- LTO & Compiler Optimization ---
CONFIG_LTO=y
CONFIG_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_HAS_LTO_CLANG=y
# CONFIG_LTO_NONE is not set
# CONFIG_LTO_CLANG_FULL is not set
CONFIG_LTO_CLANG_THIN=y
EOF
