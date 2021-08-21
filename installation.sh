#!/bin/bash


echo "starting application installation";


sudo apt-get update
cat soft.txt
wget –qO – https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add –


#list of softwares
softwares=("openjdk-8-jdk" "nginx" "apt-transport-https" "elasticsearch" "kibana" "logstash" "filebeat" "metricbeat" "heartbeat-elastic")



#see if softwares installed or not if not then install it
#and configure it


for u in "${softwares[@]}"
do
       	apt list $u>>soft.txt
	r="`cat soft.txt|grep .*$u*`".
        if [[ -z "$r" ]];
        then

               sudo apt-get update -qq&&sudo apt-get install -yy $u;
	fi

                case "$u" in
                        "apt-transport-https")echo deb https://artifacts.elastic.co/packages/7.x/apt stable main | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
                                sudo apt-get update
				ps -p 1

                                ;;
			"ngnix")continue
				;;
			"openjdk-8-jdk")continue
				;;
			"elasticsearch")sudo /bin/systemctl daemon-reload
				;;
			*)echo ""
				;;
#configuring and starting services
		esac
		if [[ $u != "logstash" ]];
		then
			sudo update-rc.d $u defaults 95 10 -qq;
		fi
		sudo /bin/systemctl enable $u.service
               sudo systemctl start $u.service

	       if [[ $u == "kibana" ]];
	       then 
		       sudo ufw allow 5601/tcp;
	       fi
	       echo "$u service started";
       done

       sudo rm -f /home/in88/GPG-KEY-elasticsearch*
       sudo  rm -f /home/elasticsearch-7.12.0-linux-x86_64.tar.gz*


       echo "All the services are running check through system ctl status"
