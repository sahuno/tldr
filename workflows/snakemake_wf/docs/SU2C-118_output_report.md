# SU2C-118 tldr Output Report

**Date:** 2026-02-10
**Author:** Samuel Ahuno
**Pipeline:** tldr v1.3.0 (container: /data1/greenbab/software/images/tldr_latest.sif)
**Sample:** SU2C-118_TS-1963991T_On1L_LRWGS_17337_4_1
**Genome:** hg38 (Homo_sapiens_assembly38.fasta)
**Total output:** 34,946 files, 31 GB

---

## 1. Main Results Table: `SU2C-118.table.txt`

**Size:** 11 MB | **Total candidate insertions:** 5,579

Tab-delimited file with 29 columns per insertion.

### Column Descriptions

| # | Column | Description |
|---|--------|-------------|
| 1 | UUID | Unique identifier for each insertion (links to per-insertion files) |
| 2 | Chrom | Chromosome of insertion site |
| 3 | Start | Start coordinate of insertion |
| 4 | End | End coordinate of insertion |
| 5 | Strand | Strand of TE insertion |
| 6 | Family | TE family (ALU, L1, SVA, ERV, or NA if unclassified) |
| 7 | Subfamily | TE subfamily (e.g., AluYa5, L1Ta, SVA_A, HERVK) |
| 8 | StartTE | Start position within TE consensus |
| 9 | EndTE | End position within TE consensus |
| 10 | LengthIns | Length of the inserted sequence (bp) |
| 11 | Inversion | Whether an internal inversion was detected |
| 12 | UnmapCover | Fraction of insertion covered by unmapped sequence |
| 13 | MedianMapQ | Median mapping quality of supporting reads |
| 14 | TEMatch | TE alignment match score |
| 15 | UsedReads | Number of reads used for consensus building |
| 16 | SpanReads | Number of reads spanning the insertion breakpoint |
| 17 | NumSamples | Number of BAM samples with supporting reads |
| 18 | SampleReads | Per-sample read count breakdown |
| 19 | EmptyReads | Reads at the locus without the insertion (reference allele) |
| 20 | EmptyPhase | Phase information for reference-allele reads |
| 21 | NonRef | Match to known polymorphic TE insertion database (nonref.collection.hg38) |
| 22 | TSD | Target Site Duplication sequence |
| 23 | Consensus | Path to consensus sequence FASTA |
| 24 | Phasing | HP tag phasing information |
| 25 | Remappable | Whether the insertion is in a uniquely mappable region |
| 26 | Filter | PASS or comma-separated filter failure reasons |
| 27 | Transduction_5p | 5-prime flanking transduction event |
| 28 | Transduction_3p | 3-prime flanking transduction event |
| 29 | Somatic | Somatic prediction: GERMLINE, SOMATIC, or UNKNOWN |

### Filter Breakdown

| Filter Status | Count |
|---------------|-------|
| **PASS** | **1,528** |
| Filtered (various reasons) | 4,051 |
| **Total** | **5,579** |

**Common filter reasons (top 5):**

| Filter Combination | Count |
|--------------------|-------|
| LeftFlankSize,UnmapCoverNA,NoFamily,NoTEAlignment,NonRemappable,ShortIns | 696 |
| UnmapCoverNA,NoFamily,NoTEAlignment | 505 |
| UnmapCoverNA,NoFamily,NoTEAlignment,ShortIns | 363 |
| UnmapCoverNA,NoFamily,NoTEAlignment,TSDOver100bp,ShortIns | 227 |
| LeftFlankSize,UnmapCoverNA,NoFamily,NoTEAlignment,ShortIns | 151 |

**Filter reason glossary:**

| Filter | Meaning |
|--------|---------|
| NoFamily | Could not classify into a TE family |
| NoTEAlignment | No significant alignment to TE consensus |
| ShortIns | Insertion too short to classify reliably |
| UnmapCoverNA | Unmapped coverage fraction could not be computed |
| NonRemappable | Insertion in a repetitive/non-unique region |
| LeftFlankSize / RightFlankSize | Insufficient flanking sequence |
| TSDOver100bp | Target site duplication >100 bp (likely false positive) |
| TEMapTooLong | TE alignment extends beyond expected TE length |
| UnmapCover<0.5 | Less than 50% of insertion is unmapped to reference |
| AltIns | Alternative insertion allele detected |
| FlankMapQ | Low mapping quality in flanking regions |
| ZeroMapQ | Supporting reads have MapQ=0 |
| Duplicate | Duplicate of another insertion call |

