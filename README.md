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
[![shieldio-license](https://img.shields.io/badge/license-MIT-brightgreen)](./LICENSE)
![shieldio-lastcommit](https://img.shields.io/github/last-commit/quotengrote/msyslog)


## Table of contents

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
2. install it
3. install server (docker-compose)
### setup manual
xxxx

## Usage
```
Usage: msyslog-client.sh [OPTIONS]

  Manage the msyslog-client.

Options:
  -h, --help                  Displays this text.
  -s, --status                Display the current status of the script.
  stop                        Stops the script and all of its child-processes.
  restart                     Restarts the script and all of its child-processes.
  start, without a option     Starts the script and all of its child-processes.


```
