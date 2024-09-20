#!/bin/bash

#squeue -u sglanvil | awk '$2 == "regular_m" && $6 == "0:00" {print $1}' | while read jobid; do
squeue -u sglanvil | awk '$6 == "0:00" {print $1}' | while read jobid; do
	scontrol update jobid=$jobid reservationname=''
done

