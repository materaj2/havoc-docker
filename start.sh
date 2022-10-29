#!/bin/bash

cd /opt/Havoc/Teamserver && ./teamserver server --profile ./profiles/havoc.yaotl -v --debug

tail -F /dev/null
