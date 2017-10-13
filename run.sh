#!/bin/bash


################# Arabics2Romans Transducer ################
###### Uni
fstcompile --isymbols=syms.sym --osymbols=syms.sym r2a_uni.txt | fstarcsort > r2a_uni.fst
#fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait r2a_uni.fst | dot -Tpdf  > r2a_uni.pdf

###### Dec
fstcompile --isymbols=syms.sym --osymbols=syms.sym r2a_dec.txt | fstarcsort > r2a_dec.fst
#fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait r2a_dec.fst | dot -Tpdf  > r2a_dec.pdf

###### Cent
fstcompile --isymbols=syms.sym --osymbols=syms.sym r2a_cen.txt | fstarcsort > r2a_cen.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait r2a_cen.fst | dot -Tpdf  > r2a_cen.pdf

###### Zero
fstcompile --isymbols=syms.sym --osymbols=syms.sym r2a_zero.txt | fstarcsort > r2a_zero.fst
#fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait r2a_zero.fst | dot -Tpdf  > r2a_zero.pdf

### Concatenation e Union operation for final transducer generation
fstunion r2a_uni.fst r2a_zero.fst > r2a_uni_zero.fst
fstconcat r2a_dec.fst r2a_uni_zero.fst > r2a_dec_zero_uni.fst

fstconcat r2a_cen.fst r2a_zero.fst > r2a_cen_zero.fst
fstconcat r2a_cen_zero.fst r2a_zero.fst  > r2a_hundred.fst

fstunion r2a_hundred.fst r2a_dec_zero_uni.fst > r2a_almost_final.fst
fstunion r2a_almost_final.fst r2a_uni.fst > r2a.fst
#fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait r2a.fst | dot -Tpdf  > r2a.pdf

### Inverting Romans2Arabics --> Arabics2Romans
fstinvert r2a.fst > a2r.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait a2r.fst | dot -Tpdf  > a2r.pdf

#############################################################

######################### Transducer 1 ######################
python compact2fst.py letters.txt > letters_transducer.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym letters_transducer.txt | fstarcsort > letters_transducer.fst
fstcompile --isymbols=syms.sym --osymbols=syms.sym underline.txt | fstarcsort > underline.fst

###Transducers operations
fstconcat letters_transducer.fst underline.fst > letters_transducer1.fst
fstconcat a2r.fst underline.fst > a2r_underline.fst
fstunion a2r_underline.fst letters_transducer1.fst > transducer1_union.fst
fstclosure transducer1_union.fst > transducer1.fst

###Printing Transducer 1
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transducer1.fst | dot -Tpdf  > transducer1.pdf

######################### Transducer 2 ######################
python compact2fst.py transducer2.txt > transducer2_final.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym transducer2_final.txt | fstarcsort > transducer2_final.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transducer2_final.fst | dot -Tpdf  > transducer2_final.pdf

######################### Transducer 3 #######################
python compact2fst.py transducer3.txt > transducer3_final.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym transducer3_final.txt | fstarcsort > transducer3_final.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transducer3_final.fst | dot -Tpdf  > transducer3_final.pdf

##################### Codifier Transducer ####################
fstarcsort --sort_type=ilabel transducer1.fst > transducer1_sort.fst
fstcompose transducer1_sort.fst transducer2_final.fst > transducer1_2.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transducer1_2.fst | dot -Tpdf  > transducer1_2.pdf

fstcompose transducer1_2.fst transducer3_final.fst | fstarcsort > tranducer_cod.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait tranducer_cod.fst | dot -Tpdf  > tranducer_cod.pdf

################### Decodifier Transducer ####################
fstinvert transducer1_sort.fst > transducer1_invert.fst
fstinvert transducer2_final.fst > transducer2_invert.fst
fstinvert transducer3_final.fst > transducer3_invert.fst

fstcompose transducer3_invert.fst transducer2_invert.fst > transducer3_2.fst
fstcompose transducer3_2.fst transducer1_invert.fst | fstarcsort > tranducer_decod.fst

fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait tranducer_decod.fst | dot -Tpdf  > tranducer_decod.pdf

##############################################################
##############################################################
#                ___________              __                 #
#                \__    ___/___   _______/  |_               #
#                  |    |_/ __ \ /  ___/\   __\              #
#                  |    |\  ___/ \___ \  |  |                #
#                  |____| \___  >____  > |__|                #
##############################################################
##############################################################

mkdir tests
mkdir results

####################### Tests Generation #####################
python word2fst.py 99_ > tests/test_99_.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  tests/test_99_.txt | fstarcsort > tests/test_99_.fst

python word2fst.py 99_aa_ > tests/test_99_aa_.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  tests/test_99_aa_.txt | fstarcsort > tests/test_99_aa_.fst

python word2fst.py batata_28_ > tests/test_batata_28_.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  tests/test_batata_28_.txt | fstarcsort > tests/test_batata_28_.fst

python word2fst.py ir_tambem_ > tests/test_ir_tambem_.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  tests/test_ir_tambem_.txt | fstarcsort > tests/test_ir_tambem_.fst

python word2fst.py 3513_ > tests/test_3513_.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  tests/test_3513_.txt | fstarcsort > tests/test_3513_.fst

