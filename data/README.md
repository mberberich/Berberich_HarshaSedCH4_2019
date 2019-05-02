## DATA README

This contains all data for this project. It is organized into sub-folders:

## Overview

  project
	|- data                          # raw and primary data, are not changed once created
	| |- raw                         # raw data, will not be altered; available only on OSF
	|   |-fastq/                     # raw fastq files; available on OSF or NCBI
	| |- process                     # cleaned data, will not be altered once created; available on GitHub or OSF
	|   |-methanogens/               # process data files from 16S sequence analysis in mothur
	|   +-mixing_model/              # input and output files for mixing model
	|                                # will be committed to repo
	|
	|- code/                         # any programmatic code
	|
	|- results/                      # all output from workflows and analyses
	| |- tables/                     # xlsx version of tables generated with scripts
	| |- figures/                    # figures
	| +- supplementa_information/    # supplemental tables and figures
	|
	+- .Rproject                     # executable Makefile for this study, if applicable


An example of how to download a file from here (this will download the public "test" file from the main component/page):

wget -O test.xlsx https://osf.io/qr6f8/?action=download

In order to do this wget needs to be installed on your computer. See https://www.gnu.org/software/wget/. 