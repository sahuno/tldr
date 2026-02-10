# tldr Snakemake Workflow

A Snakemake workflow for detecting transposable element insertions from long-read sequencing data using **tldr** (Transposons from Long DNA Reads).

This workflow uses Singularity/Apptainer containers for reproducible execution.

## Features

- 🔄 Parallel processing of multiple samples
- 📦 Containerized execution (Singularity/Apptainer)
- 📊 Automatic result merging and summary statistics
- 🎯 Flexible configuration via YAML
- 📈 Resource management and job scheduling

## Quick Start

### 1. Prerequisites

```bash
# Required
- Snakemake (>= 7.0)
- Singularity or Apptainer
- Python (>= 3.8)

# Install Snakemake
conda install -c conda-forge -c bioconda snakemake

# Or with pip
pip install snakemake
```

### 2. Setup Workflow

```bash
cd workflows/snakemake_wf

# Edit samples.tsv with your sample information
# Format: sample<TAB>bam_path
vim samples.tsv

# Edit config.yaml with your settings
vim config.yaml
```

### 3. Run Workflow

```bash
# Dry run to check workflow
snakemake -n --use-singularity

# Run with 8 cores
snakemake --use-singularity --cores 8

# Run on a cluster (SLURM example)
snakemake --use-singularity --profile profiles/slurm --jobs 20
```

## Configuration

### samples.tsv

Tab-separated file listing samples and their BAM files:

```tsv
sample	bam
sample1	/path/to/sample1.bam
sample2	/path/to/sample2.bam
sample3	/path/to/sample3.bam
```

**Requirements:**
- BAM files must be aligned to a reference genome
- BAM files must be indexed (`.bai` files in same directory)
- Use full absolute paths

### config.yaml

Main configuration file with the following sections:

#### Reference Files

```yaml
# Reference genome (must be indexed with samtools faidx)
reference_genome: "/path/to/hg38.fa"

# TE reference (built into container)
te_reference: "/opt/tldr/ref/teref.ont.human.fa"

# Optional: Known non-reference insertions
nonref_collection: "/opt/tldr/ref/nonref.collection.hg38.chr.bed.gz"
```

#### Container

```yaml
# Docker image (automatically converted to Singularity)
container: "docker://sahuno/tldr:latest"
```

#### Resources

```yaml
threads: 4          # Threads per job
memory_mb: 16000    # Memory per job (MB)
runtime_min: 240    # Max runtime per job (minutes)
```

#### tldr Parameters

```yaml
# Additional tldr options
tldr_params: "--minreads 3 --strict"
```

## Output Structure

```
results/
├── sample1/
│   ├── sample1.table.txt          # Main results table
│   ├── sample1.tldr.log           # Log file
│   └── chrN.pickle                # Intermediate files
├── sample2/
│   └── ...
├── summary/
│   ├── all_samples.merged.txt     # All samples merged
│   ├── summary_stats.txt          # Summary statistics
│   └── insertion_counts_per_sample.txt
└── logs/
    ├── sample1.tldr.log
    └── sample2.tldr.log
```

## Workflow Rules

### Main Rules

- **`tldr_detect`**: Run tldr on each sample
- **`merge_results`**: Merge all sample results
- **`summary_stats`**: Generate summary statistics

### Utility Rules

- **`index_bam`**: Auto-index BAM files if needed
- **`clean`**: Remove output directory

## Advanced Usage

### Run Specific Samples

```bash
# Run only sample1
snakemake --use-singularity results/sample1/sample1.table.txt

# Run samples 1 and 2
snakemake --use-singularity \
    results/sample1/sample1.table.txt \
    results/sample2/sample2.table.txt
```

### Custom tldr Parameters

Edit `config.yaml`:

```yaml
tldr_params: >
  --minreads 5
  --min_te_len 300
  --max_te_len 8000
  --detail_output
  --strict
```

### Using Different References

```yaml
# For mouse samples
te_reference: "/opt/tldr/ref/teref.mouse.fa"
reference_genome: "/path/to/mm10.fa"
nonref_collection: "/opt/tldr/ref/nonref.collection.mm10.chr.bed.gz"
```

### Resource Optimization

For large datasets:

```yaml
threads: 8           # More threads per job
memory_mb: 32000     # More memory
```

For quick testing:

```yaml
threads: 2
memory_mb: 8000
```

## Cluster Execution

### SLURM Example

Create `profiles/slurm/config.yaml`:

```yaml
cluster: "sbatch -p {resources.partition} -t {resources.runtime} --mem={resources.mem_mb} -c {threads}"
jobs: 20
use-singularity: true
singularity-args: "--bind /scratch,/data"
```

Run:

```bash
snakemake --profile profiles/slurm
```

### SGE Example

```bash
snakemake --use-singularity \
    --cluster "qsub -pe smp {threads} -l mem_free={resources.mem_mb}M" \
    --jobs 20
```

## Singularity/Apptainer Notes

### Automatic Container Pull

Snakemake will automatically:
1. Pull the Docker image from DockerHub
2. Convert it to Singularity format
3. Cache it for future runs

### Manual Pull (Optional)

```bash
# Pull and convert manually
singularity pull docker://sahuno/tldr:latest

# Use local image in config.yaml
container: "tldr_latest.sif"
```

### Bind Paths

If your data is on different mounts, add bind paths:

```bash
snakemake --use-singularity \
    --singularity-args "--bind /scratch,/data,/project" \
    --cores 8
```

## Troubleshooting

### BAM Index Missing

```bash
# The workflow will auto-create .bai files
# Or manually index:
samtools index sample.bam
```

### Container Pull Fails

```bash
# Pull manually
singularity pull docker://sahuno/tldr:latest

# Update config to use local file
container: "/path/to/tldr_latest.sif"
```

### Permission Issues

```bash
# Make sure Singularity can access your files
chmod -R 755 /path/to/data
```

### Out of Memory

Increase memory in `config.yaml`:

```yaml
memory_mb: 32000  # or higher
```

## References

- **tldr**: [github.com/adamewing/tldr](https://github.com/adamewing/tldr)
- **Snakemake**: [snakemake.readthedocs.io](https://snakemake.readthedocs.io)
- **Singularity**: [sylabs.io/docs](https://sylabs.io/docs/)

## Citation

If you use this workflow, please cite:

**tldr:**
> Ewing AD, et al. Nanopore sequencing of long-read transposon sequencing. *Molecular Cell* (2020)

**Snakemake:**
> Mölder F, et al. Sustainable data analysis with Snakemake. *F1000Research* (2021)
