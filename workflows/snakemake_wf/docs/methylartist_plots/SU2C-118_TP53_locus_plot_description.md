# SU2C-118 TP53 Methylartist Locus Plot Description

**Date:** 2026-02-10
**Author:** Samuel Ahuno
**Plot:** `SU2C-118_TP53_locus_promoter_highlight.png`
**Script:** `plot_TP53_locus.sh`
**Sample:** SU2C-118_TS-1963991T_On1L_LRWGS_17337_4_1
**Genome:** hg38
**Locus:** chr17:7,667,921-7,687,990 (TP53 gene body + 500 bp padding each side)
**Promoter highlight:** TSS +/- 500 bp (chr17:7,686,990-7,687,990)

---

## Command

```bash
methylartist locus \
    -i chr17:7667921-7687990 \
    -l 7686990-7687990 \
    -b SU2C-118_..._modBaseCalls_dedup_sorted.bam \
    -r Homo_sapiens_assembly38.fasta \
    -g tp53_canonical.gtf.gz \
    --motif CG \
    --labelgenes \
    --show_transcripts \
    --exonheight 1.5 \
    -p 3,5,1,3,3 \
    --height 20 --width 20 \
    -o SU2C-118_TP53_locus_promoter_highlight
```

Key flags:
- `-g tp53_canonical.gtf.gz`: GTF filtered to only the canonical TP53-201 transcript (ENST00000269305, MANE Select) to avoid clutter from 33+ isoforms.
- `-l 7686990-7687990`: Highlights the promoter region (TSS +/- 500 bp). TP53 is on the **minus strand**, so the TSS is at the **end coordinate** (7,687,490).
- `-p 3,5,1,3,3`: Panel height ratios — gene:lollipop:bridge:modstat:smoothed = 3:5:1:3:3.
- `--exonheight 1.5`: Thicker exon blocks for visibility.

---

## Panel-by-Panel Description

### Panel 1 — Gene Annotation (top)

