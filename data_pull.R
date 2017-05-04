data <- read.csv("data.csv", stringsAsFactors=FALSE)

for (c in 1:ncol(data)) {
	data[which(data[,c]=="x"), c] <- data[4,c]
	data[which(data[,c]=="NA" | is.na(data[,c])), c] <- ""
}


data[2, 18] <- "Microsatelite Z4"
data[2, 21] <- "Microsatelite Z5"

bounds <- matrix(numeric(0), ncol=5, nrow=2)

for (c in 1:ncol(data)) {

	label <- data[2,c]
	if (!is.na(label))
		if (label == "Microsatelite Z1") {
			bounds[1,1] <- c
		} else if (label == "Microsatelite Z2") {
			bounds[1,2] <- c
		} else if (label == "Microsatelite Z3") {
			bounds[1,3] <- c
		} else if (label == "Microsatelite Z4") {
			bounds[1,4] <- c
		} else if (label == "Microsatelite Z5") {
			bounds[1,5] <- c
		}
}
bounds[2,1] <- bounds[1,2] - 2
bounds[2,2] <- bounds[1,3] - 2
bounds[2,3] <- bounds[1,4] - 2
bounds[2,4] <- bounds[1,5] - 2
bounds[2,5] <- bounds[1,5] + 3

require(plyr)

micros <- ldply(5:nrow(data),
function(r) {

	currSite <- data[r,3]
	if (nchar(currSite )< 4) {
		# find the nearest filled site above
		s <- r
		hasSite <- FALSE
		while (!hasSite) {
			if (nchar(data[s,3]) > 4) {
				currSite <- data[s,3]
				hasSite <- TRUE
			}
			s <- s-1
		}
	}

	micro <- sapply(1:ncol(bounds),
			 function(c) {
				 s <- paste(data[r, bounds[1,c]:bounds[2,c]], collapse="")
				 if (nchar(s) == 3) {
					 s <- paste(s, s, sep="")
				 } else if (nchar(s) != 6 | nchar(data[r,3]) == 0) {
				 	s <- ""
				 }
				 return(s)
			 })
	return(data.frame(site=currSite, z1=micro[1], z2=micro[2], 
					  z3=micro[3], z4=micro[4], z5=micro[5], stringsAsFactors=FALSE))
})

micros <- micros[micros$z1 != "" |
				 micros$z2 != "" | 
				 micros$z3 != "" |
				 micros$z4 != "" | 
				 micros$z5 != "",]

#
# now fill in site and missing data rows
# for now simply copying the row below
#
for (r in (nrow(micros)-1):1) {
	for (c in 1:ncol(micros)) {
		if (micros[r,c] == "") {
			micros[r,c] <- micros[r+1,c]
		}
	}
}

