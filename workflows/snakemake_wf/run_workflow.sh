#!/bin/bash

# Snakemake workflow execution script for tldr
# Usage: ./run_workflow.sh [profile] [additional_args]

set -e

PROFILE=${1:-slurmConfig}
shift || true

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}tldr Snakemake Workflow${NC}"
echo -e "${GREEN}Container-only Execution${NC}"
echo -e "${GREEN}================================${NC}"
echo ""

# Check if samples.tsv exists
if [ ! -f "samples.tsv" ]; then
    echo -e "${RED}Error: samples.tsv not found!${NC}"
    echo "Please create samples.tsv with columns: patient, sample, condition, path, genome"
    exit 1
fi

# Check if config.yaml exists
if [ ! -f "config.yaml" ]; then
    echo -e "${RED}Error: config.yaml not found!${NC}"
    exit 1
fi

# Validate samples file
echo -e "${YELLOW}Validating samples file...${NC}"
SAMPLE_COUNT=$(( $(wc -l < samples.tsv) - 1 ))
if [ $SAMPLE_COUNT -lt 1 ]; then
    echo -e "${RED}Error: samples.tsv appears to be empty or has no samples${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Found $SAMPLE_COUNT samples"
echo ""

# Check profile
if [ ! -d "profiles/${PROFILE}" ]; then
    echo -e "${RED}Error: Profile 'profiles/${PROFILE}' not found!${NC}"
    echo ""
    echo "Available profiles:"
    echo "  - slurmConfig  (full SLURM configuration with resource optimization)"
    echo "  - slurmMinimal (minimal SLURM configuration for quick jobs)"
    echo ""
    echo "Usage: $0 [profile] [additional_args]"
    echo ""
    echo "Examples:"
    echo "  $0 slurmConfig           # Run with full SLURM config"
    echo "  $0 slurmMinimal          # Run with minimal SLURM config"
    echo "  $0 slurmConfig -n        # Dry run"
    echo "  $0 slurmConfig --cores 4 # Override with local execution"
    exit 1
fi

echo -e "${BLUE}Profile: ${PROFILE}${NC}"
echo -e "${BLUE}SLURM Account: greenbab${NC}"
echo -e "${BLUE}Container: docker://sahuno/tldr:latest${NC}"
echo ""

# Create logs directory for SLURM
mkdir -p results/logs

# Run Snakemake with profile
echo -e "${YELLOW}Launching Snakemake workflow...${NC}"
echo ""

snakemake \
    --profile profiles/${PROFILE} \
    "$@"

# Check exit status
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN}Workflow completed successfully!${NC}"
    echo -e "${GREEN}================================${NC}"
    echo ""
    echo "Results available in: results/"
    echo "  - Individual samples: results/*/sample*.table.txt"
    echo "  - Merged results: results/summary/all_samples.merged.txt"
    echo "  - Summary stats: results/summary/summary_stats.txt"
    echo "  - Insertion counts: results/summary/insertion_counts_per_sample.txt"
else
    echo ""
    echo -e "${RED}================================${NC}"
    echo -e "${RED}Workflow failed!${NC}"
    echo -e "${RED}================================${NC}"
    echo ""
    echo "Check logs in: results/logs/"
    exit 1
fi
