#!/bin/bash

CWD=`dirname "$0"`

$CWD/elasticsearch.sh &
$CWD/td-agent.sh &
$CWD/kibana.sh