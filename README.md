```
           ______   ______  _     ___   ____
 _ __ ___ / ___\ \ / / ___|| |   / _ \ / ___|
| '_ ` _ \\___ \\ V /\___ \| |  | | | | |  _
| | | | | |___) || |  ___) | |__| |_| | |_| |
|_| |_| |_|____/ |_| |____/|_____\___/ \____|
```

 A simple centralized logging solution almost only with bash and gnu-tools.

[![bash-lint](https://github.com/quotengrote/mSYSLOG/actions/workflows/bash_lint.yml/badge.svg?branch=master)](https://github.com/quotengrote/mSYSLOG/actions/workflows/bash_lint.yml)
[![shieldio-issues](https://img.shields.io/github/issues/quotengrote/msyslog)](https://github.com/quotengrote/mSYSLOG/issues)
[![shieldio-pr](https://img.shields.io/github/issues-pr/quotengrote/msyslog)](https://github.com/quotengrote/mSYSLOG/pulls)
[![shieldio-license](https://img.shields.io/github/license/quotengrote/msyslog)](./LICENSE)
![shieldio-lastcommit](https://img.shields.io/github/last-commit/quotengrote/msyslog)
[![build packages](https://github.com/quotengrote/mSYSLOG/actions/workflows/build-deb.yml/badge.svg?branch=master)](https://github.com/quotengrote/mSYSLOG/actions/workflows/build-deb.yml)

## Table of contents
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
  - [Table of contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Getting started](#getting-started)
    - [install msyslog-client](#install-msyslog-client)
    - [remove msyslog-client](#remove-msyslog-client)
  - [Usage client](#usage-client)
    - [Example client Configuration](#example-client-configuration)
    - [Troubleshooting](#troubleshooting)
  - [Usage server](#usage-server)
  - [Build](#build)
  - [License](#license)
<!-- TOC END -->



## Introduction
mSYSLOG is a programm that collects logfiles and send it via `netcat` to a server.

## Getting started

### install msyslog-client
1. download deb
2. ``sudo apt install --fix-broken ./msyslog-client*.deb``
3. check if service is running ``systemctl status msyslog-client.service``

### remove msyslog-client
1. ``apt remove --purge msyslog-client``

## Usage client
```
Usage:
  - msyslog-client.sh [OPTIONS]
  - systemctl start|stop|restart|status msyslog-client.service

Options:
    -h, --help                  Displays this text.
    -s, --status                Displays the current status of the script.
```


### Example client Configuration
```
# configfile for msyslog-client

# files whose contents should be sent(comma-separated)
logfiles=/var/log/syslog,/var/log/messages,/var/log/test file,/var/log/secure

# fqdn and port to which the data should get send
log_receiver_fqdn=acng.server
log_receiver_port=12345

```

## Usage server
``ncat -l -k -p 12345``


## Build
The client packages get build with [GitHub Actions](./.github/workflows/build-deb.yml) and dpkg-deb.

## License
This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](./LICENSE) file for details.
