#!/bin/sh

# Create a stripped-down defconfig based on the running system. The idea is
# that the defconfig should only contain the system configuration options like
# preempt, hz, etc. Modules and more niche settings are provided in other
# config files.

# Start with a config based on the running system with a few tweaks.
zgrep -v -E 'CONFIG_(DEFAULT_HOSTNAME|LOCALVERSION)=' /proc/config.gz > .config
cat << EOF >> .config
CONFIG_LOCALVERSION_AUTO=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HYPERVISOR_GUEST=n
CONFIG_MODVERSIONS=n
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_KPROBES=y
CONFIG_UPROBES=y
CONFIG_KPROBE_EVENTS=y
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_KPROBE_OVERRIDE=y
CONFIG_NVM=n
CONFIG_NVME_CORE=n
CONFIG_BLK_DEV_NVME=n
EOF
make olddefconfig

# Disable all modules. If any are built in in the original config, they won't
# be disabled, but Arch doesn't do that for many modules.
lsmod | head -1 > lsmod
make LSMOD=lsmod localmodconfig
make savedefconfig
rm -f lsmod
