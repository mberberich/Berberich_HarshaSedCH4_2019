### Build Figure 6
### Heatmap of methanogen genera among zones
### Megan Berberich, University of Cincinnati

## load packages
library(ampvis)
library(readr)

## read in data
sample_otus <- read_csv("data/process/methanogens/sample.otus.may.only.csv")
otu_taxonomy <- read_csv("data/process/methanogens/otu.taxonomy.cleaned.csv")
sample_variables <- read_csv("data/process/methanogens/sample.variables.may.only.csv")


## otu_table: OTUs OF SAMPLES ##
# 1. make the first row of the data frame have OTU's as rownames 
rownames(`sample_otus`) <- `sample_otus`$X1  #my file was called 'sample otus'
`sample_otus`$X1 <- NULL
# 2. convert data frame to numeric matrix 
otumat.num <- data.matrix(`sample_otus`, rownames.force = TRUE)
# 3. make otu table in phyloseq 
OTU = otu_table(otumat.num, taxa_are_rows = TRUE)

## tax_table: OTU TAXONOMY ##
# 1. make the first row of the data frame have OTU's as rownames 
rownames(`otu_taxonomy`) <- `otu_taxonomy`$OTU   #my file was called 'otu taxonomy'
`otu_taxonomy`$OTU <- NULL
# 2. remove OTU counts - NOTE: DID THIS IN EXCEL PRIOR TO READING IN FILE
#`otu taxonomy`$Size <- NULL
# 3. convert data frame to matrix 
taxmat <- as.matrix(`otu_taxonomy`)
# 4. make tax table in phyloseq 
TAX = tax_table(taxmat)

## sample_data: INCLUDE SAMPLE DATA (VARIABLES) #
# NOTE: samples names must exactly match those in the OTU table 
# 1. had to create an excel doc saved as .csv with information about the samples
# 2. uploaded sample data (sample_variables) and then had to manipulate row names to get OTUs in first column
rownames(sample_variables) <- sample_variables$X1
sample_variables$X1 <- NULL
# 3. create sample_data construct - NOTE: this is not yet part of the phyloseq object
sampledata = sample_data(sample_variables)

## create phyloseq object ##
physeq = phyloseq(OTU, TAX, sampledata)


## Create object with relative abundances
#physeq_n <- transform_sample_counts(physeq, function(x) x / sum(x) * 100)

## Can subset data so that we have phyloseq objects of each order
# Note that to make heatmaps of these we need to normalize the sample counts. can either normalize by total archaea, or just that sample, or by total methanogens if we use the physeq_methanogens 
physeq_O_bacteriales <- subset_taxa(physeq, Order == "Methanobacteriales")
physeq_O_microbiales <- subset_taxa(physeq, Order == "Methanomicrobiales")
physeq_O_cellales <- subset_taxa(physeq, Order == "Methanocellales")
physeq_O_sarcinales <- subset_taxa(physeq, Order == "Methanosarcinales")
physeq_O_microbia_unclassified <- subset_taxa(physeq, Order == "Methanomicrobia_unclassified")

## Now make phloseq object of just methanogens
physeq_meth <- merge_phyloseq(physeq_O_bacteriales, physeq_O_microbiales, physeq_O_cellales, physeq_O_sarcinales)
physeq_meth_n <- transform_sample_counts(physeq_meth, function(x) x / sum(x) * 100)

## Plot the most 20 abundant genera in methanogens - percentages are percent of total methanogens and are averages of all samples in eac group
heatmap.genus <- amp_heatmap(data = physeq_meth_n,
            tax.aggregate = "Genus",
            scale.seq = 100,
            group = "site.zone",
            tax.show = 15,
            tax.add = "Order",
            plot.na = T,
            plot.theme = "clean",
            color.vector = c("white", "lightskyblue4"),
            plot.colorscale = "sqrt") +
  scale_x_discrete(limits = c("riverine", "transitional", "lacustrine"))


ggsave(file = "results/figures/figure6_methanogen_heatmap_genus.pdf", heatmap.genus, 
       width=6, height = 4, dpi = 1200)

rm(list = c('sample_otus', 'sample_variables', 'otu_taxonomy', 'otumat.num','sampledata', 'taxmat', 'heatmap.genus', 'OTU', 'physeq', 'physeq_meth', 'physeq_meth_n', 'physeq_O_bacteriales', 'physeq_O_cellales', 'physeq_O_microbia_unclassified', 'physeq_O_microbiales', 'physeq_O_sarcinales', 'TAX'))
