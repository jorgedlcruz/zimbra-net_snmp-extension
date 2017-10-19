#!/bin/bash
case $1 in
     ZimbraStatusAmavis)
          more /tmp/tmpservices.out | grep amavis | awk '{print $2}'
          ;;
     ZimbraStatusAntispam)
          more /tmp/tmpservices.out | grep antispam | awk '{print $2}'
          ;;
     ZimbraStatusAntivirus)
          more /tmp/tmpservices.out | grep antivirus | awk '{print $2}'
          ;;
     ZimbraStatusConvertd)
          more /tmp/tmpservices.out | grep convertd | awk '{print $2}'
          ;;
     ZimbraStatusLDAP)
          more /tmp/tmpservices.out | grep ldap | awk '{print $2}'
          ;;
     ZimbraStatusLogger)
          more /tmp/tmpservices.out | grep logger | awk '{print $2}'
          ;;
     ZimbraStatusMailboxd)
          more /tmp/tmpservices.out | grep mailbox | awk '{print $2}'
          ;;
     ZimbraStatusMemcache)
          more /tmp/tmpservices.out | grep memcached | awk '{print $2}'
          ;;
     ZimbraStatusMTA)
           more /tmp/tmpservices.out | grep mta | awk '{print $2}'
          ;;
     ZimbraStatusOpendkim)
          more /tmp/tmpservices.out | grep opendkim | awk '{print $2}'
          ;;
     ZimbraStatusProxy)
          more /tmp/tmpservices.out | grep proxy | awk '{print $2}'
          ;;
     ZimbraStatusServicewebapp)
          more /tmp/tmpservices.out | grep 'service webapp' | awk '{print $3}'
          ;; 
     ZimbraStatusSNMP)
          more /tmp/tmpservices.out | grep snmp | awk '{print $2}'
          ;;
     ZimbraStatusSpell)
          more /tmp/tmpservices.out | grep spell | awk '{print $2}'
          ;;
     ZimbraStatusStats)
          more /tmp/tmpservices.out | grep stats | awk '{print $2}'
          ;;
    ZimbraStatusZimbrawebapp)
          more /tmp/tmpservices.out | grep 'zimbra webapp' | awk '{print $3}'
          ;; 
    ZimbraStatusZimbraadminwebapp)
          more /tmp/tmpservices.out | grep 'zimbraAdmin webapp' | awk '{print $3}'
          ;; 
     ZimbraStatusConfigd)
          more /tmp/tmpservices.out | grep zmconfigd | awk '{print $2}'
          ;;
     ZimbraStatusLicense)
          sudo -u zimbra -H sh -c "/opt/zimbra/bin/zmlicense -check"
          ;;
     ZimbraStatusLicensevalid)
          sudo -u zimbra -H sh -c "/opt/zimbra/bin/zmlicense -print" | grep ValidUntil |  awk -F'=' '{print $2}'
          ;;
esac