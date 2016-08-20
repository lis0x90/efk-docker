FROM centos:7

ADD yum.repos.d /etc/yum.repos.d/
ADD etc /etc/

RUN yum install -y gcc
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
	&& /opt/td-agent/embedded/bin/fluent-gem install fluentd -v 0.14.1

COPY /etc/td-agent/out_elasticsearch.rb /opt/td-agent/embedded/lib/ruby/gems/2.1.0/gems/fluent-plugin-elasticsearch-1.5.0/lib/fluent/plugin/
COPY /etc/td-agent/out_elasticsearch.rb /opt/td-agent/embedded/lib/ruby/gems/2.1.0/gems/fluentd-ui-0.4.2/app/models/fluentd/setting/
COPY /etc/td-agent/fluent-plugin-elasticsearch.gemspec /opt/td-agent/embedded/lib/ruby/gems/2.1.0/gems/elasticsearch-2.0.0/
COPY /etc/td-agent/fluent-plugin-elasticsearch.gemspec /opt/td-agent/embedded/lib/ruby/gems/2.1.0/gems/fluent-plugin-elasticsearch-1.5.0/

RUN rm -f /etc/td-agent/out_elasticsearch.rb \
	&& rm -f /etc/td-agent/fluent-plugin-elasticsearch.gemspec \
	&& yum clean all 

VOLUME ["/elasticsearch"]

EXPOSE 24224 5601 9200 8888

CMD ["/usr/bin/supervisord"]
