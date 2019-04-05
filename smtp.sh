# The place where the mail goes. The actual machine name is required
# no MX records are consulted. Commonly mailhosts are named mail.domain.com
mailhub=smtp.gmail.com:587

# Example for SMTP port number 2525
# mailhub=mail.your.domain:2525
# Example for SMTP port number 25 (Standard/RFC)
# mailhub=mail.your.domain        
# Example for SSL encrypted connection
# mailhub=mail.your.domain:465

# Where will the mail seem to come from?
# rewriteDomain=[a different domain here, if needed ]

# The full hostname, should auto-detect
#hostname=manojown1@gmail.com

# Set this to never rewrite the "From:" line (unless not given) and to
# use that address in the "from line" of the envelope.
# Enable if you trust your users (ha!)
# FromLineOverride=YES
FromLineOverride=YES

UseSTARTTLS=YES
AuthMethod=LOGIN
# If you have to login set these:
AuthUser=alerts@quarkstudios.com
AuthPass=6ccphcsHn6QMLpJw

# Use SSL/TLS to send secure messages to server.
UseTLS=YES
EOF

echo "$ssmptSetting" > /etc/ssmtp/ssmtp.conf


read -d '' revaliases <<"EOF"
# sSMTP aliases
# 
# Format:       local_account:outgoing_address:mailhub
#
# Example: root:your_login@your.domain:mailhub.your.domain[:port]
root:alerts@quarkstudios.com:smtp.gmail.com:587
# where [:port] is an optional port number that defaults to 25
EOF

echo "$revaliases" > /etc/ssmtp/revaliases
cd /etc/ssmtp/
rm sendMail.sh
wget https://raw.githubusercontent.com/manojown/utility-scripts/master/sendMail.sh
sed -i "s/<TOMAIL>/${toEmail}/g" sendMail.sh
sed -i "s/<FROMMAIL>/${fromEmail}/g" sendMail.sh
sed -i "s/<NAME>/${NAME}/g" sendMail.sh
sed -i "s/<LIMIT>/${LIMIT}/g" sendMail.sh
chmod +x sendMail.sh
read -d '' cronJob <<"EOF"
1 */12 * * *  root /etc/ssmtp/sendMail.sh
EOF
echo "$cronJob" > /etc/cron.d/sendmail
