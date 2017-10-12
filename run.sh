#!/bin/bash


################# Decimals2Romans Transducer ################
###### Uni
fstcompile --isymbols=syms.sym --osymbols=syms.sym r2d_uni.txt | fstarcsort > r2d_uni.fst
#fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait r2d_uni.fst | dot -Tpdf  > r2d_uni.pdf

###### Dec
fstcompile --isymbols=syms.sym --osymbols=syms.sym r2d_dec.txt | fstarcsort > r2d_dec.fst
#fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait r2d_dec.fst | dot -Tpdf  > r2d_dec.pdf

###### Cent
fstcompile --isymbols=syms.sym --osymbols=syms.sym r2d_cen.txt | fstarcsort > r2d_cen.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait r2d_cen.fst | dot -Tpdf  > r2d_cen.pdf

###### Zero
fstcompile --isymbols=syms.sym --osymbols=syms.sym r2d_zero.txt | fstarcsort > r2d_zero.fst
#fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait r2d_zero.fst | dot -Tpdf  > r2d_zero.pdf

### Concatenation e Union operation for final transducer generation
fstunion r2d_uni.fst r2d_zero.fst > uni_zero.fst
fstconcat r2d_dec.fst uni_zero.fst > dec_zero_uni.fst

fstconcat r2d_cen.fst r2d_zero.fst > cen_zero.fst
fstconcat cen_zero.fst r2d_zero.fst  > cen_zero_zero.fst

fstunion cen_zero_zero.fst dec_zero_uni.fst > almost_final.fst
fstunion almost_final.fst r2d_uni.fst > final.fst
#fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait final.fst | dot -Tpdf  > final.pdf

### Inverting Romans2Decimals --> Decimals2Romans
fstinvert final.fst > invert_final.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait invert_final.fst | dot -Tpdf  > invert_final.pdf

#############################################################

######################### Transducer 1 ######################
python compact2fst.py letters.txt > letters_transducer.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym letters_transducer.txt | fstarcsort > letters_transducer.fst
fstcompile --isymbols=syms.sym --osymbols=syms.sym underline.txt | fstarcsort > underline.fst

###Transducers operations
fstconcat letters_transducer.fst underline.fst > letters_transducer1.fst
fstconcat invert_final.fst underline.fst > invert_final_space.fst
fstunion invert_final_space.fst letters_transducer1.fst > transducer1_union.fst
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
fstarcsort --sort_type=ilabel transducer1.fst > transducer1sort.fst
fstcompose transducer1sort.fst transducer2_final.fst > transducer1_2.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transducer1_2.fst | dot -Tpdf  > transducer1_2.pdf

fstcompose transducer1_2.fst transducer3_final.fst | fstarcsort > tranducer_cod.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait tranducer_cod.fst | dot -Tpdf  > tranducer_cod.pdf

################### Decodifier Transducer ####################
fstinvert transducer1sort.fst > transducer1_invert.fst
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

####################### Tests Generation #####################
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


#################### Testing Transducer 1 ####################
fstcompose test_99_.fst transducer1.fst | fstrmepsilon > result_XCIX_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_XCIX_.fst | dot -Tpdf  > result_XCIX_.pdf

fstcompose test_99_aa_.fst transducer1.fst | fstrmepsilon > result_XCIX_aa_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_XCIX_aa_.fst | dot -Tpdf  > result_XCIX_aa_.pdf

fstcompose test_batata_28_.fst transducer1.fst | fstrmepsilon > result_batata_XXVIII_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_batata_XXVIII_.fst | dot -Tpdf  > result_batata_XXVIII_.pdf

fstcompose test_ir_tambem_.fst transducer1.fst | fstrmepsilon > result_ir_tambem_trans1.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_ir_tambem_trans1.fst | dot -Tpdf  > result_ir_tambem_trans1.pdf


#################### Testing Transducer 2 ####################
fstcompose result_XCIX_aa_.fst transducer2_final.fst | fstrmepsilon > result_3513_aa_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_3513_aa_.fst | dot -Tpdf  > result_3513_aa_.pdf

fstcompose result_XCIX_.fst transducer2_final.fst | fstrmepsilon > result_3513_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_3513_.fst | dot -Tpdf  > result_3513_.pdf

fstcompose result_batata_XXVIII_.fst transducer2_final.fst | fstrmepsilon > result_batata_332111_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_batata_332111_.fst | dot -Tpdf  > result_batata_332111_.pdf

fstcompose result_ir_tambem_trans1.fst transducer2_final.fst | fstrmepsilon > result_ir_tambem_trans2.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_ir_tambem_trans1.fst | dot -Tpdf  > result_ir_tambem_trans1.pdf


#################### Testing Transducer 3 ####################
fstcompose result_3513_aa_.fst transducer3_final.fst | fstrmepsilon > result_3513_XX_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_3513_XX_.fst | dot -Tpdf  > result_3513_XX_.pdf

fstcompose result_3513_.fst transducer3_final.fst | fstrmepsilon > result_3513_1.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_3513_1.fst | dot -Tpdf  > result_3513_1.pdf

fstcompose result_batata_332111_.fst transducer3_final.fst | fstrmepsilon > result_bXtXtX_332111_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_bXtXtX_332111_.fst | dot -Tpdf  > result_bXtXtX_332111_.pdf

fstcompose result_ir_tambem_trans2.fst transducer3_final.fst | fstrmepsilon > result_Vr_tX79m_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_Vr_tX79m_.fst | dot -Tpdf  > result_Vr_tX79m_.pdf


################# Testing Codifier Transducer ################
fstcompose test_99_aa_.fst tranducer_cod.fst | fstrmepsilon > result_cod_3513_XX_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_cod_3513_XX_.fst | dot -Tpdf  > result_cod_3513_XX_.pdf

fstcompose test_99_.fst tranducer_cod.fst | fstrmepsilon > result_cod_3513_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_cod_3513_.fst | dot -Tpdf  > result_cod_3513_.pdf

fstcompose test_batata_28_.fst tranducer_cod.fst | fstrmepsilon > result_cod_bXtXtX_332111_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_cod_bXtXtX_332111_.fst | dot -Tpdf  > result_cod_bXtXtX_332111_.pdf

fstcompose test_ir_tambem_.fst tranducer_cod.fst | fstrmepsilon > result_cod_Vr_tX79m_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_cod_Vr_tX79m_.fst | dot -Tpdf  > result_cod_Vr_tX79m_.pdf

################ Testing Decodifier Transducer ###############
fstcompose test_3513_.fst tranducer_decod.fst | fstrmepsilon > result_decod_3513_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_decod_3513_.fst | dot -Tpdf  > result_decod_3513_.pdf

fstcompose test_3513_XX_.fst tranducer_decod.fst | fstrmepsilon > result_decod_3513_XX_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_decod_3513_XX_.fst | dot -Tpdf  > result_decod_3513_XX_.pdf

fstcompose test_bXtXtX_332111_.fst tranducer_decod.fst | fstrmepsilon > result_decod_batata_28_.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_decod_batata_28_.fst | dot -Tpdf  > result_decod_batata_28_.pdf

fstcompose test_Vr_tX79m_.fst tranducer_decod.fst | fstrmepsilon > result_decod_ir_tambem.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait result_decod_ir_tambem.fst | dot -Tpdf  > result_decod_ir_tambem.pdf


##############################################################
