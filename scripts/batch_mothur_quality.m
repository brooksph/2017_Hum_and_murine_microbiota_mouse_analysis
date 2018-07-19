#Author: Phillip Brooks 
#Affiliation: UC Davis Lab for Data Intensive Biology
#Date: Tue Jan 16 2018

##############
#
# This is a batch file for running through the quality filtering steps of mothur
#
# We will make use of the 'current' settings, so we don't have to type out the whole 
# file names in each step. This also reduces typo errors and ensures you're using
# the file that was created from the previous step.
#
# This example uses the steps in the Schloss MiSeq SOP
# http://www.mothur.org/wiki/MiSeq_SOP
# 
##############

cd ../MC58_fastq/

# Make contigs
# Join the paired ends
make.contigs(file=Humanized_C57BL6.stability.files, processors=20)

summary.seqs(fasta=stability.trim.contigs.fasta)

# Screen seqs
# Get rid of sequences that are the wrong length or have ambiguous base pairs.
# We're limiting the length to 275 because we expect our sequences to be about 251 bp
# and this gives some flexibility
screen.seqs(fasta=stability.trim.contigs.fasta, group=stability.contigs.groups, summary=stability.trim.contigs.summary, maxambig=0, maxlength=275)

summary.seqs(fasta=current)

# Get only the unique sequences
# This reduces our data set size for further processing
# No sequences are lost during this step. We're just generating a FASTA file of the unique
# sequences and keeping track of their numbers in each sample in a different file.
unique.seqs(fasta=current)

# Simplify the names and groups files 
count.seqs(name=current, group=current)

summary.seqs(count=stability.trim.contigs.good.count_table)

pcr.seqs(fasta=silva.bacteria.fasta, start=11894, end=25319, keepdots=F, processors=8)

system(mv silva.bacteria.pcr.fasta silva.v4.fasta)

summary.seqs(fasta=silva.v4.fasta)

# Align our sequences to that reference
# This is one of the most computationally intensive steps in this file
align.seqs(fasta=current, reference=silva.v4.fasta)

# Summarize the alignment information
# We'll need the output of this in the next step
summary.seqs(fasta=current, count=current)

# Get rid of sequences that don't align well
screen.seqs(fasta=current, count=current, summary=current, start=1968, end=11550, maxhomop=8)

# To reduce dataset size, get rid of columns with no information
# Get rid of columns in the file that only contain gaps '-' or overhang '.'
filter.seqs(fasta=current, vertical=T, trump=.)

# Now that we've aligned the sequences, we might see more that are identical
# Pare the dataset down to just the unique aligned ones
unique.seqs(fasta=current, count=current)

# Pre-cluster to reduce dataset size
pre.cluster(fasta=current, count=current, diffs=2)

# Check for chimeras and remove them
# We're doing the chimera checking using the abundant reads as the reference
# Alternatively you could use the silva database as a reference
chimera.uchime(fasta=current, count=current, dereplicate=t)
remove.seqs(fasta=current, accnos=current)

# Classify the sequences and remove ones that aren't bacterial
# We're using the Silva training sets as references: trainset9_032013
classify.seqs(fasta=current, count=current, reference=trainset9_032012.pds.fasta, taxonomy=trainset9_032012.pds.tax, cutoff=80)
remove.lineage(fasta=current, count=current, taxonomy=current, taxon=Chloroplast-Mitochondria-unknown-Archaea-Eukaryota)

# Take out the Mock sample from the data

# Now we have a good set of quality sequences!

# Print out the last things we used so we know the last set of files generated.
get.current()

# We'll copy these to a shorter filename and use them in the next steps
# We will need the *.fasta, *.taxonomy, *.count_table files
# e.g.
# cp longfilename.fasta quality_sequences.fasta
# cp longfilename.taxonomy quality_sequences.taxonomy
# cp longfilename.count_table quality_sequences.count_table


