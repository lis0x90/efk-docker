#!/bin/bash

TD_AGENT_HOME=/opt/td-agent
TD_AGENT_LOG_FILE=/var/log/td-agent/td-agent.log
TD_AGENT_OPTIONS="--use-v1-config"

/opt/td-agent/embedded/bin/ruby /usr/sbin/td-agent \
  --log ${TD_AGENT_LOG_FILE} ${TD_AGENT_OPTIONS}

