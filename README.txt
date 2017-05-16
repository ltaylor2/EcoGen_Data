L. Taylor
May 15, 2017
Ecological Genetics Data Project

Hi Vlad!

This scripts allows for: 
1. Re-formatting of the EcoGen dataproject data file into genepop input
2. Analysis of that microsatellite data

First, save the excel spreadsheet as a .csv file in the Data/ folder
(done already, including changing some spacing and site label issues)

Then, run data_pull.R ("source('Scripts/data_pull.R')") to reformat data
Then, run analysis.R ("source('Scripts/analysis.R')") to produce stats objects and print pairwise Fst figure

Required packages (use "install.packages('package_name')")
	diveRsity
	ggplot2   

