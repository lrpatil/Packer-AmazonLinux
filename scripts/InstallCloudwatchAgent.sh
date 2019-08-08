#!/bin/bash
sudo yum install -y perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https perl-Digest-SHA.x86_64 -y
mkdir -p /home/ec2-user/aws-scripts-mon
cd /home/ec2-user/aws-scripts-mon
curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O
sudo unzip CloudWatchMonitoringScripts-1.2.2.zip
sudo rm CloudWatchMonitoringScripts-1.2.2.zip
cd aws-scripts-mon
echo "*/5 * * * * /home/ec2-user/aws-scripts-mon/aws-scripts-mon/mon-put-instance-data.pl --mem-util --mem-used --mem-avail --disk-space-util --disk-path=/ --from-cron" >> /etc/crontab
# To perform a simple test run without posting data to CloudWatch
./mon-put-instance-data.pl --mem-util --verify --verbose 
# To collect all available memory and disk metrics and send them to CloudWatch, counting cache and buffer memory as used
./mon-put-instance-data.pl --mem-used-incl-cache-buff --mem-util --mem-used --mem-avail
./mon-put-instance-data.pl --disk-space-util --disk-path=/
# To collect all available memory and disk metrics and send them to CloudWatch, counting cache and buffer memory as used
./mon-get-instance-stats.pl --recent-hours=12