#!/bin/bash

cd "`dirname $0`"

function assert() {
    "$@"

    if [ "$?" != 0 ]; then
    echo "Execute $@ failure"
    exit 1
    fi
}

function assert_command() {
    if ! which "$1" > /dev/null 2>&1;then
    echo "Command $1 not found"
    exit 1
    fi
}

function _install() {
    assert_command install
    assert_command nft
    assert_command ip

    if [ ! -d "/lib/udev/rules.d" ];then
    echo "udev not found"
    exit 1
    fi

    if [ ! -d "/usr/lib/systemd/system" ];then
    echo "systemd not found"
    exit 1
    fi

    if ! grep net_cls "/proc/cgroups" 2> /dev/null > /dev/null ;then
    echo "cgroup not support net_cls"
    exit 1
    fi

    if [ ! -f "./clash" ];then
    echo "Clash core not found."
    echo "Please download it from https://github.com/Dreamacro/clash/releases/tag/premium, and rename to ./clash"
    fi
    
    assert install -d -m 0755 /etc/default/
    assert install -d -m 0755 /usr/lib/clash/

    assert install -m 0644 scripts/clash-default /etc/default/clash
    . /etc/default/clash

    assert install -d -m 0755 $HOMEPATH/.config/clash/
    assert install -m 0755 ./clash $HOMEPATH/bin/clash
    assert install -m 0600 ./config.yaml $HOMEPATH/.config/clash/config.yaml
    


    assert install -m 0755 scripts/bypass-proxy-pid /usr/bin/bypass-proxy-pid
    assert install -m 0755 scripts/bypass-proxy /usr/bin/bypass-proxy

    assert install -m 0700 scripts/clean-tun.sh /usr/lib/clash/clean-tun.sh
    assert install -m 0700 scripts/setup-tun.sh /usr/lib/clash/setup-tun.sh
    assert install -m 0700 scripts/setup-cgroup.sh /usr/lib/clash/setup-cgroup.sh

    assert install -m 0644 scripts/clash.service /usr/lib/systemd/system/clash.service
    assert install -m 0644 scripts/99-clash.rules /lib/udev/rules.d/99-clash.rules
    
    systemctl daemon-reload

    echo "Install successfully"
    echo ""
    echo "Home directory at $HOMEPATH/.config/clash"
    echo ""
    echo "All dns traffic will be redirected to $FORWARD_DNS_REDIRECT"
    echo "*PLEASE* use clash core's 'tun.dns-hijack' to handle it"
    echo ""
    echo "Use '$ sudo systemctl start clash' to start"
    echo "Use '$ sudo systemctl enable clash' to enable auto-restart on boot"

    exit 0
}

function _uninstall() {
    assert_command systemctl
    assert_command rm

    systemctl stop clash
    systemctl disable clash

    rm -rf /usr/lib/clash/
    rm -rf $HOMEPATH/.config/clash/config.yaml
    rm -rf /usr/lib/systemd/system/clash.service
    rm -rf /lib/udev/rules.d/99-clash.rules
    rm -rf $HOMEPATH/bin/clash
    rm -rf /usr/bin/bypass-proxy-pid
    rm -rf /usr/bin/bypass-proxy
    rm -rf /etc/default/clash

    echo "Uninstall successfully"

    exit 0
}

function _help() {
    echo "Clash Premiun Installer"
    echo ""
    echo "Usage: ./installer.sh [option]"
    echo ""
    echo "Options:"
    echo "  install      - install clash premiun core"
    echo "  uninstall    - uninstall installed clash premiun core"
    echo ""

    exit 0
}

case "$1" in
"install") _install;;
"uninstall") _uninstall;;
*) _help;
esac
