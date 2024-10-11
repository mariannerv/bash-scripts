#!/bin/bash

PROJECT_ID="YOUR PROJECT ID"
ZONE="YOUR ZONE"
gcloud config set project $PROJECT_ID

get_cpu_usage() {
    ACTIVE_INSTANCES=$(gcloud compute instances list --filter="status:RUNNING AND name~'servidor'" --format="value(name)")

    NUM_INSTANCES=$(echo "$ACTIVE_INSTANCES" | wc -l)

    
    if [ "$NUM_INSTANCES" -eq 0 ]; then
        echo "No running instances found with 'servidor' in their name."
        return
    fi

    TOTAL_CPU_USAGE=0
    INSTANCE_COUNT=0

    for INSTANCE_NAME in $ACTIVE_INSTANCES; do
        echo "CPU usage for instance: $INSTANCE_NAME"

        TOP_OUTPUT=$(sudo gcloud compute ssh $INSTANCE_NAME --zone=$ZONE --command="top -bn1" 2>&1)
        echo "SSH Output: $TOP_OUTPUT"  # Debugging output

        if [ $? -ne 0 ]; then
            echo "Failed to connect to $INSTANCE_NAME"
            continue
        fi

        CPU_USAGE=$(echo "$TOP_OUTPUT" | grep '%Cpu(s):' | awk '{print $2}' | cut -d ',' -f1)

        if [[ ! $CPU_USAGE =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            echo "Invalid CPU usage value for $INSTANCE_NAME: $CPU_USAGE"
            continue
        fi

        echo "CPU usage: $CPU_USAGE%"

        TOTAL_CPU_USAGE=$(echo "$TOTAL_CPU_USAGE + $CPU_USAGE" | bc)
        INSTANCE_COUNT=$((INSTANCE_COUNT + 1))
    done

    if [ $INSTANCE_COUNT -eq 0 ]; then
        echo "No valid CPU usage data found."
        return
    fi

    AVERAGE_CPU_USAGE=$(echo "scale=2; $TOTAL_CPU_USAGE / $INSTANCE_COUNT" | bc)
    echo "Average CPU usage across all instances: $AVERAGE_CPU_USAGE%"
}

while true; do
    get_cpu_usage >> cpu_usage.log
    echo "--------------------------------------------" >> cpu_usage.log
    sleep 60
done
