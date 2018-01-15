# Mutation Annotation Format
maf.version <- "2.4.1";

maf.req.fields <- c(
"Hugo_Symbol",
"Entrez_Gene_Id",
"Center",
"NCBI_Build",
#hg18, hg19, GRCh37, GRCh37-lite, 36, 36.1, 37,
"Chromosome",
#number without "chr" prefix that contains the gene.
#X, Y, M, 1, 2, etc.
"Start_Position",
#Lowest numeric position of the reported variant on the genomic reference sequence. Mutation start coordinate (1-based coordinate system).
"End_Position",
#Highest numeric genomic position of the reported variant on the genomic reference sequence. Mutation end coordinate (inclusive, 1-based coordinate system).
"Strand",
#+
"Variant_Classification",
#Frame_Shift_Del, Frame_Shift_Ins, In_Frame_Del, In_Frame_Ins, Missense_Mutation, Nonsense_Mutation, Silent, Splice_Site, Translation_Start_Site, Nonstop_Mutation, 3'UTR, 3'Flank, 5'UTR, 5'Flank, IGR , Intron, RNA, Targeted_Region
#Added: De_novo_Start_OutOfFrame, Start_Codon_SNP, lncRNA
"Variant_Type",
#Type of mutation. TNP (tri-nucleotide polymorphism) is analogous to DNP but for 3 consecutive nucleotides. ONP (oligo-nucleotide polymorphism) is analogous to TNP but for consecutive runs of 4 or more.
#SNP, DNP, TNP, ONP, INS, DEL, or Consolidated
"Reference_Allele",
#The plus strand reference allele at this position. Include the sequence deleted for a deletion, or "-" for an insertion.
#A,C,G,T and/or -
"Tumor_Seq_Allele1",
#Primary data genotype. Tumor sequencing (discovery) allele 1. " -" for a deletion represent a variant. "-" for an insertion represents wild-type allele. Novel inserted sequence for insertion should not include flanking reference bases.
#A,C,G,T and/or -
"Tumor_Seq_Allele2",
#A,C,G,T and/or -
"dbSNP_RS",
#Latest dbSNP rs ID (dbSNP_ID) or "novel" if there is no dbSNP record. source: http://ncbi.nlm.nih.gov/projects/SNP/
#Set or "novel"
"dbSNP_Val_Status",
#by1000genomes;by2Hit2Allele; byCluster; byFrequency; byHapMap; byOtherPop; bySubmitter; alternate_allele3 Note that "none" will no longer be an acceptable value.
"Tumor_Sample_Barcode",
#BCR aliquot barcode for the tumor sample including the two additional fields indicating plate and well position. i.e. TCGA-SiteID-PatientID-SampleID-PortionID-PlateID-CenterID. The full TCGA Aliquot ID.
"Matched_Norm_Sample_Barcode",
#BCR aliquot barcode for the matched normal sample including the two additional fields indicating plate and well position. i.e. TCGA-SiteID-PatientID-SampleID-PortionID-PlateID-CenterID. The full TCGA Aliquot ID; e.g. TCGA-02-0021-10A-01D-0002-04 (compare portion ID '10A' normal sample, to '01A' tumor sample).
"Match_Norm_Seq_Allele1",
#Primary data. Matched normal sequencing allele 1. "-" for deletions; novel inserted sequence for INS not including flanking reference bases.
#A,C,G,T and/or -
"Match_Norm_Seq_Allele2",
#Primary data. Matched normal sequencing allele 2. "-" for deletions; novel inserted sequence for INS not including flanking reference bases.
#A,C,G,T and/or -
"Tumor_Validation_Allele1",
#Secondary data from orthogonal technology. Tumor genotyping (validation) for allele 1. "-" for deletions; novel inserted sequence for INS not including flanking reference bases.
#A,C,G,T and/or -
"Tumor_Validation_Allele2",
#Secondary data from orthogonal technology. Tumor genotyping (validation) for allele 2. "-" for deletions; novel inserted sequence for INS not including flanking reference bases.
#A,C,G,T and/or -
"Match_Norm_Validation_Allele1",
#Secondary data from orthogonal technology. Matched normal genotyping (validation) for allele 1. "-" for deletions; novel inserted sequence for INS not including flanking reference bases.
#A,C,G,T and/or -
"Match_Norm_Validation_Allele2",
#Secondary data from orthogonal technology. Matched normal genotyping (validation) for allele 2. "-" for deletions; novel inserted sequence for INS not including flanking reference bases.
#A,C,G,T and/or -
"Verification_Status",
#Second pass results from independent attempt using same methods as primary data source. Generally reserved for 3730 Sanger Sequencing.
#Verified, Unknown
"Validation_Status",
#Second pass results from orthogonal technology.
#Untested, Inconclusive, Valid, Invalid
"Mutation_Status",
#Updated to reflect validation or verification status and to be in agreement with the VCF VLS field. The values allowed in this field are constrained by the value in the Validation_Status field.
# Inconclusive: None, Germline, Somatic, LOH, Post-transcriptional
# modification, Unknown
# Invalid: None
# Untested: None, Germline, Somatic, LOH, Post-transcriptional modification, Unknown
# Valid: Germline, Somatic, LOH, Post-transcriptional modification, Unknown
"Sequencing_Phase",
#Phase_I
"Sequence_Source",
#WGS
#WGA
#WXS
#RNA-Seq
#miRNA-Seq
#Bisulfite-Seq
#VALIDATION
#Other
#ncRNA-Seq
#WCS
#CLONE
#POOLCLONE
#AMPLICON
#CLONEEND
#FINISHING
#ChIP-Seq
#MNase-Seq
#DNase-Hypersensitivity
#EST
#FL-cDNA
#CTS
#MRE-Seq
#MeDIP-Seq
#MBD-Seq
#Tn-Seq
#FAIRE-seq
#SELEX
#RIP-Seq
#ChIA-PET
"Validation_Method",
#If Validation_Status = Untested then "none" If Validation_Status = Valid or Invalid, then not "none" (case insensitive)
"Score",
#Not in use.
"BAM_File",
#Not in use.
"Sequencer",
#Illumina GAIIx
#Illumina HiSeq
#SOLID
#454
#ABI 3730xl
#Ion Torrent PGM
#Ion Torrent Proton
#PacBio RS
#Illumina MiSeq
#Illumina HiSeq 2500
#454 GS FLX Titanium
#AB SOLiD 4 System
"Tumor_Sample_UUID",
#e.g. 550e8400-e29b-41d4-a716-446655440000
"Matched_Norm_Sample_UUID"
#e.g. 567e8487-e29b-32d4-a716-446655443246
);
maf.req.fields.lower <- tolower(maf.req.fields);


