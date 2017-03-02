#!/usr/env/bin Rscript

# Shashwat Deepali Nagar, 2017
# Jordan Lab, Georgia Tech

# Script for visualizing an aggregation of FastQC results.
# Simply plugin the results obtained after running fastQC_parser.py

rawRead_file <- "rawReads.txt"
option1_file <- "option1.txt"
option2_file <- "option2.txt"

# Read in Raw Reads
rawReads <- read.table(rawRead_file, sep = "\t", header = T)

# Read in Trimmed Reads - Option 1
option1 <- read.table(option1_file, sep = "\t", header = T)

# Read in Trimmed Reads - Option 1
option2 <- read.table(option2_file, sep = "\t", header = T)

# Changing column names
colnames(rawReads) <- c("Sample", "Parameter", "Status")
colnames(option1) <- c("Sample", "Parameter", "Status")
colnames(option2) <- c("Sample", "Parameter", "Status")

# Defining states
Status <- c("[OK]", "[WARN]", "[FAIL]")

# Defining colors
## Define them in this order:
##  ([OK], [WARN], [FAIL])
Colors <- c("#8DA0CB", "#66C2A5", "#FD8D62")

# Combine into one dataframe
gridCol <- data.frame(cbind(Status, Colors))

# Final files for visualization
final_rawReads <- merge(rawReads, gridCol)
final_option1 <- merge(option1, gridCol)
final_option2 <- merge(option2, gridCol)

# Creating PDF files
pdf("rawReads_fastQCresults.pdf")
ggplot(final_rawReads, aes(Parameter, Sample)) + geom_tile(fill = final_rawReads$Colors) + theme(axis.text=element_text(size = 12), axis.title = element_text(size = 13), axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(hjust = 0.5)) + labs(title = "FastQC Results - Raw Reads", x = "Parameters", y = "Reads")
dev.off()

pdf("trimmed1_fastQCresults.pdf")
ggplot(final_option1, aes(Parameter, Sample)) + geom_tile(fill = final_option1$Colors) + theme(axis.text=element_text(size = 12), axis.title = element_text(size = 13), axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(hjust = 0.5)) + labs(title = "FastQC Results - 5' Clip:18; 3' Clip:5; Length Cut-Off:100", x = "Parameters", y = "Reads")
dev.off()

pdf("trimmed2_fastQCresults.pdf")
ggplot(final_option2, aes(Parameter, Sample)) + geom_tile(fill = final_option2$Colors) + theme(axis.text=element_text(size = 12), axis.title = element_text(size = 13), axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(hjust = 0.5)) + labs(title = "FastQC Results - 5' Clip:18; 3' Clip:5; Length Cut-Off:75", x = "Parameters", y = "Reads")
dev.off()
