## Spatial variability of sediment methane production and methanogen communities within a eutrophic reservoir: importance of organic matter source and quantity

Freshwater reservoirs are an important source of the greenhouse gas methane (CH4) to the atmosphere, but global emission estimates are poorly constrained (13.3 – 52.5 Tg C yr-1), partially due to extreme spatial variability in emission rates within and among reservoirs. Spatial heterogeneity in the availability of organic matter (OM) for biological CH4 production by methanogenic archaea may be an important contributor to this variation. To explore this, we measured sediment CH4 potential production rates, OM source and quantity, and methanogen community composition at fifteen sites within a eutrophic reservoir in Ohio, USA. CH4 production rates were highest in the riverine portion of the reservoir near the main inlet. This pattern persisted even when rates were normalized to OM quantity, indicating that OM was more readily utilized by methanogens in the riverine zone. Sediment stable isotopes and C:N indicated a greater proportion of terrestrial OM in the bulk sediment of this zone. Methanogens were present at all sites, and while taxa were similar across zones, the riverine zone contained a higher relative abundance of methanogens capable of acetoclastic and methylotrophic methanogenesis, likely reflecting differences in decomposition processes or OM quality. While we found that methane production rates were negatively correlated with algal-derived carbon in bulk sediment OM, production rates were positively correlated with indicators of algal-derived carbon in the porewater dissolved OM. It is likely that both dissolved and bulk OM affect CH4 production rates, and that both terrestrial and aquatic OM sources are important in the riverine methane production hotspot. 




### Overview

	project
	|- README          # the top level description of content (this doc)
	|- LICENSE         # the license for this project
	|
	|- data           # raw and primary data, are not changed once created
	| |- references/  # reference files to be used in analysis
	| |- raw/         # raw data, will not be altered
	| |- mothur/      # mothur processed data
	| +- process/     # cleaned data, will not be altered once created;
	|                 # will be committed to repo
	|
	|- code/          # any programmatic code
	|
	|- results        # all output from workflows and analyses
	| |- tables/      # xlsx version of tables generated with scripts, including SI
	| |- figures/     # figures, including SI
	| +- pictures/    # diagrams, images, and other non-graph graphics
	|
	+- Makefile       # executable Makefile for this study, if applicable


### How to regenerate this repository
To regenerate this repository, as well as all of the analyses, you will need to perform the following steps in sequence:
* Download the repository from GitHub. There is an R project associated with the project. Downloading this will make things easier 
* Download the data from the OSF directory. The entire file should be placed in in 'data/' path.
* Download the dependencies listed below. 

#### Dependencies and locations
* Gnu Make should be located in the user's PATH
* mothur (v1.XX.0) should be located in the user's PATH
* R (v. 3.X.X) should be located in the user's PATH
* etc.


#### Running analysis

