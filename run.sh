#!/bin/bash
#################Transdutor Romanos

######### Uni
fstcompile --isymbols=syms.sym --osymbols=syms.sym rod_uni.txt | fstarcsort > rod_uni.fst
#fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait rod_uni.fst | dot -Tpdf  > rod_uni.pdf

######### dec
fstcompile --isymbols=syms.sym --osymbols=syms.sym rod_dec.txt | fstarcsort > rod_dec.fst
#fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait rod_dec.fst | dot -Tpdf  > rod_dec.pdf

######### cent
fstcompile --isymbols=syms.sym --osymbols=syms.sym rod_cen.txt | fstarcsort > rod_cen.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait rod_cen.fst | dot -Tpdf  > rod_cen.pdf
######### Zero
fstcompile --isymbols=syms.sym --osymbols=syms.sym rod_zero.txt | fstarcsort > rod_zero.fst
#fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait rod_zero.fst | dot -Tpdf  > rod_zero.pdf

### Concat e union para gerar estado final
fstunion rod_uni.fst rod_zero.fst > uni_zero.fst
fstconcat rod_dec.fst uni_zero.fst > dec_zero_uni.fst

fstconcat rod_cen.fst rod_zero.fst > cen_zero.fst
fstconcat cen_zero.fst rod_zero.fst  > cen_zero_zero.fst

fstunion cen_zero_zero.fst dec_zero_uni.fst > almost_final.fst
fstunion almost_final.fst rod_uni.fst > final.fst
#fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait final.fst | dot -Tpdf  > final.pdf

### invert
fstinvert final.fst > invert_final.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait invert_final.fst | dot -Tpdf  > invert_final.pdf

#################

#################
#Transdutor 1
python compact2fst.py letras.txt > letras_transdutor.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym letras_transdutor.txt | fstarcsort > letras_transdutor.fst
fstcompile --isymbols=syms.sym --osymbols=syms.sym black_space.txt | fstarcsort > black_space.fst

###operacoes transdutores
fstconcat letras_transdutor.fst black_space.fst > letras_transdutor1.fst
fstconcat invert_final.fst black_space.fst > invert_final_space.fst
fstunion invert_final_space.fst letras_transdutor1.fst > transdutor1_union.fst
fstclosure transdutor1_union.fst > transdutor1.fst

###print transdutor1
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transdutor1.fst | dot -Tpdf  > transdutor1.pdf

#################
#Transdutor 2
python compact2fst.py transdutor2.txt > transdutor2_final.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym transdutor2_final.txt | fstarcsort > transdutor2_final.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transdutor2_final.fst | dot -Tpdf  > transdutor2_final.pdf

#################
#Transdutor 3
python compact2fst.py transdutor3.txt > transdutor3_final.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym transdutor3_final.txt | fstarcsort > transdutor3_final.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transdutor3_final.fst | dot -Tpdf  > transdutor3_final.pdf

#################
#Codifier
fstarcsort --sort_type=ilabel transdutor1.fst > transdutor1sort.fst
fstcompose transdutor1sort.fst transdutor2_final.fst > transdutor1_2.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transdutor1_2.fst | dot -Tpdf  > transdutor1_2.pdf

fstcompose transdutor1_2.fst transdutor3_final.fst | fstarcsort > tranducer_cod.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait tranducer_cod.fst | dot -Tpdf  > tranducer_cod.pdf

#################
#Decode
fstinvert transdutor1sort.fst > transdutor1_invert.fst
fstinvert transdutor2_final.fst > transdutor2_invert.fst
fstinvert transdutor3_final.fst > transdutor3_invert.fst

fstcompose transdutor3_invert.fst transdutor2_invert.fst > transdutor3_2.fst
fstcompose transdutor3_2.fst transdutor1_invert.fst | fstarcsort > tranducer_decod.fst

fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait tranducer_decod.fst | dot -Tpdf  > tranducer_decod.pdf

#################

#################Test
#___________              __
# \__    ___/___   _______/  |_
#   |    |_/ __ \ /  ___/\   __\
#   |    |\  ___/ \___ \  |  |
#   |____| \___  >____  > |__|
#################

# gerar Testes
python word2fst.py 99_ > test_99_.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  test_99_.txt | fstarcsort > test_99_.fst

python word2fst.py 99_aa_ > test_99_aa_.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  test_99_aa_.txt | fstarcsort > test_99_aa_.fst

python word2fst.py batata_28_ > test_batata_28_.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  test_batata_28_.txt | fstarcsort > test_batata_28_.fst

python word2fst.py ir_tambem_ > test_ir_tambem_.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  test_ir_tambem_.txt | fstarcsort > test_ir_tambem_.fst

python word2fst.py 3513_ > test_3513_.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  test_3513_.txt | fstarcsort > test_3513_.fst

