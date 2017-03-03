# Install Bro on Centos script
# Ben Hoffman
# Took out the needed parts from my friends script here:
# https://github.com/Benster900/CloudsOfHoneyManagementNode/blob/master/scripts/deploy_bro.sh#L130

# Update the system
Yum update -y && yum upgrade -y
Yum install git vim curl -y

# Install Dependencies
yum install cmake make gcc gcc-c++ flex bison libpcap-devel openssl-devel python-devel swig zlib-devel git -y

# Install Bro
cd /opt
git clone --recursive git://git.bro.org/bro
cd bro
./configure
make
make install
export PATH=/usr/local/bro/bin:$PATH

# Configure Bro
broInterface=$(ip a | grep '2:' | grep 'en' | awk '{print $2}' |rev | cut -c 2- | rev)
echo $broInterface
sed -i "s#interface=eth0#interface=$broInterface#g" /usr/local/bro/etc/node.cfg

# Enable Bro JSON logging
sed -i 's#const use_json = F#const use_json = T#g' /usr/local/bro/share/bro/base/frameworks/logging/writers/ascii.bro

# Start Bro
/usr/local/bro/bin/broctl install
/usr/local/bro/bin/broctl start
/usr/local/bro/bin/broctl status