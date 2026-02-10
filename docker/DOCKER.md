# Docker Usage Guide for tldr

## Quick Start

### Pull from DockerHub (once published)
```bash
docker pull sahuno/tldr:latest
```

### Build Locally
```bash
docker/docker_build.sh
```

### Build and Push to DockerHub
```bash
# Login to DockerHub first
docker login

# Build and push
docker/docker_build.sh -p

# Or with specific tag
docker/docker_build.sh -t v1.3.0 -p
```

## Usage Examples

### Show Help
```bash
docker run --rm sahuno/tldr:latest
```

### Run on Your Data
Mount your current directory to `/data` in the container:

```bash
docker run --rm -v $(pwd):/data sahuno/tldr:latest tldr \
  -b /data/aligned_reads.bam \
  -e ${TLDR_REF_HUMAN} \
  -r /data/reference.fa
```

### Use Specific Reference Files
The container includes reference data at `/opt/tldr/ref/`:

```bash
# Human (ONT-optimized)
docker run --rm -v $(pwd):/data sahuno/tldr:latest tldr \
  -b /data/sample.bam \
  -e /opt/tldr/ref/teref.ont.human.fa \
  -r /data/hg38.fa

# Human (standard)
docker run --rm -v $(pwd):/data sahuno/tldr:latest tldr \
  -b /data/sample.bam \
  -e /opt/tldr/ref/teref.human.fa \
  -r /data/hg38.fa

# Mouse
docker run --rm -v $(pwd):/data sahuno/tldr:latest tldr \
  -b /data/sample.bam \
  -e /opt/tldr/ref/teref.mouse.fa \
  -r /data/mm10.fa
```

### Using Known Non-Reference Collections
```bash
docker run --rm -v $(pwd):/data sahuno/tldr:latest tldr \
  -b /data/sample.bam \
  -e /opt/tldr/ref/teref.ont.human.fa \
  -r /data/hg38.fa \
  -n /opt/tldr/ref/nonref.collection.hg38.chr.bed.gz
```

### Interactive Mode
```bash
docker run --rm -it -v $(pwd):/data sahuno/tldr:latest bash
```

## Environment Variables

The container includes these environment variables:
- `TLDR_REF_DIR=/opt/tldr/ref`
- `TLDR_REF_HUMAN=/opt/tldr/ref/teref.ont.human.fa`
- `TLDR_REF_MOUSE=/opt/tldr/ref/teref.mouse.fa`

Use them in commands:
```bash
docker run --rm -v $(pwd):/data sahuno/tldr:latest tldr \
  -b /data/sample.bam \
  -e ${TLDR_REF_HUMAN} \
  -r /data/genome.fa
```

## Available Reference Data

The container includes:

### TE Reference Files (12 MB total)
- `teref.ont.human.fa` - Human TE reference (ONT-optimized)
- `teref.human.fa` - Human TE reference
- `teref.mouse.fa` - Mouse TE reference

### Non-Reference Collections
- `nonref.collection.hg19.bed.gz[.tbi]`
- `nonref.collection.hg19.chr.bed.gz[.tbi]`
- `nonref.collection.hg38.bed.gz[.tbi]`
- `nonref.collection.hg38.chr.bed.gz[.tbi]`
- `nonref.collection.mm10.bed.gz[.tbi]`
- `nonref.collection.mm10.chr.bed.gz[.tbi]`

## Building Custom Images

### Change DockerHub Username
```bash
docker/docker_build.sh -u yourusername -p
```

### Build Script Options
```bash
docker/docker_build.sh -h

Options:
  -u, --username    DockerHub username (default: sahuno)
  -t, --tag         Image tag (default: latest)
  -p, --push        Push to DockerHub after build
  -h, --help        Show this help message
```

## Image Details

- **Base Image**: mambaorg/micromamba:1.5.10
- **tldr Version**: 1.3.0
- **Python**: 3.10
- **Image Size**: ~500 MB
- **Reference Data**: 12 MB included

## Dependencies Included

- **tldr**: Main application
- **samtools**: 1.21
- **minimap2**: 2.24
- **mafft**: 7.490
- **exonerate**: 2.4.0
- **Python packages**: pysam, numpy, scikit-learn, scipy, tqdm, etc.

## Notes

- Your data files must be in the mounted directory (default: current directory → `/data`)
- All paths in commands should be relative to `/data` (the container's working directory)
- Output files will be written to the mounted directory
- Reference files are built into the image at `/opt/tldr/ref/`