python word2fst.py 3513_XX_ > test_3513_XX_.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  test_3513_XX_.txt | fstarcsort > test_3513_XX_.fst

python word2fst.py bXtXtX_332111_ > test_bXtXtX_332111_.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  test_bXtXtX_332111_.txt | fstarcsort > test_bXtXtX_332111_.fst

python word2fst.py Vr_tX79m_ > test_Vr_tX79m_.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  test_Vr_tX79m_.txt | fstarcsort > test_Vr_tX79m_.fst


#teste 1o transdutor
fstcompose test_99_.fst transdutor1.fst | fstrmepsilon > result_XCIX_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_XCIX_.fst | dot -Tpdf  > result_XCIX_.pdf

fstcompose test_99_aa_.fst transdutor1.fst | fstrmepsilon > result_XCIX_aa_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_XCIX_aa_.fst | dot -Tpdf  > result_XCIX_aa_.pdf

fstcompose test_batata_28_.fst transdutor1.fst | fstrmepsilon > result_batata_XXVIII_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_batata_XXVIII_.fst | dot -Tpdf  > result_batata_XXVIII_.pdf

fstcompose test_ir_tambem_.fst transdutor1.fst | fstrmepsilon > result_ir_tambem_trans1.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_ir_tambem_trans1.fst | dot -Tpdf  > result_ir_tambem_trans1.pdf


# teste 2o transdutor
fstcompose result_XCIX_aa_.fst transdutor2_final.fst | fstrmepsilon > result_3513_aa_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_3513_aa_.fst | dot -Tpdf  > result_3513_aa_.pdf

fstcompose result_XCIX_.fst transdutor2_final.fst | fstrmepsilon > result_3513_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_3513_.fst | dot -Tpdf  > result_3513_.pdf

fstcompose result_batata_XXVIII_.fst transdutor2_final.fst | fstrmepsilon > result_batata_332111_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_batata_332111_.fst | dot -Tpdf  > result_batata_332111_.pdf

fstcompose result_ir_tambem_trans1.fst transdutor2_final.fst | fstrmepsilon > result_ir_tambem_trans2.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_ir_tambem_trans1.fst | dot -Tpdf  > result_ir_tambem_trans1.pdf


# testes 3o transdutor
fstcompose result_3513_aa_.fst transdutor3_final.fst | fstrmepsilon > result_3513_XX_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_3513_XX_.fst | dot -Tpdf  > result_3513_XX_.pdf

fstcompose result_3513_.fst transdutor3_final.fst | fstrmepsilon > result_3513_1.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_3513_1.fst | dot -Tpdf  > result_3513_1.pdf

fstcompose result_batata_332111_.fst transdutor3_final.fst | fstrmepsilon > result_bXtXtX_332111_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_bXtXtX_332111_.fst | dot -Tpdf  > result_bXtXtX_332111_.pdf

fstcompose result_ir_tambem_trans2.fst transdutor3_final.fst | fstrmepsilon > result_Vr_tX79m_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_Vr_tX79m_.fst | dot -Tpdf  > result_Vr_tX79m_.pdf


# tests Codificador
fstcompose test_99_aa_.fst tranducer_cod.fst | fstrmepsilon > result_cod_3513_XX_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_cod_3513_XX_.fst | dot -Tpdf  > result_cod_3513_XX_.pdf

fstcompose test_99_.fst tranducer_cod.fst | fstrmepsilon > result_cod_3513_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_cod_3513_.fst | dot -Tpdf  > result_cod_3513_.pdf

fstcompose test_batata_28_.fst tranducer_cod.fst | fstrmepsilon > result_cod_bXtXtX_332111_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_cod_bXtXtX_332111_.fst | dot -Tpdf  > result_cod_bXtXtX_332111_.pdf

fstcompose test_ir_tambem_.fst tranducer_cod.fst | fstrmepsilon > result_cod_Vr_tX79m_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_cod_Vr_tX79m_.fst | dot -Tpdf  > result_cod_Vr_tX79m_.pdf

#tests Decode
fstcompose test_3513_.fst tranducer_decod.fst | fstrmepsilon > result_decod_3513_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_decod_3513_.fst | dot -Tpdf  > result_decod_3513_.pdf

fstcompose test_3513_XX_.fst tranducer_decod.fst | fstrmepsilon > result_decod_3513_XX_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_decod_3513_XX_.fst | dot -Tpdf  > result_decod_3513_XX_.pdf

fstcompose test_bXtXtX_332111_.fst tranducer_decod.fst | fstrmepsilon > result_decod_batata_28_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_decod_batata_28_.fst | dot -Tpdf  > result_decod_batata_28_.pdf

fstcompose test_Vr_tX79m_.fst tranducer_decod.fst | fstrmepsilon > result_decod_ir_tambem.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_decod_ir_tambem.fst | dot -Tpdf  > result_decod_ir_tambem.pdf


#################
