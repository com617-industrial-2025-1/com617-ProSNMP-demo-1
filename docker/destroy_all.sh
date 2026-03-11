#!/bin/bash

LAB_FILE="../containerlab/solent_cloud.clab.yaml"

echo "--- Step 1/3: Destroying Network Topology ---"
sudo containerlab destroy -t $LAB_FILE

echo "--- Step 2/3: Stopping Docker Services ---"
sudo docker compose down

echo "--- Step 3/3: Cleaning up Network Namespaces ---"
for ns in $(ip netns list | cut -d' ' -f1 | grep "clab-"); do
    echo "Removing namespace: $ns"
    sudo ip netns delete "$ns"
done

echo "--- Cleanup Complete ---"