### PASS Insertions by TE Family

| Family | PASS Count | Percentage |
|--------|-----------|------------|
| ALU | 1,300 | 85.1% |
| L1 | 158 | 10.3% |
| SVA | 67 | 4.4% |
| ERV | 3 | 0.2% |
| **Total** | **1,528** | **100%** |

### PASS Insertions by TE Subfamily (Top 10)

| Subfamily | Count | Family |
|-----------|-------|--------|
| AluYa5 | 940 | ALU |
| AluYb8 | 299 | ALU |
| L1Ta | 141 | L1 |
| SVA_A | 57 | SVA |
| AluYb9 | 49 | ALU |
| L1PA2 | 14 | L1 |
| AluYa8 | 12 | ALU |
| SVA_F | 8 | SVA |
| L1preTa | 3 | L1 |
| HERVK | 3 | ERV |

### All Insertions by TE Family (including filtered)

| Family | Count |
|--------|-------|
| NA (unclassified) | 3,197 |
| ALU | 1,788 |
| SVA | 294 |
| L1 | 285 |
| ERV | 15 |

### Chromosome Distribution (Top 10)

| Chromosome | Total Insertions |
|------------|-----------------|
| chr1 | 440 |
| chr2 | 327 |
| chr3 | 313 |
| chr6 | 290 |
| chr17 | 284 |
| chr9 | 283 |
| chr7 | 275 |
| chr12 | 269 |
| chr4 | 265 |
| chr5 | 262 |

### Somatic Prediction

| Prediction | All Insertions | PASS Only |
|------------|---------------|-----------|
| GERMLINE | 1,394 | 987 |
| UNKNOWN | 4,185 | 541 |
| SOMATIC | 0 | 0 |

**Note:** No SOMATIC calls were made because SU2C-118 was run as a single tumor BAM without a paired normal. The `--somatic` flag uses a Gaussian Mixture Model on phasing data to classify insertions, but confident somatic calls require both tumor and normal BAMs. Patients with paired BAMs (e.g., SU2C-324, SU2C-342) should produce actual SOMATIC classifications.

### Transduction Events

- 5-prime transductions: 0
- 3-prime transductions: 0

---

## 2. Per-Insertion Detail Files (in `SU2C-118/` subdirectory)

Each detected insertion generates a set of files keyed by its UUID. Not all insertions produce every file type — the file counts differ because each file type is gated by a progressively stricter quality condition in the tldr source code (`tldr/tldr`).

### File Types

| File Pattern | Count | Total Size | Description |
|---|---|---|---|
| `{UUID}.detail.out` | 5,579 | 6 MB | Per-read alignment details |
| `{UUID}.cons.ref.fa` | 5,568 | 13 MB | Consensus sequence with flanking reference |
| `{UUID}.cons.ref.fa.fai` | 3,634 | — | FASTA index for consensus reference |
| `{sample}.{UUID}.te.bam` | 5,568 | 142 MB | Mini-BAM realigned to consensus reference |
| `{sample}.{UUID}.te.bam.bai` | 5,568 | — | BAM index |
| `{sample}.{UUID}.bed` | 3,634 | — | BED coordinates of TE within consensus |
| `{sample}.{UUID}.methylartist.cmd` | 3,634 | — | Ready-to-run methylartist commands |

### Why File Counts Differ Across Types

The three file count tiers (5,579 / 5,568 / 3,634) correspond to three conditional gates in the tldr pipeline, each stricter than the last:

| Gate | Condition (source location) | Files Generated | Count |
|---|---|---|---|
| **1. Output table** | Cluster reaches the output processing loop | `detail.out` | 5,579 |
| **2. TE library match** | `noref_mode or te_type in inslib` (`tldr/tldr` line ~1440) | `cons.ref.fa`, `te.bam`, `te.bam.bai` | 5,568 |
| **3. TE-to-consensus alignment** | `cons_aln is not None` (`tldr/tldr` line ~1652) | `methylartist.cmd`, `.bed`, `.fai` | 3,634 |

