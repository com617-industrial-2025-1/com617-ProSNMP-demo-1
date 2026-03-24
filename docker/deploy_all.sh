#!/bin/bash

LAB_FILE="../containerlab/containerlab.yaml"
API_URL="http://localhost:8081/promsnmp/discovery"

echo "--- Step 1/4: Starting Docker Compose Services ---"
sudo docker compose up -d --remove-orphans

echo "--- Step 2/4: Deploying Network Topology ---"
sudo containerlab deploy -t $LAB_FILE --reconfigure

echo "--- Step 3/4: Waiting for promsnmp API (Port 8081) ---"
MAX_RETRIES=120
COUNT=0

while ! curl -s --fail http://localhost:8081/promsnmp/discovery > /dev/null; do
    COUNT=$((COUNT+1))
    if [ $COUNT -eq $MAX_RETRIES ]; then
        echo "Error: API failed to start within 60 seconds."
        sudo docker logs docker-promsnmp-1 --tail 5
        exit 1
    fi
    echo "Waiting for API... ($COUNT/$MAX_REPLIES)"
    sleep 3
  
done
echo " API is live!"

echo "--- Step 4/4 Triggering SNMP Discovery ---"
curl -v POST http://127.0.0.1:8081/promsnmp/discovery \
-H "Content-Type: application/json" \
-d '{"version": "v2c", "readCommunity": "public", "port": 161, "agentType": "snmp-community", "potentialTargets": ["172.20.0.10", "172.20.0.11", "172.20.0.12", "172.20.0.13", "172.20.0.14"]}'

echo "--- Setup Complete ---"
