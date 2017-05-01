# sns-wes-downstream-analysis
Downstream analysis of SNS WES pipeline output.

# Usage

- First, run the SNS WES pipeline: https://github.com/igordot/sns

- Run the [sns-wes-coverage-analysis](https://github.com/NYU-Molecular-Pathology/sns-wes-coverage-analysis) pipeline on the results 

- Enter the directory you ran the SNS pipeline in 

```
cd sns-output-dir
```

- Clone this repository and enter the directory

```bash
git clone https://github.com/NYU-Molecular-Pathology/sns-wes-downstream-analysis.git
cd sns-wes-downstream-analysis
```

- Set the symlink to the directory holding your SNS results

```bash
ln -fs /path/to/sns-wes_results
```

- Run 

```
run.sh "<project_ID>" "<results_dirname>"
```

Example:

```
run.sh "NS17-03" "RUN_4"
```

# Output
[coming soon]

# Software Requirements
- pandoc version 1.13+ 
- R version 3.3.0, with the following packages:
  - ChIPpeakAnno
  - biomaRt
