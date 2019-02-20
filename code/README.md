## CODE README

This directory contains all code to generate statitistical output and figures found in Berberich et al. 2018. The data is accessible at the Center for Open Science's Open Science Framework (OSF) webpage. See the project README for details about dependencies and data needed to regenerate figures and statistical output. 

If regenerating this file without using a bash script, it is necessary to run code in the correct sequence. The apporpriate order can be found by opening up the bash script and running the code in the sequence it is presented there. For example:
* calcuate_CH4_production_rates.R
* run_mixing_model.R
* get_good_seqs.batch
* get_shared_otus.batch
* 



R Information ('sessionInfo()'):
* R version 3.4.0 (2017-04-21)
* Platform: x86_64-apple-darwin15.6.0 (64-bit)
* Running under: macOS Sierra 10.12.6

Specific package versions:
* openxlsx: 4.0.17
* dtplyr: 0.0.2
* dplyr: 0.7.4
* data.table: 1.10.4
* ggplot2: 2.2.1
