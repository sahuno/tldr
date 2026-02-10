# tldr Snakemake Workflow

A Snakemake workflow for detecting transposable element insertions from long-read sequencing data using **tldr** (Transposons from Long DNA Reads).

**Container-only execution** with Singularity/Apptainer for reproducible bioinformatics on SLURM clusters.

## Features

- 🐳 **Container-only execution** - No local software installation required
- 🔄 **Parallel processing** of multiple samples
- 📦 **Singularity/Apptainer** integration with automatic Docker conversion
- 🖥️ **SLURM cluster** optimized with greenbab account configuration
- 📊 **Automatic result merging** and summary statistics
- 🎯 **Flexible configuration** via YAML files
- 📈 **Resource management** with rule-specific SLURM settings

## Quick Start

### 1. Prerequisites

```bash
# On greenbab cluster:
- Snakemake (>= 8.0)
- Singularity/Apptainer
- SLURM access with greenbab account
```

### 2. Setup Sample Sheet

Edit `samples.tsv` with your samples (TSV format):

```tsv
patient	sample	condition	path	genome
patient1	sample1	control	/data1/greenbab/data/sample1.bam	hg38
patient1	sample2	case	/data1/greenbab/data/sample2.bam	hg38
patient2	sample3	control	/data1/greenbab/data/sample3.bam	hg38
```

**Columns:**
- `patient` - Patient identifier
- `sample` - Unique sample name
- `condition` - Experimental condition (control, case, etc.)
- `path` - Full path to BAM file (must be indexed with .bai)
- `genome` - Reference genome (hg19, hg38, mm10)

### 3. Configure Workflow

Edit `config.yaml`:

```yaml
# Reference genome (must match genome in samples.tsv)
reference_genome: "/data1/greenbab/references/hg38/hg38.fa"

# TE reference (inside container)
te_reference: "/opt/tldr/ref/teref.ont.human.fa"

# Optional: non-reference collection
nonref_collection: "/opt/tldr/ref/nonref.collection.hg38.chr.bed.gz"

# Container
container: "docker://sahuno/tldr:latest"

# SLURM settings
slurm_account: "greenbab"
slurm_partition: "componc_cpu"
```

### 4. Run Workflow

```bash
cd workflows/snakemake_wf

# Full SLURM configuration (recommended)
./run_workflow.sh slurmConfig

# Minimal SLURM configuration (quick jobs)
./run_workflow.sh slurmMinimal

# Dry run to check workflow
./run_workflow.sh slurmConfig -n

# With custom arguments
./run_workflow.sh slurmConfig --jobs 50 --rerun-triggers mtime
```

## Profiles

Two SLURM profiles are available:

### slurmConfig (Recommended)

Full configuration with optimized resource allocation:

- **tldr_detect**: 4 hours, 24GB/CPU, 4 CPUs (componc_cpu)
- **index_bam**: 1 hour, 8GB/CPU, 2 CPUs (cpushort)
- **merge_results**: 30 min, 8GB/CPU, 2 CPUs (cpushort)
- **summary_stats**: 30 min, 8GB/CPU, 2 CPUs (cpushort)

```bash
./run_workflow.sh slurmConfig
```

### slurmMinimal

Conservative resources for quick testing:

- **Default**: 1 hour, 16GB/CPU, 4 CPUs (cpushort)
- Limited to 50 concurrent jobs

```bash
./run_workflow.sh slurmMinimal
```

## Container Configuration

The workflow uses **docker://sahuno/tldr:latest** which includes:

**Tools:**
- tldr 1.3.0
- samtools 1.21
- minimap2 2.24
- mafft 7.490
- exonerate 2.4.0
- Python packages: pysam, numpy, scikit-learn, scipy, tqdm

**Reference Data (built-in):**
- `/opt/tldr/ref/teref.ont.human.fa` - Human TE ref (ONT-optimized)
- `/opt/tldr/ref/teref.human.fa` - Human TE ref (standard)
- `/opt/tldr/ref/teref.mouse.fa` - Mouse TE ref
- `/opt/tldr/ref/nonref.collection.*.bed.gz` - Known non-ref insertions

**Singularity Settings:**
- Auto-pulled from DockerHub and cached
- Bind mount: `/data1/greenbab` (edit in profile if needed)

See `containers.yaml` for full container registry.

## Output Structure