- Shows the **canonical TP53-201 transcript** (ENST00000269305) as a single clean gene model.
- **Teal blocks** = exons. The largest block at far left is **exon 11** (3'UTR + last coding exon, chr17:7,668,421-7,669,690). Progressively smaller coding exons span the gene body to the right.
- **Thin teal line** connecting exons = introns.
- **`<<TP53-201`** label with left-pointing arrows confirms **minus-strand** orientation — transcription proceeds right-to-left (from high to low genomic coordinates).
- **11 exons** are visible, matching the known TP53 canonical structure.
- The far-right exon (exon 1, chr17:7,687,377-7,687,490) is the 5'UTR/first exon at the TSS.

### X-axis (top): Genomic Coordinates

- **`chr17`** label at far left, followed by bp positions: `7668923, 7670747, 7672571, ... 7687163`.
- These are real chromosomal coordinates on the hg38 reference genome.
- The total interval spans **20,069 bp** (~20 kb).

### Panel 2 — Per-Read Methylation Lollipop Plot

- Each horizontal line = one ONT read aligned to the reference.
- **Circles at CpG sites** represent thresholded methylation calls:
  - **Filled black circles** = methylated (p_mod > 0.8)
  - **Open circles with colored edge** = unmethylated (p_mod < 0.2)
  - Ambiguous calls (0.2 < p_mod < 0.8) are excluded.
- **Orange reads/circles** = 5mC (5-methylcytosine), the `.m` sample.
- **Blue reads/circles** = 5hmC (5-hydroxymethylcytosine), the `.h` sample.
- **Observations:**
  - The left two-thirds of the locus (gene body, exons 11-2) shows predominantly **filled black circles on orange reads** = heavy 5mC methylation.
  - The right portion near the promoter highlight shows a **transition to open orange circles** = reduced methylation approaching the promoter CpG island.
  - Blue reads (5hmC) show predominantly **open blue circles** throughout = very low hydroxymethylation.
  - Reads in the promoter highlight region (light blue column, far right) have a visible mix of filled and open circles, suggesting heterogeneous methylation at the promoter.

### Panel 3 — Coordinate Bridge (Genomic-to-CpG Index Translation)

- **Top edge**: genomic coordinates (same as Panel 1 x-axis, ~7,668,000-7,688,000 bp).
- **Bottom edge**: CpG-index (0 to ~443, same as Panels 4 and 5).
- **Connecting lines** link each CpG site between the two coordinate systems.
- **Observations:**
  - Lines are relatively evenly spaced across most of the locus, reflecting the **fairly uniform CpG density** in this gene-rich region (~22 CpGs/kb).
  - The right side (near the promoter) shows denser blue lines, consistent with the **CpG island** at the TP53 promoter having higher CpG density.
  - This is a much denser bridge than the AluYb9 TE plot (443 vs 57 CpGs), explaining the more "filled-in" appearance.

### Panel 4 — Raw Modification Probability (modstat)

- **Y-axis:** `modstat` = per-CpG modification probability (0 to 1). This is `p_mod = ML_tag / 255` averaged across all reads at each CpG, with seaborn 95% confidence bands.
- **X-axis:** CpG-index (0 to ~443), same as bottom panel.
- **Orange line** (`.m`, 5mC): Fluctuates mostly between 0.4-0.8 across the gene body, with high variability. Notable dips appear at certain CpG positions.
- **Blue line** (`.h`, 5hmC): Consistently low, near 0.0-0.1.
- **Light blue column** (right): The promoter highlight region in CpG-index space.
- **Dashed lines** at 0.0 and 1.0: Probability bounds.

### Panel 5 — Smoothed Binary Methylation Fraction (bottom)

- **Y-axis:** Methylation fraction (0.0 to 1.0) — the fraction of thresholded calls that are methylated, computed by `slide_window()` across a sliding window of 26 CpGs (auto-set `smw=26`).
- **X-axis:** CpG-index (0 to ~443).
- **Orange curve** (5mC):
  - Starts at **~0.80** at CpG 0 (3' end of gene).
  - Rises to **~0.95** around CpG 50-100.
  - Remains **high (~0.90-0.95)** across the gene body (CpG 100-250).
  - Begins a **gradual decline** around CpG 250.
  - **Sharp drop** from ~0.85 to **~0.15** between CpG 300-350.
  - Remains **low (~0.10-0.15)** through the promoter highlight region (CpG ~380-443).
  - Slight uptick at the very end (CpG ~430+) as we exit the CpG island into the 500 bp upstream padding.
- **Blue curve** (5hmC): Consistently near **0.00-0.03** throughout. No meaningful hydroxymethylation.
- **Light blue column** (right, CpG ~380-443): Promoter highlight region — clearly falls in the hypomethylated zone.
- **Colored bar at bottom**: Marks CpG sites within the highlighted promoter region.

---

## Why Does the Bottom X-Axis Go from 0 to ~450?

The bottom two panels (modstat and smoothed methylation) use **CpG-index space**, not genomic coordinates. Methylartist transforms positions via:

```python
meth_table['loc'] = scipy.stats.rankdata(meth_table['loc'], method='dense')
```

This assigns each unique CpG genomic position a consecutive integer (1, 2, 3, ..., N). The methylartist log confirms:

```
mod space positions: 443
```

So there are **443 unique CpG dinucleotides** distributed across the 20,069 bp locus, and the x-axis spans 0 to ~443 (displayed as 0, 100, 200, 300, 400).

**CpG density:** 443 CpGs / 20,069 bp = **~22 CpGs per kb**. This is much higher than the AluYb9 TE locus (57 CpGs / 8,088 bp = ~7 CpGs/kb), reflecting the gene-rich, CpG-island-containing nature of the TP53 region.

For comparison:

| Locus | Size (bp) | CpG sites | CpGs/kb | Bottom x-axis range |
|-------|-----------|-----------|---------|---------------------|
| TP53 gene + 500bp pad | 20,069 | 443 | ~22 | 0-443 |
| AluYb9 TE (e5677931) | 8,088 | 57 | ~7 | 0-57 |

---

## Biological Interpretation

### Gene Body Methylation (CpG 0-300, orange curve ~0.85-0.95)

The TP53 gene body shows **high 5mC methylation**, which is **normal and expected** for actively transcribed genes. Gene body methylation is positively correlated with transcriptional elongation — RNA Polymerase II recruits DNMT3B which deposits 5mC behind it as it transcribes. This is not silencing; it is a mark of active transcription.

### Promoter Hypomethylation (CpG 300-443, orange curve drops to ~0.10-0.15)

The sharp methylation drop at CpG ~300-350 corresponds to the **TP53 promoter CpG island**. This is the expected pattern for an active tumor suppressor:
- CpG islands at promoters of housekeeping/tumor suppressor genes are normally **unmethylated** in both normal and tumor tissue.
- The unmethylated state allows transcription factor binding and active TP53 expression.
- If this region were heavily methylated (>0.5), it would suggest **epigenetic silencing** of TP53 — a mechanism of tumor suppressor inactivation seen in some cancers.

### The Methylation Cliff (CpG ~300-350)

The transition from high gene body methylation to low promoter methylation is remarkably sharp — spanning only ~50 CpG sites. This "methylation cliff" reflects the boundary of the CpG island, which is maintained by:
- **TET enzymes** actively removing methylation at the CpG island.
- **DNMT exclusion** — CpG islands resist de novo methylation through protective chromatin marks (H3K4me3).
- **CTCF/insulator elements** that can demarcate methylation boundaries.

### 5hmC Absence (blue curve ~0.00-0.03)

5-hydroxymethylcytosine is essentially absent throughout. In **normal tissue**, some gene body 5hmC would be expected (5hmC is enriched at active gene bodies and enhancers). Global 5hmC loss is a well-established **hallmark of cancer**, driven by downregulation of TET enzymes and altered alpha-ketoglutarate metabolism.

### Comparison to AluYb9 TE Insertion

| Feature | TP53 (coding gene) | AluYb9 (TE insertion) |
|---------|--------------------|-----------------------|
| Methylation level | Gene body ~0.90, promoter ~0.15 | Uniform ~0.4-0.6 |
| Spatial pattern | Sharp gradient (gene body → promoter cliff) | Relatively uniform |
| Biological role | Gene body meth = active transcription; promoter hypomethylation = accessible | TE silencing via CpG methylation |
| CpG density | 22/kb (includes CpG island) | 7/kb |
| 5hmC | Absent (cancer hallmark) | Absent |
