#!/bin/bash
REMAINING=$(df -h | grep "/var/lib/docker/overlay2/*"  | head -1 | awk '{print $4}' | rev | cut -c 2- | rev)
USED=$(df -h | grep "/var/lib/docker/overlay2/*"  | head -1 | awk '{print $3}')
echo  ${REMAINING}
LIMIT=<LIMIT>
SERVER=$(hostname -I | awk '{print $1}')
if [[ $REMAINING -gt $LIMIT ]]
then
 echo "Enough sapce we have dont worry"
else
       read -d '' environment <<"EOF"
To:<TOMAIL>
From:<FROMMAIL>
Subject:[CRITICAL] Alert <NAME> storage space. 

Critical Alert <NAME> ( <SERVER> ). The storage space remaining is less than <REMAINING> .
Quick Look
-------------------
Used - <USED>
Remaining - <REMAINING>


EOF

 cd /etc/ssmtp/
 rm mail.txt
 touch mail.txt
 echo "$environment" > ./mail.txt
 sed -i "s/<REMAINING>/${REMAINING}GB/g" mail.txt
 sed -i "s/<USED>/${USED}/g" mail.txt
 sed -i "s/<SERVER>/${SERVER}/g" mail.txt
 df -h >> mail.txt 
 /usr/sbin/sendmail -t < mail.txt
fi
