How to monitor a Zimbra Collaboration Environment using pflogsumm and NET-SNMP-EXTEND (PRTG Example)
===================

![alt tag](https://www.jorgedelacruz.es/wp-content/uploads/2017/08/zimbra-prtg-snmp-018.png)

This project uses a modified version of the popular pflogsumm script to retrieve the Zimbra Collaboration email queues information, and creates an output which we retrieve using the NET-SNMP-EXTEND, so we can monitor each sensor as an SNMP OID.

With this project you can monitor the Zimbra mail queues using the SNMP tool you prefer, on this Github README we will show an example using PRTG.

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

### Getting started with the Zimbra Script and SNMP
This dashboard contains multiples sections with the goal to monitor a full Zimbra Collaboration Server, or Servers, we have some sections to monitor the Linux and machine overall performance using SNMP, and one dedicated section just to monitor Zimbra Collaboration.

Download the zimbra_pflogsumm-prtg.pl Script from this repository and save it on the next path: 
```
/opt/zimbra/common/bin/zimbra_pflogsumm-prtg.pl
chmod +x /opt/zimbra/common/bin/zimbra_pflogsumm-prtg.pl
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

### SNMP Config

Sample /etc/snmp/snmpd.conf with inputs for Zimbra Processes tied to the Script which creates the SNMPD OIDs:

```
extend ZimbraReceived /opt/zimbra/common/bin/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-received
extend ZimbraDelivered /opt/zimbra/common/bin/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-delivered
extend ZimbraForwarded /opt/zimbra/common/bin/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-forwarded
extend ZimbraDeferred /opt/zimbra/common/bin/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-deferred
extend ZimbraBounced /opt/zimbra/common/bin/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-bounced
extend ZimbraRejected /opt/zimbra/common/bin/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-rejected
extend ZimbraRejectWarning /opt/zimbra/common/bin/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-reject-warning
extend ZimbraHeld /opt/zimbra/common/bin/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-held
extend ZimbraDiscarded /opt/zimbra/common/bin/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-discarded
extend ZimbraBytesReceived /opt/zimbra/common/bin/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-bytes-received
extend ZimbraBytesDelivered /opt/zimbra/common/bin/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-bytes-delivered
extend ZimbraSenders /opt/zimbra/common/bin/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-senders
extend ZimbraSendingDomains /opt/zimbra/common/bin/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-sending-domains
extend ZimbraRecipients /opt/zimbra/common/bin/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-recipients
extend ZimbraRecipientDomains /opt/zimbra/common/bin/zimbra_pflogsumm-prtg.pl -d today /var/log/zimbra.log -zimbra-recipient-domains
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

After monitor all values, CPU, RAM, Disk, and the Zimbra queues, you might want to create a PRTG map like this one:

![alt tag](https://www.jorgedelacruz.es/wp-content/uploads/2017/08/zimbra-prtg-snmp-018.png)

----------

### Coming next
This is just a v0.1 of this Dashboard, the next step will be to use the Zimbra SOAP API to obtain some extra information from the Zimbra Collaboration Environment, like:
* Number of Active Users
* Number of Inactive Users
* Number of Domains
* Number of Users with ActiveSync
* etc.

In next versions we will parse directly the logs and put the attempts of logins, and successful logins on a map.