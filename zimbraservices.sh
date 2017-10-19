#!/bin/bash
exec sudo service zimbra status > /tmp/tmpservices.out &
chown snmp:snmp /tmp/tmpservices.out