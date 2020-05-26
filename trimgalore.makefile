# makefile.trimgalore
#
# Library makefile to make running trimgalore simpler.
#
# Include the full path of this file in your Makefile ...
#
# Authors: dennis.amnebrink@lnu.se, adapted from daniel.lundin@lnu.se biomakefiles structure

SHELL := /bin/bash

# *** Parameters ***
# Override in your Makefile by setting a parameter *after* the row that
# includes this file, see documentation in doc/makefile.md.

FWD_ADAPTERS = -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -a ACACTCTTTCCCTACACGACGCTCTTCCGATCT -a CTCGGCATTCCTGCTGAACCGCTCTTCCGATCT -a ACACTCTTTCCCTACACGACGCTCTTCCGATCT -a AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC -a CTGTCTCTTATACACATCTGACGCTGCCGACGA

REV_ADAPTERS = -a2 AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -a2 ACACTCTTTCCCTACACGACGCTCTTCCGATCT -a2 CTCGGCATTCCTGCTGAACCGCTCTTCCGATCT -a2 ACACTCTTTCCCTACACGACGCTCTTCCGATCT -a2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -a2 CTGTCTCTTATACACATCTCCGAGCCCACGAGAC -a2 CTGTCTCTTATACACATCTGACGCTGCCGACGA

TRIMGALORE_OPTS = --paired --retain-unpaired --fastqc 


TRIMGALORE_FWD_OPTS = -e 0.1 $(FWD_ADAPTERS)

TRIMGALORE_REV_OPTS = -e 0.2 $(REV_ADAPTERS)

OUTPUT_DIR = 

# *** Internal ***

# MAKECALLTRIMGALORE is a macro that defines what will be output to the .makecall
# file, the file that records versions, file stamps, parameters etc.
#
# *Don't redefine!*
MAKECALL_VERSION     = echo "`date +"%Y%m%d %H:%M:%S"`: $@ was made with `trimgalore --version`" > $@.makecall
MAKECALL_PARAMS      = echo "	Called with parameters: fwd: $(TRIMGALORE_FWD_OPTS), rev: $(TRIMGALORE_REV_OPTS)" >> $@.makecall
MAKECALL_OPTS        = echo " Called with options $(TRIMGALORE_OPTS)" >> $@.makecall
MAKECALL_INFILES     = echo "	Input files: $^ (`ls -lL $^|tr '\n' ','`)" >> $@.makecall
MAKECALL_TRIMGALORE    = $(MAKECALL_VERSION); $(MAKECALL_PARAMS); $(MAKECALL_INFILES)

trimall: $(subst .r1.fastq.gz,.tg.r1.fastq.gz,$(filter-out $(wildcard *.tg.r1.fastq.gz),$(wildcard *.r1.fastq.gz))) $(subst .r2.fastq.gz,.tg.r2.fastq.gz,$(filter-out $(wildcard *.tg.r2.fastq.gz),$(wildcard *.r2.fastq.gz))) 

%.tg.r1.fastq.gz: %.r1.fastq.gz
	@$(MAKECALL_TRIMGALORE)
	trimgalore $< $(TRIMGALORE_FWD_OPTS) $(FWD_ADAPTERS) --fastqc

%.tg.r2.fastq.gz: %.r2.fastq.gz
	@$(MAKECALL_TRIMGALORE)
	trimgalore $< $(TRIMGALORE_REV_OPTS) $(REV_ADAPTERS) --fastqc
