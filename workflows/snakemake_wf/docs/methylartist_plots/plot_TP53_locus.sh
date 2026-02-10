#!/usr/bin/env bash
# Plot methylartist locus for TP53 (chr17:7668421-7687490) with 500bp padding
# Author: Samuel Ahuno
# Date: 2026-02-10
# Sample: SU2C-118_TS-1963991T_On1L_LRWGS_17337_4_1
# Genome: hg38

set -euo pipefail

METHYLARTIST="/home/ahunos/miniforge3/envs/snakemake/bin/methylartist"
OUTDIR="$(cd "$(dirname "$0")" && pwd)"

BAM="/data1/collab001/janjigian_su2c/WGS-ONT/sam/DNAme_prod/results/IRIS_files/results/methylation_basecalling/mark_duplicates/SU2C-118_TS-1963991T_On1L_LRWGS_17337_4_1/SU2C-118_TS-1963991T_On1L_LRWGS_17337_4_1_modBaseCalls_dedup_sorted.bam"
REF="/data1/greenbab/database/hg38/v0/Homo_sapiens_assembly38.fasta"
GTF="/data1/greenbab/database/gencode_annotations/hg38/gencode.v47.annotation.gtf.gz"

# TP53 locus: chr17:7668421-7687490 padded by 500bp on each side
INTERVAL="chr17:7667921-7687990"
HIGHLIGHT="7668421-7687490"

# --- Step 1: Prepare a bgzf-compressed, tabix-indexed GTF for the region ---
# The full gencode GTF is gzip (not bgzf), so methylartist cannot tabix-index it
# directly. Extract the overlapping region, sort, bgzip, and tabix-index.
REGION_GTF="${OUTDIR}/tp53_region.gtf.gz"

if [[ ! -f "${REGION_GTF}.tbi" ]]; then
    echo "Building region GTF for TP53 locus..."
    zcat "${GTF}" \
        | awk '$1=="chr17" && $4 <= 7687990 && $5 >= 7667921' \
        | sort -k1,1 -k4,4n \
        | /home/ahunos/miniforge3/envs/snakemake/bin/bgzip -c > "${REGION_GTF}"
    /home/ahunos/miniforge3/envs/snakemake/bin/tabix -p gff "${REGION_GTF}"
fi

# --- Step 2: Run methylartist locus ---
cd "${OUTDIR}"

${METHYLARTIST} locus \
    -i "${INTERVAL}" \
    -l "${HIGHLIGHT}" \
    -b "${BAM}" \
    -r "${REF}" \
    -g "${REGION_GTF}" \
    --motif CG \
    --labelgenes \
    --show_transcripts \
    -o SU2C-118_TP53_locus

echo "Done. Output: ${OUTDIR}/SU2C-118_TP53_locus.png"
