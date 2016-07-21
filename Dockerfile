FROM centos:7

ADD yum.repos.d /etc/yum.repos.d/
ADD etc /etc/

RUN rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch \
	&& yum -y install epel-release \
	&& rpm --import https://packages.treasuredata.com/GPG-KEY-td-agent \
	&& yum -y install java-1.8.0-openjdk-headless elasticsearch td-agent wget supervisor \
	&& cd /opt/ \
	&& wget https://download.elastic.co/kibana/kibana/kibana-4.1.0-linux-x64.tar.gz \
	&& tar xzvf kibana-4.1.0-linux-x64.tar.gz \
	&& ln -s /opt/kibana-4.1.0-linux-x64 /opt/kibana4 \
	&& rm -f kibana-4.1.0-linux-x64.tar.gz \
	&& /opt/td-agent/embedded/bin/fluent-gem install fluent-plugin-elasticsearch \
	&& /opt/td-agent/embedded/bin/fluent-gem install fluent-plugin-record-reformer \
	&& yum clean all 

VOLUME ["/elasticsearch"]

EXPOSE 24224 5601 9200 8888

CMD ["/usr/bin/supervisord"]
