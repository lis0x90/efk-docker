#!/bin/bash

ES_HOME=/usr/share/elasticsearch
ES_LOG_DIR=/var/log/elasticsearch
ES_DATA_DIR=${ES_DATA_DIR:-/var/lib/elasticsearch}
ES_WORK_DIR=/tmp/elasticsearch
ES_CONF_DIR=/etc/elasticsearch

$ES_HOME/bin/elasticsearch -d \
		-Des.default.path.home=$ES_HOME \
		-Des.default.path.logs=$ES_LOG_DIR \
		-Des.default.path.data=$ES_DATA_DIR \
		-Des.default.path.work=$ES_WORK_DIR \
		-Des.default.path.conf=$ES_CONF_DIR
