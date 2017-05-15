require("diveRsity")

stats <- basicStats(infile="genepop_input.txt", outfile="HWE_output.txt")
divStats <- diffCalc(infile="genepop_input.txt", outfile="FST_output.txt", fst=TRUE, pairwise=TRUE)
hw <- divBasic(infile="genepop_input.txt", outfile="FST_output.txt", HWEexact=TRUE, mcRep=10000, bootstraps=1000)


hwTest <- hw$HWE
fis <- hw$fis
pairwise <- divStats$pairwise$Fst

require(plyr)

colnames(pairwise) <- sub("_.*", "", colnames(pairwise))
rownames(pairwise) <- sub("_.*", "", rownames(pairwise))

pairwise <- as.data.frame(pairwise)

pairwise <- ldply(1:nrow(pairwise),
function(r) {
	site <- c()
	pair <- c()
	value <- c()
	for (c in 1:ncol(pairwise)) {
		site <- append(site, rownames(pairwise)[r])
		pair <- append(pair, colnames(pairwise)[c])
		value <- append(value, pairwise[r,c])
	}
	return(data.frame(site=site, pair=pair, value=value))
})

require(ggplot2)
fst <- ggplot() +
	geom_tile(data=pairwise[!is.na(pairwise$value),], aes(x=pair, y=site, fill=value)) +
	geom_text(data=pairwise[!is.na(pairwise$value),], aes(x=pair, y=site, label=round(value, 2)), colour="black", family="Arial") +
	scale_y_discrete(limits=c("Site10", "Site9", "Site8", "Site7", "Site6", "Site5", "Site4", "Site3", "Site2"),
					 labels=c("Site 10", "Site 9", "Site 8", "Site 7", "Site 6", "Site 5", "Site 4", "Site 3", "Site 2")) +
	scale_x_discrete(limits=c("Site1", "Site2", "Site3", "Site4", "Site5", "Site6", "Site7", "Site8", "Site9"),
					 labels=c("Site 1", "Site 2", "Site 3", "Site 4", "Site 5", "Site 6", "Site 7", "Site 8", "Site 9"),
					 position="top") +
	scale_fill_gradient(low="light gray", high="red") +
	xlab("") +
	ylab("") +
	guides(fill=FALSE) +
	theme(panel.grid=element_blank(), panel.background=element_rect(fill="white"),
		  axis.text=element_text(family="Arial", size=12), axis.ticks=element_blank())

ggsave("fst_table.png", fst, width=6, height=6)

migrate <- divMigrate(infile="genepop_input.txt", plot_network=TRUE)