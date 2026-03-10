#!/bin/sh

containerlab deploy -t /containerlab/solent_cloud.clab.yaml


sleep 5

curl -X POST http://promsnmp:8080/promsnmp/discovery \
     -H "Content-Type: application/json" \
     -d '{
  "version": "v2c",
  "readCommunity": "public",
  "port": 161,
  "agentType": "snmp-community",
  "potentialTargets": ["172.20.0.13", "172.20.0.9", "172.20.0.10", "172.20.0.12", "172.20.0.2", "172.20.0.7", "172.20.0.16", "172.20.0.14", "172.20.0.11", "172.20.0.15", "172.20.0.8", "172.20.0.6"]
}'

tail -f /dev/null