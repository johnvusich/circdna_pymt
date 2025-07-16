#!/bin/bash --login
#SBATCH --job-name=fetchngs_pymt
#SBATCH --time=3:59:00
#SBATCH --mem=4GB
#SBATCH --cpus-per-task=1
#SBATCH --output=fetchngs_pymt-%j.out

# Load Nextflow
module purge
module load Nextflow

# Define the samplesheet, outdir, workdir, and config
SAMPLESHEET="$SCRATCH/circdna_pymt/ids.csv" 
OUTDIR="$SCRATCH/circdna_pymt/fetchngs_results" 
WORKDIR="$SCRATCH/circdna_pymt_work"
CONFIG="$SCRATCH/circdna_pymt/icer.config"

# Run the pipeline
nextflow pull nf-core/fetchngs
nextflow run nf-core/fetchngs -r 1.12.0 -profile singularity -work-dir $WORKDIR -resume \
--input $SAMPLESHEET \
--outdir $OUTDIR \
--download_method 'sratools' \
-c $CONFIG
