#!/bin/bash -eux

OS_USER="$SUDO_USER"
CRONTAB_ENTRY="*/5 * * * * /home/ubuntu/aws-scripts-mon/mon-put-instance-data.pl --mem-util --disk-space-util --disk-path=/ --from-cron --aws-credential-file=/home/ubuntu/aws-scripts-mon/awscreds.conf --disk-path=/var/lib/mysql"

apt-get install -q -y unzip libwww-perl libcrypt-ssleay-perl libswitch-perl
su - ubuntu <<EOF
wget http://ec2-downloads.s3.amazonaws.com/cloudwatch-samples/CloudWatchMonitoringScripts-v1.1.0.zip'
unzip -o CloudWatchMonitoringScripts-v1.1.0.zip
rm CloudWatchMonitoringScripts-v1.1.0.zip
cd ~/aws-scripts-mon
echo '%s' | crontab -
EOF

