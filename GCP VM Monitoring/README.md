
# CPU Usage Monitoring Script for Google Cloud VM Instances

This Bash script monitors CPU usage across all running Google Cloud VM instances whose names contain the word ``servidor``(feel free to change it to whatever you need!). It retrieves the CPU usage, calculates the average CPU usage across all matching instances, and logs the results.

## Script Breakdown

### Configuration

- ``PROJECT_ID`` : Replace this with your actual Google Cloud project ID.
- ``ZONE`` : Set the appropriate zone where your VM instances are running.

### What the script does

1. **Set the Google Cloud Project**:

```bash
gcloud config set project $PROJECT_ID
```
The script sets the active project to your specified Google Cloud project.

2. **Identify Running Instances**: It filters running instances that have the name pattern ``servidor`` (again, you can change this) in them:

```bash
gcloud compute instances list --filter="status:RUNNING AND name~'servidor'"
```
Only instances that are running and whose names contain the word "servidor" are considered.

3. **Retrieve CPU Usage**: For each matching instance, the script logs into the machine using SSH and runs the ``top`` command to retrieve the CPU usage. It extracts the percentage of CPU being used from the output:

```bash
top -bn1
```

4. **Calculate Average CPU Usage** : The CPU usage for each instance is aggregated, and an average CPU usage across all instances is computed and logged.

5. **Logging** : The results, including the CPU usage of individual instances and the average CPU usage, are appended to a ``cpu_usage.log`` file. 

## Script Execution

The script runs in an infinite loop, checking CPU usage every 60 seconds and logging the output. This interval can be changed of course.

## Example Output

```bash
CPU usage for instance: servidor-1
CPU usage: 5.3%
CPU usage for instance: servidor-2
CPU usage: 12.7%
Average CPU usage across all instances: 9.00%
```

## How to use 

1. Make the script executable:

```bash
chmod +x CPU_Usage.sh
```

2. Run the script:

```bash
./CPU_Usage.sh
```