**Gate 1 — detail.out (5,579):** The `detail.out` file is written in a separate output processing loop (line ~2365) that runs for **every cluster** in the main results table. One `detail.out` per table row, no additional quality filter.

**Gate 2 — cons.ref.fa + te.bam (5,568):** Inside the `resolve_cluster()` function, the consensus reference and mini-BAM are only generated within the block gated by `if noref_mode or te_type in inslib:` (line ~1440). This checks whether the cluster's TE subfamily exists in the TE reference library (`teref.ont.human.fa`). **11 clusters** had a TE type not found in the library — likely edge cases where subfamily classification changed after initial read-level calls — so they were written to the table but never had their consensus reference and mini-BAM generated.

**Gate 3 — methylartist files (3,634):** Within the Gate 2 block, methylartist output additionally requires `cons_aln = te_align(cons_seg_seq, out_cons)` to succeed (line ~1651). This re-aligns the TE segment back to the extended consensus to determine the TE start/end coordinates (`h_l`, `h_r`) within it. For **1,934 clusters** (5,568 - 3,634), this alignment returned `None` — meaning the TE could not be reliably localized within the output consensus (e.g., short/fragmented insertions, low identity to consensus). tldr skips generating methylartist coordinates in these cases since the BED coordinates would be meaningless.

### detail.out

Tab-delimited file with one row per supporting read. Columns:

| Column | Description |
|--------|-------------|
| Cluster | UUID of the insertion cluster |
| BamName | Source BAM file name |
| ReadName | ONT read ID |
| IsSpanRead | Whether this read spans the insertion breakpoint |
| TEAlign | TE alignment string: family, subfamily, length, identity, strand |
| TEOverlap | Overlap ratio with TE consensus |
| Useable | Whether the read was used for consensus building |
| RefPos | Reference position of the read alignment |
| Phase | Phasing status (HP:1, HP:2, or unphased) |

### cons.ref.fa

FASTA file containing the reconstructed consensus sequence of the TE insertion embedded in its flanking genomic context. The `--extend_consensus 5000` flag extends flanking regions by 5 kb on each side, which:
- Preserves MM/ML methylation tags in the realigned te.bam
- Captures wider phasing context (HP/PS tags)
- Enables methylartist to plot methylation across the full insertion and flanks

### te.bam

Mini-BAM containing reads realigned to the cons.ref.fa. These BAMs:
- Retain methylation modification tags (MM/ML) from the original ONT basecalling
- Can be loaded in IGV for visual inspection of individual insertions
- Are used by methylartist for per-insertion methylation analysis

### methylartist.cmd

Each file contains two ready-to-run commands:
1. `methylartist locus` — generates a per-read methylation plot across the insertion
2. `methylartist segmeth` — generates segment-level methylation summary

These reference the te.bam, cons.ref.fa, and bed files for the corresponding insertion.

### bed

BED file with the coordinates of the TE insertion within the consensus reference sequence. Used by methylartist to highlight the TE region in plots.

---

## 3. Pickle Files (Clustering Intermediates)

| File Pattern | Count | Total Size |
|---|---|---|
| `*.pickle` | 1,759 | **24 GB** |

Python pickle files from the clustering phase (`--keep_pickles`). One per chromosome/contig (including alt contigs and HLA alleles like `HLA-B*54:01:01.pickle`). These contain the serialized read cluster objects and are useful for:
- Debugging clustering behavior
- Re-running the detail/annotation phase without re-clustering
- Inspecting intermediate data programmatically

**These dominate disk usage (77% of total).** They can be safely deleted after confirming results are satisfactory.

---

## 4. Disk Usage Summary

| Component | Size | % of Total |
|-----------|------|-----------|
| Pickle files | 24 GB | 77% |
| te.bam files | 142 MB | <1% |
| cons.ref.fa files | 13 MB | <1% |
| Main table | 11 MB | <1% |
| detail.out files | 6 MB | <1% |
| Other (bed, cmd, fai, bai) | <1 MB | <1% |
| **Total** | **~31 GB** | |

---

## 5. Biological Interpretation

### Expected Results Context