# Can be NULL:
maf.nullable.fields <- c(
	"dbSNP_RS",
	"dbSNP_Val_Status",
	"Match_Norm_Seq_Allele1",
	"Match_Norm_Seq_Allele2",
	"Tumor_Validation_Allele1",
	"Tumor_Validation_Allele2",
	"Match_Norm_Validation_Allele1",
	"Match_Norm_Validation_Allele2",
	"Verification_Status",
	"Sequencing_Phase",
	"Score",
	"BAM_File"
);
# All other fields cannot be NULL
maf.nullable.fields.lower <- tolower(maf.nullable.fields);

maf_conform <- function(x) {

	# check that all required MAF columns are present (case insensitive check)
	fields.lower <- tolower(colnames(x));
	stopifnot(maf.req.fields.lower %in% fields.lower);

	# put standard MAF columns first in order
	x <- x[,
		c(match(maf.req.fields.lower, fields.lower),
			which(! fields.lower %in%	maf.req.fields.lower))
	];
	# ensure that case is correct
	colnames(x)[1:length(maf.req.fields)] <- maf.req.fields;

	# check that coordinates are 1-based
	stopifnot(with(x[x$Variant_Type == "SNP", ], Start_Position == End_Position));

	# check that non-nullable fields are not null
	for (i in which(! maf.req.fields %in% maf.nullable.fields)) {
		z <- x[,i];
		if (any(is.na(z))) {
			stop("Field is not compliant: ", colnames(x)[i]);
		}
	}

	# TODO check valid values for other fields

	# convert variants on - strand, if any
	neg.strand <- which(x$Strand == "-");
	if (length(neg.strand) > 0) {
		stop("As per MAF specification, all SNVs must be reported on the + strand");
		
		# experimental code for converting strand:

		# ensure that Start_position < End_position for non-single variants
		idx <- which(x$Strand == "-" & x$Variant_Type != "SNP");
		start.pos <- x$Start_position[idx];
		end.pos <- x$End_position[idx];
		x$Start_position[idx] <- pmin(start.pos, end.pos);
		x$End_position[idx] <- pmax(start.pos, end.pos);

		# TODO reverse complement all allele sequences
		# Reference_Allele
		# Tumor_Seq_Allele1
		# Tumor_Seq_Allele2
		# Match_Norm_Seq_Allele1
		# Match_Norm_Seq_Allele2
		# Tumor_Validation_Allele1
		# Tumor_Validation_Allele2
		# Match_Norm_Validation_Allele1
		# Match_Norm_Validation_Allele2
		# warning that additional fields may not be correct!
	}

	# convert fields with controlled vocabular to factors

	x$Variant_Classification <- factor(x$Variant_Classification
		#,
		#levels = c(
		#	"Frame_Shift_Del", "Frame_Shift_Ins", "In_Frame_Del", "In_Frame_Ins",
		# 	"Missense_Mutation", "Nonsense_Mutation", "Silent", "Splice_Site",
		# 	"Translation_Start_Site", "Nonstop_Mutation", "3'UTR", "3'Flank", 
		#	"5'UTR", "5'Flank", "IGR" , "Intron", "RNA", "Targeted_Region",
		#	"De_novo_Start_OutOfFrame", "Start_Codon_SNP", "lincRNA"
		#)
	);

	x$Variant_Type <- factor(x$Variant_Type,
		levels = c("SNP", "DNP", "TNP", "ONP", "INS", "DEL", "Consolidated")
	);

	x$Verification_Status <- factor(x$Verification_Status,
		levels = c("Unknown", "Verified")
	);

	x$Validation_Status <- factor(x$Validation_Status,
		levels = c("Untested", "Inconclusive", "Invalid", "Valid")
	);

	x$Mutation_Status <- factor(x$Mutation_Status,
		levels = c("Unknown", "None", "Germline", "Somatic", "LOH", "Post-transcriptional modification")
	);

	# optimize the data.frame by converting select factor fields to factors
	factor.fields <- c("Center", "Tumor_Sample_Barcode",
		"Matched_Norm_Sample_Barcode", "Tumor_Sample_UUID", 
		"Matched_Norm_Sample_UUID", "Sequencing_Phase", "Sequence_Source",
		"Validation_Method", "Sequencer"
	);
	for (field in factor.fields) {
		x[, field] <- factor(x[, field]);
	}

	x
}

#' @method qread maf
#' @export
qread.maf <- function(file, type, conform=TRUE, ...) {
	x <- read.table(file,
		sep="\t", header=TRUE,
		row.names=NULL, stringsAsFactors=FALSE,
		check.names=FALSE, na.strings=c("NA", "---"),
		blank.lines.skip=TRUE, comment.char="#", quote="");

	if (conform) {
		x <- maf_conform(x);
		attr(x, "format") <- "maf";
		attr(x, "version") <- maf.version;
	}

	x
}

#' @method qwrite maf
#' @export
qwrite.maf <- function(x, file, type, ...) {
	if (is.null(attr(x, "format"))) {
		warning("`x` has no `format` attribute: x may not be in maf format");
	} else if (attr(x, "format") != "maf") {
		stop("`attr(x, \"format\")` indicates that `x` is not in maf format");
	}

	x <- maf_conform(x);

	cat(sprintf("#version %s\n", attr(x, "version")), file=file);
	suppressWarnings(
		write.table(x, file,
			quote=FALSE, sep="\t", row.names=FALSE, col.names=TRUE, append=TRUE, ...)
	)
}
