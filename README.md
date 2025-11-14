# circdna_pymt
Scripts for identification of ecDNA in MMTV-PyMT mouse model of breast cancer

The analysis leverages the [nf-core/circdna](https://nf-co.re/circdna) pipeline and downstream tools including AmpliconArchitect, CycleViz, and AmpliconReconstructor.

## Repository Structure

```bash
circdna_pymt/
├── fetchngs_results/         # Metadata and samplesheet and raw data
│   ├── fastq/
│   ├── metadata/
│   └── samplesheet/
├── mosek_license_dir/        # MOSEK license required for AmpliconArchitect
│   └── mosek.lic
├── results/                  # Output from pipeline (e.g., sv_view images)
│   └── ampliconsuite/
├── data_repo/                # Reference data required by AmpliconArchitect (for mm10)
├── run_circdna.sh            # Script to run nf-core/circdna
├── run_fetchngs.sh           # Script to fetch raw fastq files via nf-core/fetchngs
├── icer.config               # Custom config for running on MSU HPCC
├── ids.csv                   # List of run accessions (e.g., SRX IDs)
├── LICENSE
├── README.md
```

## Requirements

- [Nextflow](https://www.nextflow.io/) >= 22.10.1
- [nf-core/fetchngs](https://nf-co.re/fetchngs) and [nf-core/circdna](https://nf-co.re/circdna)
- Singularity (or Docker)
- MOSEK license for AmpliconArchitect
- Reference genome repository for AmpliconArchitect (see below)
- Access to HPC with SLURM (configured in `icer.config`)

## Installation

Clone this repo:

```bash
git clone https://github.com/johnvusich/circdna_pymt.git
cd circdna_pymt
```

## Getting a MOSEK Academic License

AmpliconArchitect requires a MOSEK license. Academic users can request a free license as follows:

1. Visit the [MOSEK license request page](https://www.mosek.com/products/academic-licenses/).
2. Fill out the form using your academic email address.
3. Once approved, download the license file (typically named `mosek.lic`).
4. Place the file in the following path in your local setup:

```bash
circdna_pymt/mosek_license_dir/mosek.lic
```

Ensure the path is correctly passed to the `--mosek_license_dir` parameter in the pipeline script.

## Setting up `data_repo` for AmpliconArchitect (mm10)

AmpliconArchitect requires a structured reference data repository to function. In this analysis, the repository is set up at:

```
$SCRATCH/circdna_pymt/data_repo
```

To set this up exactly as used in the pipeline, run the following script:

```bash
bash setup_data_repo.sh
```

This script will:

- Create the expected `data_repo` directory
- Download the `mm10.tar.gz` reference bundle
- Unpack it with proper permissions
- Set the `AA_DATA_REPO` environment variable (used by the pipeline)

### Final Directory Structure Example

```bash
circdna_pymt/data_repo
├── coverage.stats
├── mm10
│   ├── annotations
│   │   ├── gencode.vM10.basic.annotation_genes.gff
│   │   └── mm10GenomicSuperDup.tab
│   ├── cancer
│   │   ├── oncogene_list.txt
│   │   └── oncogenes
│   │       ├── AC_oncogene_set_mm10.gff
│   │       └── mm10_consensus_oncogenes_list_from_hg19.gff
│   ├── dummy_ploidy.vcf
│   ├── file_list.txt
│   ├── file_sources.txt
│   ├── last_updated.txt
│   ├── mm10-blacklist.v2.bed
│   ├── mm10_centromere.bed
│   ├── mm10_cnvkit_filtered_ref.cnn
│   ├── mm10_conserved_gain5.bed
│   ├── mm10_conserved_gain5_onco_subtract.bed
│   ├── mm10.fa
│   ├── mm10.fa.fai
│   ├── mm10.Hardison.Excludable.full.bed
│   ├── mm10_k35.mappability.bedgraph
│   ├── mm10_merged_centromeres_conserved_sorted.bed
│   ├── mm10_noAlt.fa.fai
│   └── onco_bed.bed
├── mm10.tar.gz
```

Make sure `data_repo` is accessible by the pipeline or container environment and define its path when running AmpliconArchitect manually, or ensure the environment is configured to detect it.

## Step-by-Step Workflow

### 1. Fetch Raw Sequencing Data

Use `run_fetchngs.sh` to download data from SRA using the IDs listed in `ids.csv`.

```bash
sbatch run_fetchngs.sh
```

Edit `samplesheet.csv` and `multiqc_config.yml` as needed in `fetchngs_results/samplesheet/`.

### 2. Run nf-core/circdna

Use `run_circdna.sh` to launch the circular DNA analysis pipeline with AmpliconArchitect.

```bash
sbatch run_circdna.sh
```

This script uses `icer.config` for cluster-specific settings on the MSU HPCC.

### 3. Downstream Analysis

- **CycleViz** and **AmpliconReconstructor** can be run using output files from AmpliconArchitect.
- Visual outputs (e.g., `.png` files) are stored in `results/ampliconsuite/ampliconarchitect/sv_view`.

## Example Output

## Citation

If you use this code, please cite:

- [nf-core/circdna pipeline](https://nf-co.re/circdna/1.1.0/#citations)
- [AmpliconSuite-pipeline](https://github.com/AmpliconSuite/AmpliconSuite-pipeline/blob/master/CITATIONS.md)
- [CNVKit](https://doi.org/10.1371/journal.pcbi.1004873)

## License

MIT License – see the [LICENSE](./LICENSE) file for details.
