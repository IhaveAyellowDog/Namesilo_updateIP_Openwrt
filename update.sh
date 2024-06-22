#!/bin/bash
set -u

#Go to the work dictionary /var .

cd /var/

# settings
# Login information of namesilo.com

key=""
tel_id=""
domain_name=""
rrid=""
#rrid will get the value later
rrhost="www"
rrttl="3601"  
# namesili define ttl must greater or equal to 3600.

GET_IP_URL="http://ip.3322.net/"

wget -O test.xml "https://www.namesilo.com/api/dnsListRecords?version=1&type=xml&key=$key&domain=$domain_name"


# get Local Host ip address
current_ip="$(curl -s "$GET_IP_URL")"

# added by IhaveAyellow_Dog 20230328 begin
echo " Check DNS for $rrhost.$domain_name ."

# host_ip="$(hostip $rrhost.$domain_name)" 
# host_ip may take affect by delay of dns ttl ,So it's alternated by the following scripts.

host_ip=$(egrep -o "<host>$rrhost.$domain_name</host><value>([0-9]{1,3}[\.]){3}[0-9]{1,3}</value>" test.xml | egrep -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")

if [ $current_ip = $host_ip ]
then
    echo "Local Host IP:"$current_ip", "$rrhost.$domain_name"DNS IP:"$host_ip".No change is needed, exiting."
	rm test.xml
	exit 1
else
 echo  "Local Host IP:"$current_ip", "$rrhost.$domain_name" DNS IP:"$host_ip".Change is needed Now update DNS"
fi
# added by ihaveAyellowDog 20230328 end

if [ -z "$current_ip" ]; then
    echo "Could not get current IP address." 1>&2
    exit 1
fi

#Begin get the rrid Value.added by ihaveAyellowDog.

rrid=$(grep -o "................................</record_id><type>A</type><host>$rrhost.$domain_name</host>" test.xml | grep -o "^................................")


rm test.xml

if [ -z "$rrid" ]; then
    echo "Could not get rrid, Exit with error." 1>&2
    exit 1
fi

echo "The rrid is $rrid."

#begin update old record.

echo "Begin update Old record."

echo "Update $current_ip to Records name $rrhost on domain($domain_name)."

echo "The update URL is :"
echo     "https://www.namesilo.com/api/dnsUpdateRecord?version=1&type=xml&key=$key&domain=$domain_name&rrid=$rrid&rrhost=$rrhost&rrvalue=$current_ip&rrttl=$rrttl" 
echo "----------------------------------------------------------------------------"
curl -k -L  "https://www.namesilo.com/api/dnsUpdateRecord?version=1&type=xml&key=$key&domain=$domain_name&rrid=$rrid&rrhost=$rrhost&rrvalue=$current_ip&rrttl=$rrttl" 

echo "End Update record."


exit 0