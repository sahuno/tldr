
# List of feature request

program should detect index files with extensions `.bam.bai` and `.bai`
```
(tldr) bash:iscf030:tldr 3379 $ mda
bash:iscf030:tldr 3380 $ mamba activate tldr
(tldr) bash:iscf030:tldr 3381 $ ./test/run_test_hg38_SU2C118.sh quick
[2026-02-09 16:38:54] === TLDR Full Pipeline Test ===
[2026-02-09 16:38:54] Test mode: quick
[2026-02-09 16:38:54] Sample: SU2C-118_TS-1963991T
[2026-02-09 16:38:54] BAM: /data1/collab001/janjigian_su2c/WGS-ONT/sam/DNAme_prod/results/IRIS_files/results/methylation_basecalling/mark_duplicates/SU2C-118_TS-1963991T_On1L_LRWGS_17337_4_1/SU2C-118_TS-1963991T_On1L_LRWGS_17337_4_1_modBaseCalls_dedup_sorted.bam
[2026-02-09 16:38:54] Reference: /data1/greenbab/database/hg38/v0/Homo_sapiens_assembly38.fasta
[2026-02-09 16:38:54] TE Reference: /data1/greenbab/users/ahunos/apps/tldr/ref/teref.ont.human.fa
[2026-02-09 16:38:54] Non-ref DB: /data1/greenbab/users/ahunos/apps/tldr/ref/nonref.collection.hg38.chr.bed.gz
ERROR: File not found: /data1/collab001/janjigian_su2c/WGS-ONT/sam/DNAme_prod/results/IRIS_files/results/methylation_basecalling/mark_duplicates/SU2C-118_TS-1963991T_On1L_LRWGS_17337_4_1/SU2C-118_TS-1963991T_On1L_LRWGS_17337_4_1_modBaseCalls_dedup_sorted.bam.bai
(tldr) bash:iscf030:tldr 3382 $ less 1/greenbab/users/ahunos/apps/tldr/ref/nonref.collection.hg38.chr.bed.gz
1/greenbab/users/ahunos/apps/tldr/ref/nonref.collection.hg38.chr.bed.gz: No such file or directory
(tldr) bash:iscf030:tldr 3383 $ l 1/greenbab/users/ahunos/apps/tldr/ref/nonref.collection.hg38.chr.bed.gz
ls: cannot access '1/greenbab/users/ahunos/apps/tldr/ref/nonref.collection.hg38.chr.bed.gz': No such file or directory
(tldr) bash:iscf030:tldr 3384 $ 
```
