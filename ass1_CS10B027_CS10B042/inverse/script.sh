#!/bin/bash
# loop to get output and see the timing
echo on
for i in $(seq 1 1000);
do
	./inverse < sample_ip
done
