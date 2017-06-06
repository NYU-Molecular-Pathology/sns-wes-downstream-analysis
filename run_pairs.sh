#!/bin/bash


## USAGE: run_pairs.sh
## DESCRIPTION: This script will set up and run the downstream analysis for the WES pipeline

num_not_NA="$(cat ../samples.pairs.csv | tail -n +2 | cut -d ',' -f2 | grep -v 'NA' | wc -l)"

file_timestamp () {
    printf "$(date -u +%Y-%m-%d-%H-%M-%S)"
}

run_pairs () {
    local jobs_stdout_log="job_submit_stdout_$(file_timestamp).txt"
    echo "Paired samples found, running paired analysis..."
    (
    cd ..
    # check for errors
    grep "ERROR:" logs-qsub/*
    )

    (
    cd ..
    # run the paired analysis
    sns/run wes-pairs-snv
    ) | tee "$jobs_stdout_log"

    # watch the jobs...
    # jobs_stdout_log="job_submit_stdout.txt"
    if [ -f  "$jobs_stdout_log" ]; then
        job_ids="$(grep 'Your job' "$jobs_stdout_log" | grep 'has been submitted' | cut -d ' ' -f3 | xargs)"
        echo "$job_ids"
    fi

}

if (( "$num_not_NA" > "0" )); then
    printf ""
    run_pairs
else
    echo "No paired samples found!"
fi