```
results/
├── sample1/
│   └── sample1.table.txt          # TE insertions detected
├── sample2/
│   └── sample2.table.txt
├── summary/
│   ├── all_samples.merged.txt     # All results merged
│   ├── summary_stats.txt          # Summary statistics
│   └── insertion_counts_per_sample.txt  # Per-sample counts
└── logs/
    ├── sample1.tldr.log
    └── sample2.tldr.log
```

## Workflow Rules

### Detection Rules

- **`tldr_detect`**: Run tldr on each sample (main analysis)
- **`index_bam`**: Auto-create BAM indexes if missing

### Analysis Rules

- **`merge_results`**: Combine all sample results into one table
- **`summary_stats`**: Generate summary statistics and counts

### Utility Rules

- **`clean`**: Remove results directory

## Advanced Usage

### Custom tldr Parameters

Edit `config.yaml`:

```yaml
tldr_params: "--minreads 5 --strict --detail_output"
```

Available parameters:
- `--minreads N` - Minimum reads to form cluster (default: 3)
- `--min_te_len N` - Minimum insertion size (default: 200)
- `--max_te_len N` - Maximum insertion size (default: 10000)
- `--strict` - Apply additional filters
- `--somatic` - Predict somatic insertions
- `--detail_output` - Output per-insertion BAMs
- `--trdcol` - Add transduction columns
- `--methylartist` - Generate methylartist commands

### Run Specific Samples

```bash
snakemake --profile profiles/slurmConfig \
    results/sample1/sample1.table.txt
```

### Modify SLURM Resources

Edit `profiles/slurmConfig/config.yaml`:

```yaml
set-resources:
    tldr_detect:
        runtime: 480         # 8 hours
        mem_mb_per_cpu: 32000
        cpus_per_task: 8
```

### Change Bind Mounts

Edit profile config:

```yaml
singularity-args: "--bind /data1/greenbab,/scratch,/project"
```

### Use Local SIF File

If you've pre-pulled the container:

```yaml
# In config.yaml
container: "/data1/greenbab/software/images/tldr_latest.sif"
```

### Different Reference Genomes

For mouse samples:

```yaml
reference_genome: "/path/to/mm10.fa"
te_reference: "/opt/tldr/ref/teref.mouse.fa"
nonref_collection: "/opt/tldr/ref/nonref.collection.mm10.chr.bed.gz"
```

## Troubleshooting

### BAM Files Not Found

Ensure paths in `samples.tsv` are absolute and accessible:

```bash
# Check file exists
ls -lh /data1/greenbab/data/sample1.bam

# Check permissions
chmod 644 /data1/greenbab/data/sample1.bam*
```

### Container Pull Fails

Pre-pull the container manually:

```bash
singularity pull tldr_latest.sif docker://sahuno/tldr:latest
```

Then update `config.yaml`:

```yaml
container: "/path/to/tldr_latest.sif"
```

### SLURM Jobs Fail

Check SLURM logs:

```bash
# View recent SLURM output
tail results/logs/*.log

# Check job status
squeue -u $USER
sacct -u $USER --format=JobID,JobName,State,ExitCode
```

### Bind Mount Issues

Ensure your data is under `/data1/greenbab` or update bind mounts:

```yaml
# In profiles/slurmConfig/config.yaml
singularity-args: "--bind /your/data/path"
```

## Cluster-Specific Notes

### greenbab Cluster

**Partitions:**
- `cpushort` - Short CPU jobs (<2 hours)
- `componc_cpu` - Long CPU jobs
- `gpushort` - Short GPU jobs (not used)
- `componc_gpu` - Long GPU jobs (not used)

**Account:**
- Always use `greenbab` account

**Storage:**
- Data: `/data1/greenbab/`
- Containers: `/data1/greenbab/software/images/`

## References

- **tldr**: [github.com/adamewing/tldr](https://github.com/adamewing/tldr)
- **Snakemake**: [snakemake.readthedocs.io](https://snakemake.readthedocs.io)
- **Singularity**: [sylabs.io/docs](https://sylabs.io/docs/)
- **SLURM**: [slurm.schedmd.com](https://slurm.schedmd.com/documentation.html)

## Citation

If you use this workflow, please cite:

**tldr:**
> Ewing AD, et al. Nanopore sequencing allows comprehensive transposable element epigenomic profiling. *Molecular Cell* 80, 915-928 (2020)

**Snakemake:**
> Mölder F, et al. Sustainable data analysis with Snakemake. *F1000Research* 10:33 (2021)
