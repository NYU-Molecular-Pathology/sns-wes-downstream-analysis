#!/bin/bash

## USAGE: run.sh "<project_ID>" "<results_dirname>"
## EXAMPLE: run.sh "NS17-03" "RUN_4"
## DESCRIPTION: This script will set up and run the downstream analysis for the WES pipeline

# ~~~~~ CHECK SCRIPT ARGS ~~~~~ #
if (( "$#" != "2" )); then
    echo "ERROR: Wrong number of arguments supplied"
    grep '^##' $0
    exit
fi

# ~~~~~ GET SCRIPT ARGS ~~~~~ #
project_ID="$1" # ex: NS17-03/RUN_4
results_ID="$2"



# ~~~~~ SET ENVIRONMENT ~~~~~ #
module load pandoc/1.13.1

# ~~~~~ RUN ~~~~~ #
# set project_ID items for report
printf "%s" "$project_ID" > project_ID.txt
printf "%s" "$results_ID" > results_ID.txt

# get the annotations for all samples
gatk_annotations_file="${project_ID}_${results_ID}_GATK_annotations.tsv"
printf "Find all GATK variants...\n"
find "run_analysis_output/VCF-GATK-HC-annot/" -name "*.combined.txt" | xargs ./toolbox/concat_tables.py > "$gatk_annotations_file" && printf "Variants saved to file:\n%s\n\n" "$gatk_annotations_file"

lofreq_annotations_file="${project_ID}_${results_ID}_LoFreq_annotations.tsv"
printf "Finding all LoFreq variants...\n"
find "run_analysis_output/VCF-LoFreq-annot/" -name "*.combined.txt" | xargs ./toolbox/concat_tables.py > "$lofreq_annotations_file" && printf "Variants saved to file:\n%s\n\n" "$lofreq_annotations_file"

# make a copy of the report template file
report_file="${project_ID}_${results_ID}_analysis_report.Rmd"
printf "Generating report file:\n%s\n\n" "$report_file"
/bin/cp analysis_report.Rmd "$report_file"

# compile the report
printf "Compiling report file:\n%s\n\n" "$report_file"
./compile_RMD_report.R "$report_file"
