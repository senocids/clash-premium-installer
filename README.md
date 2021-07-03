# Clash Premiun Installer

Simple clash premiun core installer with full tun support for Linux.

### Note for this fork

This fork will not be maintained any more.
Please notice that for a fresh raspbian, 
uncomment the following lines in file: `scripts/setup-tun.sh`.
```sh
# sysctl -w net/ipv4/ip_forward=1
# sysctl -w net/ipv6/conf/all/forwarding=1 
```

Please ensure following lines in your clash config file:
```yaml
tun:
  enable: true
  stack: gvisor # or system
  device-url: dev://utun
  dns-hijack:
    - 1.0.0.1:53
```

Please notice that `$ sudo ./installer.sh uninstall` 
will remove the config file, `/home/pi/.config/clash/config.yaml`

### Usage

1. Install dependencies **git**, **nftables**, **iproute2**

2. Clone repository

   ```sh
   $ git clone https://github.com/Kr328/clash-premium-installer
   $ cd clash-premium-installer
   ```

3. Download clash core [link](https://github.com/Dreamacro/clash/releases/tag/premium)

4. Extract core and rename it to `./clash`
   - [optional] rename config file to `./config.yaml` 

5. Run Installer

   ```sh
   $ sudo ./installer.sh install
   ```
