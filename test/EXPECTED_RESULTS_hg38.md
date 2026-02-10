# TLDR Expected Results Guide - hg38 ONT WGS

**Author:** Samuel Ahuno (ekwame001@gmail.com)
**Date:** 2026-02-09
**Context:** ONT long-read WGS (~30x), tumor sample, hg38, `--somatic --trdcol --detail_output`

---

## 1. Expected Insertion Counts

### Quick mode (chr22 only)

| Metric | Expected range |
|--------|---------------|
| Total insertions | ~30–100 |
| PASS filter | ~20–70 |
| ALU | ~60–80% of calls |
| L1 | ~10–20% |
| SVA | ~5–10% |
| HERVK | 0–2 |
| Somatic calls | 0–3 |

### Full genome

| Metric | Expected range |
|--------|---------------|
| Total insertions | ~1,000–2,500 |
| PASS filter | ~800–1,800 |
| ALU | ~800–1,500 |
| L1 | ~100–400 |
| SVA | ~50–150 |
| HERVK | 0–5 |
| Somatic insertions | 0–50 (cancer-type dependent) |

### Expected insertion lengths

| TE family | Typical full-length (bp) | Range you'll see (bp) |
|-----------|--------------------------|----------------------|
| ALU | ~300 | 200–350 (most are full-length) |
| SVA | ~1,400 | 200–2,500 (many are 5'-truncated) |
| L1 | ~6,000 | 200–6,500 (most are 5'-truncated; only ~5% full-length) |
| HERVK | ~9,400 | 200–9,500 (extremely rare as non-ref) |

---

## 2. Output Table Column Guide

The main output `*.table.txt` is tab-delimited, one row per insertion.

### Genomic location & TE identity

| Column | Description | Example |
|--------|-------------|---------|
| UUID | Unique insertion ID | `a3f8b2c1-...` |
| Chrom | Chromosome | `chr22` |
| Start | Insertion start coordinate | `29045678` |
| End | Insertion end coordinate | `29045690` |
| Strand | Insertion orientation | `+` or `-` |
| Family | TE superfamily | `L1`, `ALU`, `SVA`, `ERV` |
| Subfamily | TE subfamily classification | `L1Ta`, `AluYb9`, `SVA_F` |
| StartTE | Start position in TE reference | `0` |
| EndTE | End position in TE reference | `6037` |
| LengthIns | Actual inserted sequence length (bp) | `6021` |
| Inversion | Internal inversion present | `True` / `False` |

### Quality metrics

| Column | Description | Good value | Concern if |
|--------|-------------|------------|------------|
| UnmapCover | Fraction of TE consensus covered | >0.90 (full-length) | <0.50 (fragment) |
| MedianMapQ | Median mapping quality of supporting reads | 60 | <20 |
| TEMatch | Mean identity to TE reference | >0.90 | <0.80 |
| UsedReads | Reads used to build consensus | >5 | <3 |
| SpanReads | Reads completely embedding the insertion | >2 | 0 |
| Filter | Pass/fail status | `PASS` | Any failure reason |

### Filter failure reasons

| Filter value | Meaning |
|--------------|---------|
| `PASS` | Passed all quality thresholds |
| `LowMapQ` | Median mapping quality too low |
| `LowSupport` | Too few supporting reads |
| `LowTEMatch` | Poor alignment to TE reference |
| `AltIns` | Alternative insertion at same site |
| `ShortIns` | Insertion shorter than `--min_te_len` |
| `LongIns` | Insertion longer than `--max_te_len` |

### Somatic prediction columns

| Column | Description |
|--------|-------------|
| Phasing | Haplotype assignment of supporting reads (HP:1 / HP:2 counts) |
| EmptyReads | Reads spanning the site WITHOUT the insertion |
| EmptyPhase | Phase info for empty-site reads |

**How somatic prediction works:**

The `--somatic` flag uses a Gaussian Mixture Model (GMM) on phasing data to classify each insertion:

| Classification | Phasing signature |
|----------------|-------------------|
| **Germline heterozygous** | Insertion reads on one haplotype, empty reads on the other |
| **Germline homozygous** | Insertion reads on both haplotypes |
| **Somatic** | Insertion reads mixed across haplotypes, or present on one haplotype with empty reads on BOTH haplotypes |

### Transduction columns (`--trdcol`)

| Column | Description |
|--------|-------------|
| 3' transduction | Genomic sequence carried downstream of L1 to the new site |
| 5' transduction | Genomic sequence carried upstream |

Transductions are useful for tracing the **source L1 element** — the specific full-length L1 copy in the genome that produced the new insertion.

### Annotation columns

| Column | Description |
|--------|-------------|
| NonRef | Match to known non-reference TE database (`-n` flag). Format: `Family:Source` |
| TSD | Target site duplication sequence at insertion site |
| Consensus | Full consensus sequence (uppercase = reference flank, lowercase = insertion) |
| NumSamples | Number of input BAMs containing this insertion |
| SampleReads | Per-sample read count breakdown |
| Remappable | Whether the consensus could be remapped to the reference |

---

## 3. Interpreting Results Biologically

### Germline insertions (the majority)

These are inherited TE polymorphisms. Most of your calls will be germline.

**Characteristics:**
- Present in the known non-ref database (`NonRef` column populated)
- Clean haplotype phasing (reads on one or both haplotypes)
- Consistent with heterozygous or homozygous genotype
- Found at well-characterized polymorphic sites

**Expected subfamily distribution for germline:**

| Subfamily | Relative frequency | Notes |
|-----------|--------------------|-------|
| AluYa5 | Most common ALU | Youngest, most polymorphic |
| AluYb8 | Common | Second most active |
| AluYb9 | Less common | |
| AluYa8 | Less common | |
| L1Ta | Most common L1 | Currently active |
| L1preTa | Common | Slightly older |
| L1PA2 | Rare | Ancient, mostly fixed |
| SVA_E, SVA_F | Most common SVA | Youngest subfamilies |
| SVA_D | Moderate | |
| SVA_A, SVA_B, SVA_C | Less common | Older |
| HERVK | Very rare | Few polymorphic copies remain |

### Somatic insertions (rare, high-value)

Somatic TE insertions occur during the lifetime of the individual, typically through L1 retrotransposition in cancer.

**Characteristics of a true somatic insertion:**
- **No NonRef match** — not in population databases
- **L1Ta or L1preTa subfamily** — only active L1s cause somatic insertions
- **Low variant allele fraction (VAF)** — low SpanReads relative to total coverage (subclonal)
- **Somatic phasing signature** — does not follow Mendelian haplotype segregation
- **Target site duplication present** — hallmark of retrotransposition mechanism
- **3' transduction possible** — can trace to source L1 element
- **5' truncation common** — most somatic L1s are incomplete (median ~1–2 kb)

**Cancer-type specific expectations:**

| Cancer type | Expected somatic L1 insertions |
|-------------|-------------------------------|
| Colorectal | 10–50+ (high L1 activity) |
| Esophageal / Gastric | 5–30 (moderate-high) |
| Lung squamous | 5–20 |
| Head and neck | 5–20 |
| Hepatocellular | 5–15 |
| Breast | 0–10 |
| Prostate | 0–5 |
| Leukemia / Lymphoma | 0–2 (very low) |
| Glioblastoma | 0–2 |

Somatic ALU insertions are biologically possible but very rare in cancer. Somatic SVA or HERVK insertions are essentially never observed.

### Target site duplications (TSD)

TSDs are short duplications of the target site created during retrotransposition. Their presence confirms the insertion was created by the retrotransposition machinery rather than being an artifact.

| TE family | Typical TSD length |
|-----------|--------------------|
| ALU | 7–20 bp |
| L1 | 7–20 bp |
| SVA | 7–20 bp |
| HERVK | 4–6 bp |

---

## 4. Detail Output Directory

With `--detail_output`, each PASS insertion gets files in `<outbase>/`:

| File pattern | Contents |
|--------------|----------|
| `<UUID>.cons.ref.fa` | Consensus FASTA (insertion + reference flanking context) |
| `<UUID>.te_aln.bam` | Supporting reads aligned to the consensus |
| `<UUID>.reads.txt` | Per-read information (mapping, phase) |

**Uses:**
- Manually validate somatic candidates in IGV
- BLAST consensus sequences against RepBase/Dfam for detailed classification
- Extract methylation data from read-level BAMs (with `--extend_consensus`)

### The `--extend_consensus` flag (important for methylation)

By default, the per-insertion consensus covers the insertion itself plus a small flanking region (`--flanksize`, default 500 bp each side). The `--extend_consensus N` flag adds **N additional bases** of reference context on both sides:

```
Default (extend_consensus=0):
    [---500bp flank---][===INSERTION===][---500bp flank---]

With --extend_consensus 5000:
    [------5500bp flank------][===INSERTION===][------5500bp flank------]
```

**What this changes in the detail output:**

1. **Wider read capture** — reads are fetched from the original BAM over the extended window and re-aligned to the extended consensus. More flanking reads are included in the per-insertion BAM.

2. **Methylation tags preserved** — during re-alignment, tldr extracts and carries forward the ONT modification tags from each read:
   - `MM`/`Mm` tag: base modification type and positions (e.g., 5mC at CpG)
   - `ML`/`Ml` tag: modification probability scores (0–255)

   These tags are written into the detail output BAMs, making them directly usable for methylation analysis at TE insertion sites.

3. **Phasing tags preserved** — `HP` (haplotype) and `PS` (phase set) tags are also carried through to the output BAMs, enabling haplotype-resolved methylation analysis.

4. **Methylartist compatibility** — tldr warns if `--methylartist` is used without `--extend_consensus`, because methylartist needs sufficient CpG context flanking the insertion to generate meaningful methylation locus/segment plots.

**When to use it:**

| Scenario | Recommendation |
|----------|---------------|
| BAM has modification basecalls (`modBaseCalls` in filename) | Use `--extend_consensus 5000 --methylartist` |
| BAM without methylation data | Not needed, skip it |
| Only interested in insertion detection, not epigenetics | Not needed, skip it |
| Studying methylation at L1 promoters in somatic insertions | Essential — the full-length L1 internal CpG island is in the 5' UTR; you need flanking context to assess it |

**Example with methylation enabled:**

```bash
tldr -b sample_modBaseCalls.bam \
    -e ref/teref.ont.human.fa \
    -r /data1/greenbab/database/hg38/v0/Homo_sapiens_assembly38.fasta \
    --detail_output --extend_consensus 5000 --methylartist \
    --somatic --trdcol --color_consensus \
    -p 8 -o output/sample_name
```

**Additional output files when `--methylartist` is used:**

| File pattern | Contents |
|--------------|----------|
| `<sample>.<UUID>.bed` | BED file marking the TE-aligned region within the consensus |
| `<sample>.<UUID>.methylartist.cmd` | Ready-to-run methylartist commands (locus plot + segment methylation) |

The generated methylartist commands can be run directly to produce per-insertion methylation plots:

```bash
# Run all generated methylartist commands
for cmd_file in output/sample_name/*.methylartist.cmd; do
    bash "${cmd_file}"
done
```

**Note on the SU2C-118 sample:** The BAM filename contains `modBaseCalls`, confirming ONT basecalling was run with modification detection. This means `MM`/`ML` tags are present in the reads and `--extend_consensus 5000 --methylartist` should be added to capture TE insertion methylation data.

---

## 5. Quick Sanity Checks

Run these after the pipeline completes:

```bash
TABLE="<outdir>/<sample>.table.txt"

# 1. Total and PASS counts
echo "Total: $(tail -n +2 ${TABLE} | wc -l)"
echo "PASS:  $(awk -F'\t' '$NF == "PASS"' ${TABLE} | wc -l)"

# 2. TE family distribution
echo "--- TE families ---"
tail -n +2 ${TABLE} | awk -F'\t' '{print $6}' | sort | uniq -c | sort -rn

# 3. Subfamily distribution
echo "--- Subfamilies ---"
tail -n +2 ${TABLE} | awk -F'\t' '{print $7}' | sort | uniq -c | sort -rn

# 4. Filter reasons
echo "--- Filters ---"
tail -n +2 ${TABLE} | awk -F'\t' '{print $NF}' | sort | uniq -c | sort -rn

# 5. Insertion length distribution (median)
echo "--- Insertion lengths ---"
tail -n +2 ${TABLE} | awk -F'\t' '{print $6"\t"$11}' | sort -k1,1 -k2,2n

# 6. NonRef annotation rate (high = good, means known sites are being detected)
TOTAL=$(tail -n +2 ${TABLE} | wc -l)
ANNOTATED=$(tail -n +2 ${TABLE} | awk -F'\t' '$NF == "PASS"' | awk -F'\t' '{for(i=1;i<=NF;i++) if($i != "." && $i != "") count++} END{print count}')
echo "Total PASS: ${TOTAL}"

# 7. Check for somatic candidates (no NonRef match + PASS)
echo "--- Potential somatic (PASS, no NonRef) ---"
head -1 ${TABLE}
```

---

## 6. Red Flags

| Observation | Possible cause | Action |
|-------------|----------------|--------|
| Very few PASS calls (<200 genome-wide) | BAM quality issues, wrong reference | Check BAM alignment rate, verify chr naming matches |
| No ALU calls at all | Pipeline error, TE reference mismatch | Check log for exonerate/mafft errors |
| All insertions fail filter | Dependency version issue | Verify mafft >= 7.480, samtools >= 1.2 |
| TEMatch scores consistently <0.80 | Wrong TE reference or highly divergent insertions | Ensure using `teref.ont.human.fa` for ONT data |
| MedianMapQ = 0 for many calls | Reads in repetitive/unmappable regions | Expected for some L1 insertions in segdup regions |
| Very high somatic count (>100) | False positives from poor phasing | Check if haplotag/phase info is present in the BAM |
| Known NonRef sites not detected | Low coverage or BAM truncation | Verify coverage with `samtools depth` |
| L1 insertions all 5'-truncated | Normal biology | Only ~5% of L1 insertions are full-length |

---

## 7. Downstream Analysis

After the initial tldr run, consider these follow-up analyses:

### Somatic candidate validation
```bash
# Re-run with pickles, stricter filters
tldr -b <BAM> -e <TE_REF> -r <REF> \
    --use_pickles <pickle_dir> \
    -o <new_outbase> \
    --somatic --strict --detail_output --trdcol
```

### Transduction calling (trace source L1 elements)
```bash
python scripts/call_transductions.py <outbase>.table.txt
```

### Methylation analysis at insertion sites
```bash
# Requires --extend_consensus and --methylartist during the initial tldr run

# Option 1: Run the auto-generated methylartist commands
for cmd_file in <outbase>/*.methylartist.cmd; do
    bash "${cmd_file}"
done

# Option 2: Summarize CpG methylation across all non-ref insertions
python scripts/tablemeth_nonref.py <args>

# Option 3: Plot methylation at specific insertions
python scripts/plotmeth_nonref.py <args>
```

If the initial run did NOT use `--extend_consensus`, re-run with pickles to add it:
```bash
tldr -b <BAM> -e <TE_REF> -r <REF> \
    --use_pickles <pickle_dir> \
    -o <new_outbase> \
    --detail_output --extend_consensus 5000 --methylartist \
    --somatic --trdcol
```

### IGV visualization of candidates
```bash
# Use the detail output BAMs for manual review
# or use igver for batch screenshots:
singularity exec --bind /data1/greenbab \
    /data1/greenbab/software/images/igver_latest.sif igver \
    --input <detail_output>/<UUID>.te_aln.bam \
    -r regions.txt -o igv_plots \
    --dpi 600 -d expand -p 1000 --genome 'hg38'
```

### Annotation against gene features
```bash
# Annotate insertions with gene context using GENCODE
python scripts/annotate.py \
    <outbase>.table.txt \
    /data1/greenbab/database/gencode_annotations/hg38/gencode.v47.annotation.gtf.gz
```
