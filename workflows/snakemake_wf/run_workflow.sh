#!/bin/bash

# Snakemake workflow execution script for tldr
# Usage: ./run_workflow.sh [local|slurm|sge] [cores]

set -e

MODE=${1:-local}
CORES=${2:-8}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}tldr Snakemake Workflow${NC}"
echo -e "${GREEN}================================${NC}"
echo ""

# Check if samples.tsv exists
if [ ! -f "samples.tsv" ]; then
    echo -e "${RED}Error: samples.tsv not found!${NC}"
    echo "Please create samples.tsv with your sample information"
    exit 1
fi

# Check if config.yaml exists
if [ ! -f "config.yaml" ]; then
    echo -e "${RED}Error: config.yaml not found!${NC}"
    exit 1
fi

# Validate samples file
echo -e "${YELLOW}Validating samples file...${NC}"
if [ $(wc -l < samples.tsv) -lt 2 ]; then
    echo -e "${RED}Error: samples.tsv appears to be empty or has no samples${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Found $(( $(wc -l < samples.tsv) - 1 )) samples"
echo ""

# Run based on mode
case $MODE in
    local)
        echo -e "${YELLOW}Running workflow locally with ${CORES} cores${NC}"
        echo ""
        snakemake \
            --use-singularity \
            --cores $CORES \
            --printshellcmds \
            --rerun-incomplete
        ;;

    slurm)
        echo -e "${YELLOW}Running workflow on SLURM cluster${NC}"
        echo ""

        # Create SLURM logs directory
        mkdir -p logs/slurm

        snakemake \
            --profile profiles/slurm \
            --printshellcmds \
            --rerun-incomplete
        ;;

    sge)
        echo -e "${YELLOW}Running workflow on SGE cluster${NC}"
        echo ""

        snakemake \
            --use-singularity \
            --cluster "qsub -pe smp {threads} -l mem_free={resources.mem_mb}M -o logs/sge -e logs/sge" \
            --jobs 50 \
            --printshellcmds \
            --rerun-incomplete
        ;;

    dryrun)
        echo -e "${YELLOW}Performing dry run...${NC}"
        echo ""
        snakemake \
            --use-singularity \
            --cores $CORES \
            --dryrun \
            --printshellcmds
        ;;

    *)
        echo -e "${RED}Error: Unknown mode '$MODE'${NC}"
        echo ""
        echo "Usage: $0 [local|slurm|sge|dryrun] [cores]"
        echo ""
        echo "Examples:"
        echo "  $0 local 8          # Run locally with 8 cores"
        echo "  $0 slurm            # Run on SLURM cluster"
        echo "  $0 sge              # Run on SGE cluster"
        echo "  $0 dryrun           # Dry run to check workflow"
        exit 1
        ;;
esac

# Check exit status
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN}Workflow completed successfully!${NC}"
    echo -e "${GREEN}================================${NC}"
    echo ""
    echo "Results available in: results/"
    echo "Summary: results/summary/"
else
    echo ""
    echo -e "${RED}================================${NC}"
    echo -e "${RED}Workflow failed!${NC}"
    echo -e "${RED}================================${NC}"
    echo ""
    echo "Check logs in: results/logs/"
    exit 1
fi
