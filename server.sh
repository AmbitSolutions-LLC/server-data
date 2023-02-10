#!/bin/bash

deployment() {
	local deployID=$(fwconsole sysadmin info | awk '{print $2}' | grep -Eo '[0-9]{1,9}');
	echo "Activation: " $deployID;
	return 0;
}

nicMAC() {
	join <(ip -o -br link | sort) <(ip -o -br addr | sort) | awk '$2=="UP" {print $1,$6,$3}';	
	return 0;
}

cpu() {
	grep 'model name' /proc/cpuinfo | uniq | xargs;
	echo "CPU cores: " $(nproc)
	return 0;
}

lvmAge() {
	block=$(df | sort -k2n | tail -1 | awk '{ print $1 }');	
	date=$(tune2fs -l $block | grep 'Filesystem created');
	echo $date
	return 0;
}

storage() {
	conversion=1000000;
	storage=$(df | sort -k2n | tail -1 | awk '{print $2}');
	echo -n "Total Storage: ";
	echo "scale=1 ; $storage / $conversion" | bc;
	return 0;
}
ram() {
	convert=1000000;
	stor=$(grep MemTotal /proc/meminfo | grep -Eo '[0-9]' | xargs);
	stor_nowhitespace="$(echo -e "${stor}" | tr -d '[:space:]')";
	echo -n "Total RAM: ";
	echo "scale=1 ; $stor_nowhitespace / $convert" | bc;
	return 0;
}

wan() {
	local IP=$(grep external_media /etc/asterisk/pjsip.transports.conf | head -1 | awk -F '=' '{ print $2 }');
	echo "wan IP: " $IP;
	return 0;
}

health() {
	find /sbin/health*;
	return 0;
}

sshPort() {
	ssh=$(grep Port /etc/ssh/sshd_config | awk -F '[ ]' '{print $2}' | sed 's/\<no\>//g');
	echo "SSH Port: " $ssh;
	return 0;
}

termHist() {
	hist=$(cat /etc/bashrc | grep HIST);	
	echo "Terminal History: " $hist;
	return 0;
}

asterV() {
	echo $(asterisk -x "core show version" | awk -F '[ ]' '{print $1 " " $2}');	
	return 0;
}

hostname() {
	hostnamectl | awk NR==1'{print $2 " " $3}';
	return 0;
}

sysadminStor() {

	return 0;
}

safeAst() {
	ps aux | grep safe_ | awk -F '/' '{print $6}' | awk -F '-' '{print $1}';
	return 0;
}

termUser() {
	term=$(cat /etc/bashrc | grep PS1= | grep -v "#" | awk -F'"' '{print $2}' | sed 's/>//');
	echo "Terminal Username: " $term;
	return 0;
}

modCheck() {
	zuluIs=$(fwconsole ma list | grep zulu);
	smrtOfficeIs=$(fwconsole ma list | grep iot);
	echo $zuluIs;
	echo $smrtOfficeIs;
	return 0;
}

deployment
nicMAC
cpu
ram
storage
lvmAge
wan
health
sshPort
asterV
termUser
termHist
hostname
modCheck