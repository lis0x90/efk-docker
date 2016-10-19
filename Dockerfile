FROM centos:7

ADD yum.repos.d /etc/yum.repos.d/
RUN rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch \
	&& yum -y install epel-release \
	&& yum -y install java-1.8.0-openjdk-headless elasticsearch \
			wget supervisor gcc-c++ patch readline readline-devel \
			zlib zlib-devel libyaml-devel libffi-devel openssl-devel \
			make bzip2 autoconf automake libtool bison iconv-devel sqlite-devel which \
	&& yum clean all \
	&& cd /opt/ \
	&& wget https://download.elastic.co/kibana/kibana/kibana-4.6.1-linux-x86_64.tar.gz \
	&& tar xzvf kibana-4.6.1-linux-x86_64.tar.gz \
	&& ln -s /opt/kibana-4.6.1-linux-x86_64 /opt/kibana4 \
	&& rm -f kibana-4.6.1-linux-x86_64.tar.gz

RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - 
RUN curl -L get.rvm.io | bash -s stable 
RUN ["/bin/bash", "-c", "source /etc/profile.d/rvm.sh && \
       rvm reload && \
       rvm install 2.2.4 && \
       rvm use 2.2.4 --default && \
       /usr/local/rvm/rubies/ruby-2.2.4/bin/gem install fluentd -v 0.14.8 && \
       /usr/local/rvm/gems/ruby-2.2.4/bin/fluent-gem install fluent-plugin-elasticsearch -v 1.7.0"]
       
RUN echo -e "#!/bin/bash\n. /etc/profile.d/rvm.sh && /usr/local/rvm/gems/ruby-2.2.4/bin/fluentd --log /var/log/fluentd.log" > /opt/fluentd.sh \
	&& chmod +x /opt/fluentd.sh

ADD etc /etc/ 

VOLUME ["/elasticsearch"]

EXPOSE 24224 5601 9200 8888

CMD ["/usr/bin/supervisord"]
