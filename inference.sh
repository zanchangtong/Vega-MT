#!/bin/bash
export LC_ALL=C.UTF-8 
SRC=en
TGT=zh

raw_ref=
raw_src=
model_dir=
SPM_MODEL=scripts/en.spm.bpe.model 
lang_pairs=$SRC-$TGT
lang_list=$model_dir/lang_list.txt

export CUDA_VISIBLE_DEVICES=0
cat ${raw_src} | scripts/replace-unicode-punctuation.perl | scripts/normalize-punctuation.perl -l ${SRC} | fairseq-interactive $model_dir \
    --path $model_dir/vega_mt.enzh.pt \
    --task translation_multi_simple_epoch \
    --lang-dict "$lang_list" \
    --lang-pairs "$lang_pairs" \
    --bpe "sentencepiece" \
    --sentencepiece-model ${SPM_MODEL} \
    --buffer-size 1024 \
    --batch-size 40 -s $SRC -t $TGT \
    --decoder-langtok \
    --encoder-langtok src \
    --beam 5 \
    --lenpen 1.0 \
    --fp16 > ./${SRC}-${TGT}.gen_log

cat ./$SRC-$TGT.gen_log | grep -P "^D-" | cut -f3 > ./$SRC-$TGT.$TGT.hyp
python scripts/symbol_half2full.py --input ./$SRC-$TGT.$TGT.hyp > ./$SRC-$TGT.$TGT.post.hyp

sacrebleu ${raw_ref} -i ./$SRC-$TGT.$TGT.post.hyp -l "${SRC}-${SRC}"

