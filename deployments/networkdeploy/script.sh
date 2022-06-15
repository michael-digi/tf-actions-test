#!/bin/bash

output=$(AWS_PROFILE=gck aws ec2 describe-availability-zones --region us-east-1 | jq -r '.AvailabilityZones[].ZoneName'); \
arr=($output)
if (( ${#arr[@]} <= 6 )); then
    echo yea
fi