python word2fst.py 3513_XX_ > tests/test_3513_XX_.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  tests/test_3513_XX_.txt | fstarcsort > tests/test_3513_XX_.fst

python word2fst.py bXtXtX_332111_ > tests/test_bXtXtX_332111_.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  tests/test_bXtXtX_332111_.txt | fstarcsort > tests/test_bXtXtX_332111_.fst

python word2fst.py Vr_tX79m_ > tests/test_Vr_tX79m_.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  tests/test_Vr_tX79m_.txt | fstarcsort > tests/test_Vr_tX79m_.fst


#################### Testing Transducer 1 ####################
fstcompose tests/test_99_.fst transducer1.fst | fstrmepsilon > results/result_XCIX_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_XCIX_.fst | dot -Tpdf  > results/result_XCIX_.pdf

fstcompose tests/test_99_aa_.fst transducer1.fst | fstrmepsilon > results/result_XCIX_aa_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_XCIX_aa_.fst | dot -Tpdf  > results/result_XCIX_aa_.pdf

fstcompose tests/test_batata_28_.fst transducer1.fst | fstrmepsilon > results/result_batata_XXVIII_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_batata_XXVIII_.fst | dot -Tpdf  > results/result_batata_XXVIII_.pdf

fstcompose tests/test_ir_tambem_.fst transducer1.fst | fstrmepsilon > results/result_ir_tambem_trans1.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_ir_tambem_trans1.fst | dot -Tpdf  > results/result_ir_tambem_trans1.pdf


#################### Testing Transducer 2 ####################
fstcompose results/result_XCIX_aa_.fst transducer2_final.fst | fstrmepsilon > results/result_3513_aa_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_3513_aa_.fst | dot -Tpdf  > results/result_3513_aa_.pdf

fstcompose results/result_XCIX_.fst transducer2_final.fst | fstrmepsilon > results/result_3513_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_3513_.fst | dot -Tpdf  > results/result_3513_.pdf

fstcompose results/result_batata_XXVIII_.fst transducer2_final.fst | fstrmepsilon > results/result_batata_332111_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_batata_332111_.fst | dot -Tpdf  > results/result_batata_332111_.pdf

fstcompose results/result_ir_tambem_trans1.fst transducer2_final.fst | fstrmepsilon > results/result_ir_tambem_trans2.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_ir_tambem_trans1.fst | dot -Tpdf  > results/result_ir_tambem_trans1.pdf


#################### Testing Transducer 3 ####################
fstcompose results/result_3513_aa_.fst transducer3_final.fst | fstrmepsilon > results/result_3513_XX_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_3513_XX_.fst | dot -Tpdf  > results/result_3513_XX_.pdf

fstcompose results/result_3513_.fst transducer3_final.fst | fstrmepsilon > results/result_3513_1.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_3513_1.fst | dot -Tpdf  > results/result_3513_1.pdf

fstcompose results/result_batata_332111_.fst transducer3_final.fst | fstrmepsilon > results/result_bXtXtX_332111_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_bXtXtX_332111_.fst | dot -Tpdf  > results/result_bXtXtX_332111_.pdf

fstcompose results/result_ir_tambem_trans2.fst transducer3_final.fst | fstrmepsilon > results/result_Vr_tX79m_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_Vr_tX79m_.fst | dot -Tpdf  > results/result_Vr_tX79m_.pdf


################# Testing Codifier Transducer ################
fstcompose tests/test_99_aa_.fst tranducer_cod.fst | fstrmepsilon > results/result_cod_3513_XX_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_cod_3513_XX_.fst | dot -Tpdf  > results/result_cod_3513_XX_.pdf

fstcompose tests/test_99_.fst tranducer_cod.fst | fstrmepsilon > results/result_cod_3513_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_cod_3513_.fst | dot -Tpdf  > results/result_cod_3513_.pdf

fstcompose tests/test_batata_28_.fst tranducer_cod.fst | fstrmepsilon > results/result_cod_bXtXtX_332111_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_cod_bXtXtX_332111_.fst | dot -Tpdf  > results/result_cod_bXtXtX_332111_.pdf

fstcompose tests/test_ir_tambem_.fst tranducer_cod.fst | fstrmepsilon > results/result_cod_Vr_tX79m_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_cod_Vr_tX79m_.fst | dot -Tpdf  > results/result_cod_Vr_tX79m_.pdf

################ Testing Decodifier Transducer ###############
fstcompose tests/test_3513_.fst tranducer_decod.fst | fstrmepsilon > results/result_decod_3513_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_decod_3513_.fst | dot -Tpdf  > results/result_decod_3513_.pdf

fstcompose tests/test_3513_XX_.fst tranducer_decod.fst | fstrmepsilon > results/result_decod_3513_XX_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_decod_3513_XX_.fst | dot -Tpdf  > results/result_decod_3513_XX_.pdf

fstcompose tests/test_bXtXtX_332111_.fst tranducer_decod.fst | fstrmepsilon > results/result_decod_batata_28_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_decod_batata_28_.fst | dot -Tpdf  > results/result_decod_batata_28_.pdf

fstcompose tests/test_Vr_tX79m_.fst tranducer_decod.fst | fstrmepsilon > results/result_decod_ir_tambem.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_decod_ir_tambem.fst | dot -Tpdf  > results/result_decod_ir_tambem.pdf


##############################################################
