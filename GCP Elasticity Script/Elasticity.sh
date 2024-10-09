# Function to start an instance
start_instance() {
    local instance_name=$1
    gcloud compute instances start $instance_name --zone=$ZONE
}

# Function to stop an instance
stop_instance() {
    local instance_name=$1
    gcloud compute instances stop $instance_name --zone=$ZONE
}

#ID project and Zone
PROJECT_ID="your project id"
ZONE="the zone you picked for your VMs"
gcloud config set project $PROJECT_ID

# List active VM instances
ACTIVE_INSTANCES=$(gcloud compute instances list --filter="status=RUNNING AND name~'^servidor'" --format="value(name)")

# Calculate average CPU usage
CPU_SUM=0
NUM_INSTANCES=0
for INSTANCE_NAME in $ACTIVE_INSTANCES; do
    CPU_USAGE=$(gcloud compute ssh $INSTANCE_NAME --zone=$ZONE --command="top -bn1 | grep '%Cpu(s):' | awk '{print \$2}' | cut -d ',' -f1")
    CPU_SUM=$(echo "$CPU_SUM + $CPU_USAGE" | bc)
    NUM_INSTANCES=$((NUM_INSTANCES + 1))
done
AVERAGE_CPU=$(echo "scale=2; $CPU_SUM / $NUM_INSTANCES" | bc)

echo "Average CPU usage across all instances: $AVERAGE_CPU%"

# Start instances based on average CPU usage
if (( $(echo "$AVERAGE_CPU > 80" | bc -l) )); then
    start_instance servidor3
    echo "Started servidor3 instance"
elif (( $(echo "$AVERAGE_CPU > 70" | bc -l) )); then
    start_instance servidor4
    echo "Started servidor4 instance"
elif (( $(echo "$AVERAGE_CPU > 60" | bc -l) )); then
    start_instance servidor5
    echo "Started servidor5 instance"
fi

# Stop instances based on average CPU usage
if (( $(echo "$AVERAGE_CPU < 50" | bc -l) )); then
    stop_instance servidor3
    echo "Stopped servidor3 instance"
elif (( $(echo "$AVERAGE_CPU < 40" | bc -l) )); then
    stop_instance servidor4
    echo "Stopped servidor4 instance"
elif (( $(echo "$AVERAGE_CPU < 30" | bc -l) )); then
    stop_instance servidor5
    echo "Stopped servidor5 instance"
fi
