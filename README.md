```
           ______   ______  _     ___   ____
 _ __ ___ / ___\ \ / / ___|| |   / _ \ / ___|
| '_ ` _ \\___ \\ V /\___ \| |  | | | | |  _
| | | | | |___) || |  ___) | |__| |_| | |_| |
|_| |_| |_|____/ |_| |____/|_____\___/ \____|
```

 A simple centralized logging solution almost only with bash and gnu-tools.

 [![bash-lint](https://github.com/quotengrote/mSYSLOG/actions/workflows/bash_lint.yml/badge.svg)](https://github.com/quotengrote/mSYSLOG/actions/workflows/bash_lint.yml)
 [![shieldio-issues](https://img.shields.io/github/issues/quotengrote/msyslog)](https://github.com/quotengrote/mSYSLOG/issues)
[![shieldio-pr](https://img.shields.io/github/issues-pr/quotengrote/msyslog)](https://github.com/quotengrote/mSYSLOG/pulls)
[![shieldio-license](https://img.shields.io/github/license/quotengrote/msyslog)](./LICENSE)
![shieldio-lastcommit](https://img.shields.io/github/last-commit/quotengrote/msyslog)
[![build packages](https://github.com/quotengrote/mSYSLOG/actions/workflows/build-deb.yml/badge.svg)](https://github.com/quotengrote/mSYSLOG/actions/workflows/build-deb.yml)

## Table of contents
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
  - [Table of contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Getting started](#getting-started)
    - [Dependencies](#dependencies)
    - [Setup deb](#setup-deb)
    - [setup manual](#setup-manual)
  - [Usage client](#usage-client)
  - [Example client Configuration](#example-client-configuration)
  - [Usage server](#usage-server)
  - [License](#license)
<!-- TOC END -->



## Introduction
mSYSLOG is a programm that collects logfiles and send it via `netcat` to a server.

## Getting started

### Dependencies
#### Server
* ``ncat``

#### Client
* ``netcat-openbsd ``
* ``figlet``
* ``expect``

### Setup deb
1. download deb
2. ``sudo apt install --fix-broken ./msyslog-client*.deb``
3. install server (docker-compose)

### setup manual
clone this repo
copy each to file to ist location
sytemd?
user?

## Usage client
```
Usage: msyslog-client.sh [OPTIONS]

    Manages the msyslog-client.

Options:
    -h, --help                  Displays this text.
    -s, --status                Display the current status of the script.
    stop                        Stops the script and all of its child-processes.
    restart                     Restarts the script and all of its child-processes.
    start, without a option     Starts the script and all of its child-processes.


```

## Example client Configuration
```
# configfile for msyslog-client

# files whose contents should be sent(comma-separated)
logfiles=/var/log/syslog,/var/log/kern.log,/var/log/messages,/var/log/x xx,/var/log/secure

# fqdn and port to which the data should get send
log_receiver_fqdn=acng.grote.lan
log_receiver_port=12345

```

## Usage server
``ncat -l -k  -p 12345``

## License
This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](./LICENSE) file for details.


deinstall in doku