- **AluYa5 dominates** (940/1,528 PASS = 62%) — the most active Alu subfamily in humans, consistent with known retrotransposition rates
- **L1Ta is the primary LINE-1** (141 PASS) — the only currently retrotransposition-competent L1 subfamily; L1PA2 (14) are older, mostly fixed insertions
- **SVA_A is the main SVA** (57 PASS) — the youngest and most polymorphic SVA subfamily
- **3 HERVK** — endogenous retrovirus insertions are rare and biologically significant

### What to Look For

1. **Novel insertions:** PASS insertions with NonRef=NA are potentially novel (not in the polymorphic TE database)
2. **Somatic insertions:** Re-run paired tumor/normal (SU2C-324, SU2C-342) to get somatic calls. In cancer, somatic L1 insertions are most common (especially L1Ta in 3' transductions)
3. **Methylation at insertions:** Use the methylartist.cmd files to visualize CpG methylation. TE insertions can alter local methylation patterns and affect nearby gene expression
4. **Transductions:** 5' and 3' transductions (none detected here) indicate L1-mediated mobilization of flanking genomic sequence

### Recommended Next Steps

1. Filter to PASS insertions for downstream analysis
2. Run paired tumor/normal samples for somatic classification
3. Execute methylartist commands for insertions of interest
4. Cross-reference with gene annotations to identify insertions in or near genes
5. Consider removing pickle files to reclaim 24 GB of disk space

---

## 6. tldr Command Used

```bash
tldr \
    --bams SU2C-118_TS-1963991T_On1L_LRWGS_17337_4_1_modBaseCalls_dedup_sorted.bam \
    -e /opt/tldr/ref/teref.ont.human.fa \
    -r /data1/greenbab/database/hg38/v0/Homo_sapiens_assembly38.fasta \
    -o results/SU2C-118/SU2C-118 \
    -p 4 \
    -n /opt/tldr/ref/nonref.collection.hg38.chr.bed.gz \
    --somatic \
    --min_te_len 100 \
    --max_cluster_size 100 \
    --trdcol \
    --detail_output \
    --extend_consensus 5000 \
    --methylartist \
    --keep_pickles \
    --color_consensus
```

### Key Flags

| Flag | Value | Purpose |
|------|-------|---------|
| `--extend_consensus` | 5000 | Extend flanking context by 5 kb for methylation/phasing tag preservation |
| `--methylartist` | — | Generate ready-to-run methylartist commands per insertion |
| `--somatic` | — | Run GMM-based somatic/germline classification |
| `--detail_output` | — | Generate per-insertion te.bam, cons.ref.fa, and detail.out files |
| `--keep_pickles` | — | Retain per-chromosome clustering pickle files |
| `--color_consensus` | — | Color-code consensus sequences (no PNG output observed) |
| `--trdcol` | — | Detect 3' transductions using column-based method |
| `--min_te_len` | 100 | Minimum TE alignment length to classify |
| `--max_cluster_size` | 100 | Maximum reads per cluster (prevents runaway at high-coverage loci) |
| `-n` | nonref.collection.hg38.chr.bed.gz | Known polymorphic TE database (107,205 sites) |

---

## 7. Reading a Methylartist Locus Plot

The `methylartist locus` command (generated by tldr's `--methylartist` flag) produces a multi-panel figure showing per-read and aggregate CpG methylation across a TE insertion and its flanking genomic context. This section describes each panel using insertion `e5677931` (AluYb9) as an example.

**Reference plot:** `SU2C-118_TS-1963991T...e5677931...te.e5677931_0_8088.hm.ms1.smw20.mt0.8.ct0.8.locus.meth.png`

**Source code references:** methylartist codebase at `/data1/greenbab/users/ahunos/apps/methylartist/methylartist`

### Filename Decoding

The plot filename encodes key parameters:

| Token | Meaning |
|-------|---------|
| `hm` | Modification types plotted: `h` (5hmC) and `m` (5mC) |
| `ms1` | Modspace step size = 1 |
| `smw20` | Smoothing window size = 20 CpG sites |
| `mt0.8` | Methylation threshold = 0.8 (p_mod > 0.8 to call "methylated") |
| `ct0.8` | Canonical threshold = 0.8 (p_canonical > 0.8, i.e. p_mod < 0.2, to call "unmethylated") |

### Panel 1 (Top) — Per-Read Methylation Lollipop Plot

- **X-axis:** Position along the consensus reference sequence (0 to ~8,088 bp). This is the `cons.ref.fa` built by tldr — the AluYb9 insertion embedded in ~5 kb of flanking genomic reference on each side (from `--extend_consensus 5000`).
- **Each horizontal line** = one ONT read aligned to the consensus.
- **Circles at CpG sites** represent thresholded methylation calls:
  - **Filled black circles** = methylated CpG (`p_mod > 0.8`, `methstate = 1`; source: line 4609, `facecolor='black'`)
  - **Open circles with colored edge** = unmethylated CpG (`p_mod < 0.2`, `methstate = -1`; source: line 4605, `facecolor='white', edgecolor=sample_color`). The edge color matches the modification type (orange for 5mC, blue for 5hmC).
  - **Ambiguous calls** (0.2 < p_mod < 0.8) are **excluded** — they do not appear on the plot (source: line 1623, `if methstate == 0: continue`).
- **Color of reads and circles:**
  - **Orange** = 5mC (5-methylcytosine) — the `.te.m` "sample" in the legend
  - **Blue** = 5hmC (5-hydroxymethylcytosine) — the `.te.h` "sample" in the legend
  - These are NOT haplotypes or separate samples. Methylartist discovers all modification types in the BAM's MM/ML tags and creates a separate "sample" per modification type (source: line 3966, `bamname = basename + '.' + mod`). ONT dorado basecalling with `5mCG_5hmCG` produces both `m` and `h` mod codes.
- **Light blue shaded column** (~2,778-3,093 bp) = the AluYb9 TE insertion region, from the `-l` (highlight) argument which comes from the `.bed` file.
- **"AluYb9>>"** label = TE subfamily and forward-strand orientation.

### Panel 2 — Genomic-to-CpG Coordinate Translation

- This panel maps **genomic coordinates** (Panel 1 x-axis, 0-8,088 bp) to **CpG-index space** (Panel 4 x-axis, CpG sites numbered 0-57).
- **Each connecting line** links the same CpG site in both coordinate systems (source: lines 4656-4704).
- **Purpose:** CpGs are unevenly distributed in the genome — the Alu element has many CpGs clustered together while flanking regions have sparse CpGs. This panel shows how the non-linear mapping compresses CpG-dense regions and expands CpG-sparse regions.
- Lines are colored to match the highlighted TE region in both coordinate spaces.

### Panel 3 — Raw Modification Probability per CpG (modstat)

- **Y-axis:** `modstat` — the **per-CpG modification probability** (0 to 1 scale). Despite the internal variable name `llrs` (a legacy from nanopolish/megalodon LLR support), for BAMs with MM/ML tags this value is simply `p_mod = ML_tag / 255` (source: line 1170, `p_mod = score/255`).
- **Seaborn lineplot** (source: line 4762) shows the **mean modification probability across all reads at each CpG position**, with shaded 95% confidence bands.
- **Orange line** (`.te.m`) = mean 5mC probability per CpG site
- **Blue line** (`.te.h`) = mean 5hmC probability per CpG site
- **Dashed lines** at 0.0 and 1.0: for methbam mode these are simply the probability bounds (source: lines 4749-4756; for non-methbam/database mode, these would be meaningful LLR cutoffs).
- **Light blue highlight** = TE insertion region in CpG-index space.

### Panel 4 (Bottom) — Smoothed Binary Methylation Fraction

- **X-axis:** CpG site index (0-57) — each numbered position is one CpG across the full locus.
- **Y-axis:** Methylation fraction (0-1) — the **fraction of thresholded CpG calls that are methylated** within a sliding window.
- **How it's computed** (source: `slide_window()`, lines 2021-2049):
  1. A sliding window of 20 CpGs (`smw20`) moves across the locus.
  2. Within each window, counts CpG calls classified as methylated (`call == 1`, i.e. `p_mod > 0.8`) and unmethylated (`call == -1`, i.e. `p_mod < 0.2`).
  3. Computes `meth_count / (meth_count + unmeth_count)`. **Ambiguous calls (0.2-0.8) are excluded from both numerator and denominator.**
  4. The result is then smoothed (source: line 4815).
- **Orange curve** = 5mC methylation fraction across the locus.
- **Blue curve** (near zero) = 5hmC fraction.
- **Colored bar at bottom** marks the CpG sites that fall within the TE insertion.
- **White overlay segments** (if present) mask regions with insufficient coverage (source: line 4848).

### Understanding the X-Axes: Two Coordinate Systems

The plot uses **two distinct coordinate systems** across its panels. Understanding which panel uses which is essential for reading the figure.

#### Coordinate System 1: Genomic position on cons.ref.fa (`orig_loc`)

Used by **Panel 1** (top) and the **top edge of Panel 2**.

- Values represent **base-pair positions** along the consensus reference sequence (0 to ~8,088 bp for this insertion).
- Tick labels are computed as `int(tick_position + elt_start)` (source: line 4724). So `646, 1381, 2116, 2851, ...` are evenly spaced bp positions.
- **The first tick label is replaced by the contig name** (source: line 4725: `xt_labels[0] = chrom`). So `e5677931` is not a coordinate — it's the contig name (the UUID prefix from the cons.ref.fa FASTA header).
- ax0 (annotation) and ax1 (lollipop) are synced to ax3's xlim (source: lines 4706-4707).

#### Coordinate System 2: Dense-ranked CpG site index (`loc`)

Used by **Panel 3** (modstat), **Panel 4** (bottom, smoothed methylation), and the **bottom edge of Panel 2**.

- Created by `scipy.stats.rankdata(positions, method='dense')` (source: line 3991). Each unique CpG genomic position gets a consecutive integer (1, 2, 3, ..., N).
- For this locus, values range from **0 to ~57**, meaning there are approximately **57 unique CpG sites** distributed across the 8,088 bp consensus reference.
- ax4 (modstat) and ax5 (smoothed methylation) are both synced to ax2's xlim (source: lines 4767, 4901).
- The tick labels `0, 10, 20, 30, 40, 50` are simply the CpG site number (the Nth CpG from left to right).

#### Panel 2: The Bridge

Panel 2 (connecting lines) has **two x-axes** because it bridges the two spaces:
- **Top edge (ax3):** genomic coordinates, same as Panel 1 — created as `ax3 = ax2.twiny()` (source: line 4660)
- **Bottom edge (ax2):** CpG-index, same as Panels 3 and 4

Each connecting line links the same CpG site between both coordinate systems. Where CpGs are sparse in the genome (long gaps between CpG dinucleotides), the lines fan outward. Where CpGs are dense (e.g., within the CpG-rich Alu element), the lines compress together.

#### Why two coordinate systems?

Genomic space has highly variable CpG density. The AluYb9 body (~315 bp) contains many CpGs packed closely together, while the 5 kb flanking regions have sparse CpGs. If methylation were plotted in genomic coordinates, CpG-dense regions would be crammed into a tiny space and CpG-sparse regions would waste plot area. The CpG-index space gives **equal visual weight to each CpG site**, making methylation patterns across the full locus much easier to read.

### Example Interpretation (e5677931, AluYb9)

In this plot:
- The **AluYb9 insertion** (highlighted, CpG sites ~12-30) shows **elevated 5mC methylation (~0.4-0.6)** compared to flanking genomic regions (~0.1-0.2).
- **5hmC (blue) is near zero** throughout — typical for repetitive elements, as hydroxymethylation is primarily found at gene bodies and regulatory regions.
- Within the TE region in Panel 1, many orange reads have filled (methylated) CpGs, while blue reads have mostly open (unmethylated) circles — consistent with CpG methylation being 5mC-driven.
- This pattern is consistent with **normal TE silencing via CpG methylation**: Alu elements are typically heavily methylated in somatic cells as part of the host defense against retrotransposition.

---

## 8. Coding Gene vs TE Repeat Methylation: TP53 Comparison

To understand how methylartist locus plots differ between coding genes and TE insertions, we generated a locus plot for the **TP53 tumor suppressor** (chr17:7668421-7687490, padded 500 bp each side) from the same SU2C-118 BAM used by tldr.

**Plot:** [`docs/methylartist_plots/SU2C-118_TP53_locus.png`](methylartist_plots/SU2C-118_TP53_locus.png)
**Script:** [`docs/methylartist_plots/plot_TP53_locus.sh`](methylartist_plots/plot_TP53_locus.sh)

### Command

```bash
methylartist locus \
    -i chr17:7667921-7687990 \
    -l 7668421-7687490 \
    -b <SU2C-118 BAM> \
    -r Homo_sapiens_assembly38.fasta \
    -g tp53_region.gtf.gz \
    --motif CG \
    --labelgenes \
    --show_transcripts \
    -o SU2C-118_TP53_locus
```

The full gencode GTF (`gencode.v47.annotation.gtf.gz`) is gzip-compressed, not bgzf, so it cannot be tabix-indexed directly. The script extracts the TP53 region, sorts, bgzips, and indexes it before passing it to methylartist. See `plot_TP53_locus.sh` for the complete reproducible workflow.

### Structural Differences

| Feature | TP53 (coding gene) | AluYb9 e5677931 (TE insertion) |
|---------|--------------------|---------------------------------|
| **Gene annotation panel** | Exon/intron structure for 33 TP53 isoforms + 5 WRAP53 isoforms (minus strand arrows) | TE position/orientation label (`AluYb9>>`) only |
| **X-axis coordinates** | Real chromosomal (`chr17:7668927-7687167`) | Synthetic contig on `cons.ref.fa` (`e5677931, 646, 1381...`) |
| **Locus size** | ~20 kb genomic | ~8 kb consensus reference |
| **CpG sites** | 443 (~22 CpGs/kb) | 57 (~7 CpGs/kb) |
| **Read count** | High (full WGS coverage across reference genome) | Low (only insertion-supporting reads realigned to cons.ref.fa) |
| **Highlight region** | TP53 gene body (light blue) | AluYb9 TE body (light blue) |

### Methylation Pattern Differences

| Feature | TP53 | AluYb9 |
|---------|------|--------|
| **5mC level** | High throughout (~0.85-0.90 gene body, dips to ~0.65 near promoter) | Moderate (~0.4-0.6) |
| **5mC spatial pattern** | **Gradient** — high in 3' gene body (left), decreases toward 5' promoter (right); reflects CpG island biology | **Relatively uniform** within and around the TE body |
| **5hmC** | Near zero throughout | Near zero throughout |
| **Per-read view** | Dense filled circles (heavy methylation), especially in the 3' portion | Mix of filled and open circles (heterogeneous methylation) |

### Biological Interpretation

#### TP53 (minus strand: left = 3' end, right = 5'/promoter)

- **Gene body** is heavily 5mC-methylated (~0.85-0.90) — **normal** for actively transcribed genes; gene body methylation is positively correlated with expression.
- The **dip around CpG ~300-350** (right side of plot) likely corresponds to the **TP53 promoter CpG island**, which shows reduced methylation (~0.65). Promoter CpG islands of active tumor suppressors should be unmethylated.
- However, the promoter methylation does not drop to near-zero, suggesting **some degree of promoter methylation** in this tumor — worth investigating further, as TP53 promoter hypermethylation is one mechanism of tumor suppressor silencing.
- **5hmC is essentially absent** — global 5hmC loss is a hallmark of cancer.

#### AluYb9 TE insertion (e5677931)

- Moderate 5mC methylation (~0.4-0.6) is consistent with **TE silencing via CpG methylation** — retrotransposons are normally methylated as a host defense against retrotransposition.
- More **uniform** pattern — TEs lack the promoter/gene-body architecture of coding genes.
- Lower CpG density in flanking genomic DNA creates the characteristic fanning pattern in the coordinate bridge panel.

#### Key Takeaways

1. **Coding gene loci** show structured methylation gradients (gene body vs promoter CpG island) that reflect transcriptional regulation.
2. **TE insertion loci** show more uniform methylation reflecting epigenetic silencing of the repeat element.
3. **CpG density** differs dramatically: genes like TP53 have dense CpGs (~22/kb), while TE insertions with flanking genomic context average ~7 CpGs/kb.
4. **Read coverage** differs because TE locus plots use mini-BAMs (only insertion-supporting reads realigned to a synthetic consensus) while gene locus plots use the full WGS BAM aligned to the reference genome.
