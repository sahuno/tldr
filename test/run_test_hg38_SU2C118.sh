#!/bin/bash
# ==============================================================================
# TLDR Full Pipeline Test - hg38 ONT WGS
# ==============================================================================
# Author: Samuel Ahuno (ekwame001@gmail.com)
# Date: 2026-02-09
# Description: Full pipeline test of tldr on ONT long-read WGS data (hg38)
#              Sample: SU2C-118_TS-1963991T_On1L_LRWGS_17337_4_1
# ==============================================================================

set -euo pipefail

# --- Configuration -----------------------------------------------------------

# Conda environment
CONDA_ENV="tldr"

# TLDR source directory
TLDR_DIR="/data1/greenbab/users/ahunos/apps/tldr"

# Input BAM
BAM="/data1/collab001/janjigian_su2c/WGS-ONT/sam/DNAme_prod/results/IRIS_files/results/methylation_basecalling/mark_duplicates/SU2C-118_TS-1963991T_On1L_LRWGS_17337_4_1/SU2C-118_TS-1963991T_On1L_LRWGS_17337_4_1_modBaseCalls_dedup_sorted.bam"

# Reference genome (hg38) - samtools indexed
REF="/data1/greenbab/database/hg38/v0/Homo_sapiens_assembly38.fasta"

# TE reference library (ONT-specific human)
TE_REF="${TLDR_DIR}/ref/teref.ont.human.fa"

# Known non-reference TE insertions (hg38, chr-prefix)
NONREF="${TLDR_DIR}/ref/nonref.collection.hg38.chr.bed.gz"

# Sample/output base name
SAMPLE="SU2C-118_TS-1963991T"

# Number of parallel processes
PROCS=8

# Test mode: "quick" = chr22 only, "full" = all standard chromosomes
TEST_MODE="${1:-quick}"

# Output directory
OUTDIR="${TLDR_DIR}/test/results_hg38_${SAMPLE}_${TEST_MODE}"

# --- Functions ----------------------------------------------------------------

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

check_file() {
    if [[ ! -f "$1" ]]; then
        echo "ERROR: File not found: $1"
        exit 1
    fi
}

# --- Pre-flight checks --------------------------------------------------------

log "=== TLDR Full Pipeline Test ==="
log "Test mode: ${TEST_MODE}"
log "Sample: ${SAMPLE}"
log "BAM: ${BAM}"
log "Reference: ${REF}"
log "TE Reference: ${TE_REF}"
log "Non-ref DB: ${NONREF}"

# Verify all input files exist
check_file "${BAM}"
check_file "${BAM}.bai"
check_file "${REF}"
check_file "${REF}.fai"
check_file "${TE_REF}"
check_file "${NONREF}"

# Activate mamba environment
log "Activating mamba environment: ${CONDA_ENV}"
# eval "$(conda shell.bash hook)"
# mamba activate "${CONDA_ENV}"

# Verify dependencies
log "Checking dependencies..."
for tool in tldr samtools minimap2 mafft exonerate; do
    if ! command -v "${tool}" &>/dev/null; then
        echo "ERROR: ${tool} not found in PATH"
        exit 1
    fi
done
log "All dependencies found."

# --- Setup output directory ---------------------------------------------------

mkdir -p "${OUTDIR}"
log "Output directory: ${OUTDIR}"

# --- Create chromosome list ---------------------------------------------------

CHROMS_FILE="${OUTDIR}/chroms.txt"

if [[ "${TEST_MODE}" == "quick" ]]; then
    # Quick test: chr22 only (smallest autosome, ~50 Mb)
    echo "chr22" > "${CHROMS_FILE}"
    log "Quick mode: restricting to chr22"
elif [[ "${TEST_MODE}" == "medium" ]]; then
    # Medium test: chr21 + chr22 (two smallest autosomes)
    printf "chr21\nchr22\n" > "${CHROMS_FILE}"
    log "Medium mode: restricting to chr21, chr22"
elif [[ "${TEST_MODE}" == "full" ]]; then
    # Full test: all standard chromosomes
    printf "chr1\nchr2\nchr3\nchr4\nchr5\nchr6\nchr7\nchr8\nchr9\nchr10\nchr11\nchr12\nchr13\nchr14\nchr15\nchr16\nchr17\nchr18\nchr19\nchr20\nchr21\nchr22\nchrX\nchrY\n" > "${CHROMS_FILE}"
    log "Full mode: all standard chromosomes"
else
    echo "ERROR: Unknown test mode '${TEST_MODE}'. Use: quick, medium, or full"
    exit 1
fi

# --- Run TLDR -----------------------------------------------------------------

log "Starting tldr..."
log "Command:"

TLDR_CMD="tldr \
    -b ${BAM} \
    -e ${TE_REF} \
    -r ${REF} \
    -p ${PROCS} \
    -c ${CHROMS_FILE} \
    -n ${NONREF} \
    -o ${OUTDIR}/${SAMPLE} \
    --color_consensus \
    --detail_output \
    --extend_consensus 5000 \
    --methylartist \
    --trdcol \
    --somatic \
    --keep_pickles"

echo "${TLDR_CMD}"

eval "${TLDR_CMD}" 2>&1 | tee "${OUTDIR}/${SAMPLE}_tldr.log"

TLDR_EXIT=$?

# --- Post-run summary ---------------------------------------------------------

log "=== TLDR Run Complete (exit code: ${TLDR_EXIT}) ==="

TABLE="${OUTDIR}/${SAMPLE}.table.txt"
if [[ -f "${TABLE}" ]]; then
    TOTAL_INS=$(tail -n +2 "${TABLE}" | wc -l)
    PASS_INS=$(awk -F'\t' '$NF == "PASS"' "${TABLE}" | wc -l)
    log "Total insertions called: ${TOTAL_INS}"
    log "PASS insertions: ${PASS_INS}"

    log "Top TE families detected:"
    tail -n +2 "${TABLE}" | awk -F'\t' '{print $6}' | sort | uniq -c | sort -rn | head -10

    log "Output table: ${TABLE}"
    log "Detail output: ${OUTDIR}/${SAMPLE}/"
    log "Log file: ${OUTDIR}/${SAMPLE}_tldr.log"
    log "Pickle files: ${OUTDIR}/${SAMPLE}.*.pickle"
else
    log "WARNING: Output table not found at ${TABLE}"
    log "Check log file: ${OUTDIR}/${SAMPLE}_tldr.log"
fi

log "Done."
