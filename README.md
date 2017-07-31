# sns-wes-downstream-analysis
Downstream analysis of SNS WES pipeline output.

# Example Output
__[[ A full HTML version of the report output can be previewed [here](http://htmlpreview.github.io/?https://github.com/NYU-Molecular-Pathology/sns-wes-downstream-analysis/blob/fb5ba3eaf1b565c384343419b4cabd461675e8f9/demo-output_results1_analysis_report.html) or [here](https://cdn.rawgit.com/NYU-Molecular-Pathology/sns-wes-downstream-analysis/fb5ba3eaf1b565c384343419b4cabd461675e8f9/demo-output_results1_analysis_report.html). ]]__




# Usage

- First, run the SNS WES pipeline: https://github.com/igordot/sns

- Run the [sns-wes-coverage-analysis](https://github.com/NYU-Molecular-Pathology/sns-wes-coverage-analysis) pipeline on the results 

- Enter the directory you ran the SNS pipeline in 

```
cd <sns-output-dir>
```

- Clone this repository and enter the directory

```bash
git clone --recursive https://github.com/NYU-Molecular-Pathology/sns-wes-downstream-analysis.git
cd sns-wes-downstream-analysis
```

- Run 

```
run.sh "<project_ID>" "<results_dirname>"
```

Example:

```
run.sh "NS17-03" "RUN_4"
```


# Software Requirements
- pandoc version 1.13+ 
- R version 3.3.0, with the following packages:
  - ChIPpeakAnno
  - biomaRt
