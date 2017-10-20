How to monitor a Zimbra Collaboration Environment using pflogsumm and NET-SNMP-EXTEND (PRTG Example)
===================

![alt tag](https://www.jorgedelacruz.es/wp-content/uploads/2017/08/zimbra-prtg-snmp-018.png)

*Note: This project is a Community contribution, not tested neither supported officialy by Zimbra. Use it at your own risk. It might perform poorly in big environments due the need to parse the MTA logs over and over.

On this project, and to monitor the Zimbra queues, I've used a modified version of the popular pflogsumm script to retrieve the Zimbra Collaboration email queues information, and creates an output which we retrieve using the NET-SNMP-EXTEND, so we can monitor each sensor as an SNMP OID.

With this project you can monitor the Zimbra mail queues, Zimbra version, Zimbra service status and Zimbra License using the SNMP tool you prefer, on this Github README we will show an example using PRTG.

----------

### Before start
This monitoring method will need to have SNMP installed and running on the zimbra Server, the first step is to install all the needed components:
```
sudo apt-get install snmpd snmp snmp-mibs-downloader
```

Then replace this line on the file called /etc/default/snmpd :
```
# snmpd options (use syslog, close stdin/out/err).
SNMPDOPTS='-Lsd -Lf /dev/null -u snmp -g snmp -I -smux,mteTrigger,mteTriggerConf -p /var/run/snmpd.pid'
```

For this one:
```
# snmpd options (use syslog, close stdin/out/err).
SNMPDOPTS='-Lsd -Lf /dev/null -u snmp -g snmp -I -smux,mteTrigger,mteTriggerConf -p /var/run/snmpd.pid'
```

Download the snmd.conf file from this repository and save it here /etc/snmp/snmpd.conf edit the community and main point of contact.

And restart the SNMP service:
```
sudo /etc/init.d/snmpd restart
```

You can check that everything is up and running by running the next command:
```
netstat -apn|grep snmpd
udp        0      0 0.0.0.0:161             0.0.0.0:*                           13544/snmpd
```

And if you want a detailed list, run the next command:
```
snmpwalk -v 1 -c public -O e localhost
```

### Zimbra Mail Queues
This project contains multiples sections with the goal to monitor a full Zimbra Collaboration Server, or Servers. Let's start with the Zimbra Mail queues. As this script queries the Zimbra logs, the performance can be an issue on big Environments, so please be aware of it.

Download the zimbra_pflogsumm-prtg.pl Script from this repository and save it on the next path: 
```
mkdir /etc/snmp/scripts
/etc/snmp/scripts/zimbra_pflogsumm-prtg.pl
chmod +x /etc/snmp/scripts/zimbra_pflogsumm-prtg.pl
```
This Script monitors:
Zimbra Collaboration Performance
* Received Megabytes
* Delivered Megabytes
* Total Emails/received
* Total Emails/Delivered
* Total Recipients
* Total Senders
* Forwarded
* Deferred
* Bounced
* Rejected
* Held
* Discarded
* Domains Receiving Emails
* Domains Sending Emails

### Zimbra Service Status, Version and License
We can continue with the Zimbra service monitoring, plus the version and licensing, for this we will need some extra scripts to obtain and retrieve the information.

Download the checkzimbraversion.sh, zimbraservices.sh and checkzimbrastatus.sh scripts from this repository and save it on the next path: 
```
mkdir /etc/snmp/scripts
/etc/snmp/scripts/checkzimbrastatus.sh
/etc/snmp/scripts/checkzimbraversion.sh
/etc/snmp/scripts/zimbraservices.sh
chmod +x /etc/snmp/scripts/checkzimbrastatus.sh && chmod +x /etc/snmp/scripts/checkzimbrastatus.sh && chmod +x /etc/snmp/scripts/zimbraservices.sh
```
Add the /etc/snmp/scripts/zimbraservices.sh to your cron, with the frequency you want to monitor your Zimbra services, in my case every 5 minutes. This is going to generate a temporary file on /tmp/tmpservices.out with the status of the services:
```
crontab -e
*/5 * * * * /bin/sh /etc/snmp/scripts/zimbraservices.sh
```
These Scripts combine allow us to monitor from our Zimbra Collaboration:
* Zimbra Version
* Amavis Status
* Antispam Status
* Antivirus Status
* Convertd Status
* LDAP Status
* Logger Status
* Mailboxd Status
* Memcache Status
* MTA Status
* OpenDKIM Status
* Proxy Status
* Service Web App Status
* SNMP Status
* Spell Status
* Stats Status
* Zimbra Web App Status
* Zimbra Web Admin Web App Status
* Zimbra Configd Status
* Zimbra License Status
* Zimbra License valid until Status

### SNMP Config

Sample /etc/snmp/snmpd.conf with inputs for Zimbra Queues, Processes, Version, etc. Please do use only the ones you really need. This ties to the Script which creates the SNMPD OIDs:

```
# Zimbra Mail Queues
extend ZimbraReceived /etc/snmp/scripts/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-received
extend ZimbraDelivered /etc/snmp/scripts/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-delivered
extend ZimbraForwarded /etc/snmp/scripts/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-forwarded
extend ZimbraDeferred /etc/snmp/scripts/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-deferred
extend ZimbraBounced /etc/snmp/scripts/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-bounced
extend ZimbraRejected /etc/snmp/scripts/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-rejected
extend ZimbraRejectWarning /etc/snmp/scripts/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-reject-warning
extend ZimbraHeld /etc/snmp/scripts/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-held
extend ZimbraDiscarded /etc/snmp/scripts/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-discarded
extend ZimbraBytesReceived /etc/snmp/scripts/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-bytes-received
extend ZimbraBytesDelivered /etc/snmp/scripts/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-bytes-delivered
extend ZimbraSenders /etc/snmp/scripts/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-senders
extend ZimbraSendingDomains /etc/snmp/scripts/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-sending-domains
extend ZimbraRecipients /etc/snmp/scripts/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-recipients
extend ZimbraRecipientDomains /etc/snmp/scripts/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-recipient-domains
# Zimbra Service status, License and version
extend ZimbraVersion /etc/snmp/scripts/checkzimbraversion.sh
extend ZimbraStatusAmavis /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusAmavis
extend ZimbraStatusAntispam /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusAntispam
extend ZimbraStatusAntivirus /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusAntivirus
extend ZimbraStatusConvertd /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusConvertd
extend ZimbraStatusLDAP /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusLDAP
extend ZimbraStatusLogger /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusLogger
extend ZimbraStatusMailboxd /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusMailboxd
extend ZimbraStatusMemcache /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusMemcache
extend ZimbraStatusMTA /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusMTA
extend ZimbraStatusOpendkim /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusOpendkim
extend ZimbraStatusProxy /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusProxy
extend ZimbraStatusServicewebapp /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusServicewebapp
extend ZimbraStatusSNMP /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusSNMP
extend ZimbraStatusSpell /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusSpell
extend ZimbraStatusStats /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusStats
extend ZimbraStatusZimbrawebapp /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusZimbrawebapp
extend ZimbraStatusZimbraadminwebapp /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusZimbraadminwebapp
extend ZimbraStatusConfigd /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusConfigd
extend ZimbraStatusLicense /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusLicense
extend ZimbraStatusLicensevalid /etc/snmp/scripts/checkzimbrastatus.sh ZimbraStatusLicensevalid
```

Once this is done, restart the SNMP service and run a test to see if the SNMP has already the details of the Script:

```
snmpwalk -c public -v2c 127.0.0.1 NET-SNMP-EXTEND-MIB::nsExtendOutLine
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraHeld".1 = STRING: 0
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraBounced".1 = STRING: 0
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraSenders".1 = STRING: 1
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraDeferred".1 = STRING: 2
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraReceived".1 = STRING: 1
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraRejected".1 = STRING: 0
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraDelivered".1 = STRING: 3
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraDiscarded".1 = STRING: 0
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraForwarded".1 = STRING: 0
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraRecipients".1 = STRING: 1
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraBytesReceived".1 = STRING: 570
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraRejectWarning".1 = STRING: 0
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraBytesDelivered".1 = STRING: 3827
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraSendingDomains".1 = STRING: 1
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraRecipientDomains".1 = STRING: 1
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraVersion".1 = STRING: 8.7.11 GA
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusMTA".1 = STRING: Running
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusLDAP".1 = STRING: Running
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusSNMP".1 = STRING: Running
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusProxy".1 = STRING: Running
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusSpell".1 = STRING: Running
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusStats".1 = STRING: Running
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusAmavis".1 = STRING: Running
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusLogger".1 = STRING: Running
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusConfigd".1 = STRING: Running
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusLicense".1 = STRING: license is OK
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusAntispam".1 = STRING: Running
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusConvertd".1 = STRING: Running
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusMailboxd".1 = STRING: Running
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusMemcache".1 = STRING: Running
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusOpendkim".1 = STRING: Running
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusAntivirus".1 = STRING: Running
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusLicensevalid".1 = STRING: 20211231170000Z
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusZimbrawebapp".1 = STRING: Running
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusServicewebapp".1 = STRING: Running
NET-SNMP-EXTEND-MIB::nsExtendOutLine."ZimbraStatusZimbraadminwebapp".1 = STRING: Running
```

You might want to translate this NET-SNMP-EXTEND into OIDs, examplefor ZimbraReceived below, you will need to do the same for every field:

```
snmpwalk -On -v2c -c public 127.0.0.1 NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"ZimbraReceived\"
.1.3.6.1.4.1.8072.1.3.2.3.1.2.14.90.105.109.98.114.97.82.101.99.101.105.118.101.100 = STRING: 3
```

Now we know the OID of every value, we can move to our preferred SNMP Tool and start monitoring it by using the OID.

----------

### PRTG Example
To monitor multiple OID results using PRTG Network Monitor, we will use the SNMP Custom Advanced Sensor which you can find on the next image:

![alt tag](https://www.jorgedelacruz.es/wp-content/uploads/2017/08/zimbra-prtg-snmp-011.png)

On this example, we will monitor delivered, received, rejected, deferred, bounced, held, discarded and forwarded on one unique graph :
![alt tag](https://www.jorgedelacruz.es/wp-content/uploads/2017/08/zimbra-prtg-snmp-012.png)

Here we can see all the Services, License and version monitored properly by PRTG:
![alt tag](https://www.jorgedelacruz.es/wp-content/uploads/2017/10/zimbra-prtg-services-003.png)

After monitor all values, CPU, RAM, Disk, and the Zimbra queues, you might want to create a PRTG map like this one:

![alt tag](https://www.jorgedelacruz.es/wp-content/uploads/2017/08/zimbra-prtg-snmp-018.png)

----------

### Coming next
This is just a v0.1 of this SNMP Library, the next step will be to use the Zimbra SOAP API to obtain some extra information from the Zimbra Collaboration Environment, like:
* Number of Active Users
* Number of Inactive Users
* Number of Domains
* Number of Users with ActiveSync
* etc.

In next versions we will parse directly the logs and put the attempts of logins, and successful logins on a map.

## Distributed under MIT license
Copyright (c) 2017 Jorge de la Cruz

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.