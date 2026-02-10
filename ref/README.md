# TLDR Reference Datasets

**Author:** Samuel Ahuno (ekwame001@gmail.com)
**Date:** 2026-02-09

This directory contains the transposable element (TE) reference sequences and known non-reference TE insertion databases used by `tldr`.

---

## 1. TE Reference FASTA Files

Consensus sequences for active/recent TE families. Used by `tldr -e` to classify detected insertions by superfamily and subfamily. Headers follow the format `>Superfamily:Subfamily`.

### teref.ont.human.fa (ONT-optimized, human)

**Use for:** Oxford Nanopore long-read data aligned to hg19 or hg38.
Trimmed versions of the standard human references, optimized for ONT error profiles (shorter flanking sequence).

| Superfamily | Subfamily | Length (bp) |
|-------------|-----------|-------------|
| ALU | AluYa5 | 296 |
| ALU | AluYa8 | 295 |
| ALU | AluYb8 | 303 |
| ALU | AluYb9 | 303 |
| SVA | SVA_A | 1,427 |
| SVA | SVA_B | 1,423 |
| SVA | SVA_C | 1,417 |
| SVA | SVA_D | 1,419 |
| SVA | SVA_E | 1,415 |
| SVA | SVA_F | 1,408 |
| L1 | L1Ta | 6,037 |
| L1 | L1preTa | 6,042 |
| L1 | L1PA2 | 902 |
| ERV | HERVK | 9,371 |

**14 sequences, 4 superfamilies**

### teref.human.fa (standard, human)

**Use for:** PacBio or short-read data aligned to hg19 or hg38.
Same 14 entries as the ONT version but with longer flanking context around Alu, SVA, and L1 elements.

| Superfamily | Subfamily | Length (bp) |
|-------------|-----------|-------------|
| ALU | AluYa5 | 381 |
| ALU | AluYa8 | 380 |
| ALU | AluYb8 | 388 |
| ALU | AluYb9 | 388 |
| SVA | SVA_A | 1,474 |
| SVA | SVA_B | 1,470 |
| SVA | SVA_C | 1,464 |
| SVA | SVA_D | 1,466 |
| SVA | SVA_E | 1,462 |
| SVA | SVA_F | 1,455 |
| L1 | L1Ta | 6,122 |
| L1 | L1preTa | 6,127 |
| L1 | L1PA2 | 902 |
| ERV | HERVK | 9,371 |

**14 sequences, 4 superfamilies** (L1PA2 and HERVK are identical between standard and ONT versions)

### teref.mouse.fa (mouse)

**Use for:** Mouse long-read data aligned to mm10.

| Superfamily | Subfamily | Length (bp) |
|-------------|-----------|-------------|
| L1 | L1Md_TFIII | 6,687 |
| L1 | L1MdA_I | 6,664 |
| L1 | L1MdGf_I | 7,185 |
| L1 | L1MdTf_I | 7,498 |
| L1 | L1MdTf_II | 7,215 |
| LTR | IAP_LTR | 292 |
| LTR | Etn_LTR | 323 |
| LTR | RLTR4_MM | 742 |
| LTR | IAPLTR1a_MM | 337 |
| LTR | IAPLTR1_Mm_LTR | 367 |
| SINE | B1 | 168 |
| SINE | B2 | 215 |

**12 sequences, 3 superfamilies**

---

## 2. Known Non-Reference TE Insertion Databases

Tabix-indexed BED files of previously catalogued non-reference TE insertion sites. Used by `tldr -n` to annotate detected insertions against known polymorphic sites.

**BED format:** `chrom  start  end  TE_family  source(s)`

Each file has a corresponding `.tbi` tabix index.

### Chromosome naming variants

Each genome build has two variants — pick the one matching your reference genome's chromosome naming:

| Variant | Chromosome format | Example |
|---------|-------------------|---------|
| `*.bed.gz` | No prefix | `1`, `2`, ..., `X`, `Y` |
| `*.chr.bed.gz` | `chr` prefix | `chr1`, `chr2`, ..., `chrX`, `chrY` |

### Human hg38

| File | Entries | Chr prefix |
|------|---------|------------|
| `nonref.collection.hg38.bed.gz` | 107,205 | No |
| `nonref.collection.hg38.chr.bed.gz` | 107,205 | Yes |

