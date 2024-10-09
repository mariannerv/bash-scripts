# Elasticity Script for Google Cloud VMs

## Overview

This script dynamically manages Google Cloud Compute Engine VM instances based on the average CPU usage of currently running instances. It automates the process of starting and stopping instances depending on system load, providing elasticity to your virtual infrastructure. When the CPU usage exceeds certain thresholds, additional VMs are started. Conversely, when CPU usage drops below defined levels, instances are stopped to conserve resources.

## Features

- Start Instances: Automatically starts new instances when the CPU usage across running instances exceeds predefined thresholds.
- Stop Instances: Automatically shuts down instances when the CPU usage falls below predefined thresholds.
- Customizable: Thresholds for starting and stopping instances, as well as instance names, can be adjusted as needed.

## Prerequisites

- Google Cloud SDK (gcloud) installed and authenticated on the machine running this script.
- Ensure that you have sufficient IAM permissions to manage instances (start/stop) and SSH into them.
- SSH Access enabled for all target VMs. The SSH configuration must be properly set up.

## Configuration

Before running the script, make sure to configure your project and zone by updating the following variables:

- ``PROJECT_ID`` : Set this to your Google Cloud project ID.
- ``ZONE`` : Set this to the zone where your instances are located.

```bash
PROJECT_ID= "Your project ID"
ZONE= "the zone you set for your VMs" 
```

## Usage

1. Start and Stop Functions:

- The script defines functions start_instance() and stop_instance() to start and stop individual instances.
- These functions are invoked automatically based on the CPU usage thresholds.

2. Monitoring CPU Usage:

- The script lists all currently running instances.
- It then calculates the average CPU usage by SSHing into each running instance, executing the ``top`` command to gather CPU statistics, and computing the average across all instances.

3. Threshold-Based Instance Management:

- If the average CPU usage is above 80%, the script starts ``servidor3``.
- If the CPU usage is between 70% and 80%, it starts ``servidor4``.
- If the CPU usage is between 60% and 70%, it starts ``servidor5``.
- Similarly, if CPU usage drops below 50%, 40%, or 30%, the corresponding instances (``servidor3``, ``servidor4``, and ``servidor5``) are stopped.

## Starting the script

1. Ensure the script is executable:

```bash
chmod +x <script_name>.sh
```

2. Run the script:
```bash
./elasticity.sh
```


