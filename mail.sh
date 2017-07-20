#!/bin/bash

## USAGE: mail.sh "<project_ID>" "<results_dirname>"
## EXAMPLE: mail.sh "NS17-03" "RUN_4"
## DESCRIPTION: This script will aggregate results and mail them out

# ~~~~~ CHECK SCRIPT ARGS ~~~~~ #
if (( "$#" != "2" )); then
    echo "ERROR: Wrong number of arguments supplied"
    grep '^##' $0
    exit
fi

# ~~~~~ GET SCRIPT ARGS ~~~~~ #
project_ID="$1" # ex: NS17-03/RUN_4
results_ID="$2"


# ~~~~~ RUN ~~~~~ #
results_list="results_list.txt"

find . -type f -name "*${project_ID}*" -name "*${results_ID}*" ! -name "*.md" ! -name "*.Rmd"  ! -name "*.html" ! -name "*.zip" -exec readlink -f {} \; > "$results_list"
find sns-wes-coverage-analysis/ -type f -name "*${project_ID}*" -name "*${results_ID}*" -exec readlink -f {} \; >> "$results_list"

zip_filename="${project_ID}_${results_ID}_results.zip"
cat "$results_list" | xargs zip -j "$zip_filename"

report_file="${project_ID}_${results_ID}_analysis_report.html"

# make sure the report file exists
[ ! -f "$report_file" ] && printf "\nERROR: Report file not found:\n%s\n\n" "$report_file"

# make sure the zip file exists
[ ! -f "$zip_filename" ] && printf "\nERROR: Zip file not found:\n%s\n\n" "$zip_filename"

# make sure samples list exists
[ ! -f "../samples.fastq-raw.csv" ] && printf "\nERROR: Samples list file not found:\n%s\n\n" "../samples.fastq-raw.csv"

# make sure the final summary table exists
[ ! -f "../summary-combined.wes.csv" ] && printf "\nERROR: Summary table file not found:\n%s\n\n" "../summary-combined.wes.csv"

# check for RunParameters.xml and RunParameters.txt; it might not exist
RunParameters_file=""
if [ -f "../RunParameters.xml" ]; then
    RunParameters_file="../RunParameters.xml"
fi

RunParameters_message="" # default message
if [ -f "../RunParameters.txt" ]; then
    RunParameters_message="$(cat ../RunParameters.txt)"
fi

ExperimentName="" # default message
if [ -f "../ExperimentName.txt" ]; then
    ExperimentName="$(cat ../ExperimentName.txt)"
fi


# copy the summary table with new name
source_summary_table="$(readlink -f ../summary-combined.wes.csv)"
output_summary_table="${project_ID}_${results_ID}_summary-combined.wes.csv"
/bin/cp "$source_summary_table" "$output_summary_table"

file_owner="$(ls -ld "$report_file" | awk '{print $3}')"
file_date="$(ls -l --time-style=long-iso "$report_file" | awk '{print $6 " " $7}')"
file_fullpath="$(readlink -f "$report_file")"

reply_to="kellys04@nyumc.org"
# recipient_list="$reply_to"
recipient_list="kellys04@nyumc.org, Matija.Snuderl@nyumc.org, Naima.Ismaili@nyumc.org, Aristotelis.Tsirigos@nyumc.org, Jared.Pinnell@nyumc.org, Varshini.Vasudevaraja@nyumc.org, Tatyana.Zhuravleva@nyumc.org, Hussein.Mohamed@nyumc.org"
message_footer="- This message was sent automatically by $(whoami) -"
subject_line_report="[NGS580] ${project_ID} - $ExperimentName Report & Results"

email_message_file="email_message.txt"
cat > "$email_message_file" <<E02
NGS 580 Panel Target Exome Sequencing Clinical Report

Project ID:
${project_ID}

Results ID:
${results_ID}

Samples List:
$(cat ../samples.fastq-raw.csv | cut -d ',' -f1 | sort -u)

$RunParameters_message

System location:
${file_fullpath}

${message_footer}
E02

./toolbox/mutt.py -r "${recipient_list}" -rt "$reply_to" -mf "$email_message_file" -s "$subject_line_report" "$report_file" "$zip_filename" "$output_summary_table" $RunParameters_file