**TE family breakdown (hg38):**

| Family | Count |
|--------|-------|
| ALU | 84,648 |
| L1 | 15,149 |
| SVA | 7,096 |
| Composite (multi-family) | 312 |

**Data sources** (column 5, author abbreviations with year):

| Source | Entries | Reference |
|--------|---------|-----------|
| RC2020 | 63,687 | Rodriguez-Martin et al. 2020 |
| DW2013 | 10,197 | Wildschutte et al. 2013 |
| PS2015 | 3,960 | Sudmant et al. 2015 |
| SW2020 | 3,724 | Watkins et al. 2020 |
| EL2012 | 1,850 | Lee et al. 2012 |
| EH2014 | 1,269 | Helman et al. 2014 |
| FH2011 | 1,117 | Huang et al. 2011 |
| RS2013 | 994 | Stewart et al. 2013 |
| CS2011 | 605 | Stewart et al. 2011 |
| Others | various | Multiple studies |

Entries with comma-separated sources (e.g., `PS2015,RC2020`) were detected independently in multiple studies.

### Human hg19

| File | Entries | Chr prefix |
|------|---------|------------|
| `nonref.collection.hg19.bed.gz` | 107,447 | No |
| `nonref.collection.hg19.chr.bed.gz` | 107,447 | Yes |

Liftover of the same dataset to hg19 coordinates (slightly more entries due to coordinate mapping differences).

### Mouse mm10

| File | Entries | Chr prefix |
|------|---------|------------|
| `nonref.collection.mm10.bed.gz` | 151,157 | No |
| `nonref.collection.mm10.chr.bed.gz` | 151,157 | Yes |

**TE family breakdown (mm10):**

| Family | Count |
|--------|-------|
| L1 | 73,023 |
| SINE | 50,578 |
| LTR | 27,556 |

Source column contains mouse strain names (e.g., `BALB_cJ`, `C57BL_6NJ`, `CAST_EiJ`). Entries with comma-separated strains indicate the insertion is polymorphic across multiple strains.

---

## 3. Which Files to Use

| Scenario | TE reference (`-e`) | Non-ref DB (`-n`) |
|----------|---------------------|--------------------|
| Human ONT, hg38 (`chr` prefix) | `teref.ont.human.fa` | `nonref.collection.hg38.chr.bed.gz` |
| Human ONT, hg38 (no prefix) | `teref.ont.human.fa` | `nonref.collection.hg38.bed.gz` |
| Human PacBio/other, hg38 | `teref.human.fa` | `nonref.collection.hg38.chr.bed.gz` |
| Human, hg19 (`chr` prefix) | `teref.human.fa` | `nonref.collection.hg19.chr.bed.gz` |
| Human, hg19 (no prefix) | `teref.human.fa` | `nonref.collection.hg19.bed.gz` |
| Mouse, mm10 (no prefix) | `teref.mouse.fa` | `nonref.collection.mm10.bed.gz` |
| Mouse, mm10 (`chr` prefix) | `teref.mouse.fa` | `nonref.collection.mm10.chr.bed.gz` |

**Important:** The chromosome naming in your non-ref BED file **must match** the chromosome naming in your aligned BAM and reference FASTA. Use `samtools idxstats your.bam | head -1` to check.

---

## 4. File Sizes Summary

| File | Size |
|------|------|
| `teref.ont.human.fa` | 32 KB |
| `teref.human.fa` | 33 KB |
| `teref.mouse.fa` | 38 KB |
| `nonref.collection.hg38.chr.bed.gz` (+.tbi) | 1.1 MB + 585 KB |
| `nonref.collection.hg38.bed.gz` (+.tbi) | 1.0 MB + 582 KB |
| `nonref.collection.hg19.chr.bed.gz` (+.tbi) | 1.1 MB + 587 KB |
| `nonref.collection.hg19.bed.gz` (+.tbi) | 1.0 MB + 584 KB |
| `nonref.collection.mm10.chr.bed.gz` (+.tbi) | 1.7 MB + 662 KB |
| `nonref.collection.mm10.bed.gz` (+.tbi) | 1.7 MB + 644 KB |
| **Total** | **~12 MB** |
