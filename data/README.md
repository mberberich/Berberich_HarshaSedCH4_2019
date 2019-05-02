## DATA README

This directory contains data for the project. Raw data is available at the OSF project page (https://osf.io/59hnj/) in the "data" component. Process data is accessible at GitHub, but can be accessed through the same OSF page as above. The directory is organized into sub-folders:

### Overview

	project
	|- README                        # the top level description of content
	|- LICENSE                       # the license for this project
	|
	|- data                          # raw and primary data, are not changed once created
	| |- raw                         # raw data, will not be altered; available only on OSF
	|   +-fastq/                     # raw fastq files; available on OSF or NCBI
	| |- process                     # cleaned data, will not be altered once created; available on OSF or GitHub
	|   |-methanogens/               # process data files from 16S sequence analysis in mothur
	|   +-mixing_model/              # input and output files for mixing model
	|
	|- code/                         # any programmatic code
	|
	|- results                       # all output from workflows and analyses
	| |- tables/                     # xlsx version of tables generated with scripts
	| |- figures/                    # figures
	| +- supplemental_information/   # supplemental tables and figures
	|
	+- .Rproject                     # associated .Rproj


### Retrieving data from the respositories
An example of how to download a file from here (this will download the public "test" file from the main component/page):

wget -O test.xlsx https://osf.io/qr6f8/?action=download

In order to do this wget needs to be installed on your computer. See https://www.gnu.org/software/wget/. 
