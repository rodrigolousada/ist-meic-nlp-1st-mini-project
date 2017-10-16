#!/bin/bash

mkdir transducers

################# Arabics2Romans Transducer ################
###### Uni
fstcompile --isymbols=syms.sym --osymbols=syms.sym r2a_uni.txt | fstarcsort > transducers/r2a_uni.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transducers/r2a_uni.fst | dot -Tpdf  > transducers/r2a_uni.pdf

###### Dec
fstcompile --isymbols=syms.sym --osymbols=syms.sym r2a_dec.txt | fstarcsort > transducers/r2a_dec.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transducers/r2a_dec.fst | dot -Tpdf  > transducers/r2a_dec.pdf

###### Cent
fstcompile --isymbols=syms.sym --osymbols=syms.sym r2a_cen.txt | fstarcsort > transducers/r2a_cen.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transducers/r2a_cen.fst | dot -Tpdf  > transducers/r2a_cen.pdf

###### Zero
fstcompile --isymbols=syms.sym --osymbols=syms.sym r2a_zero.txt | fstarcsort > transducers/r2a_zero.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transducers/r2a_zero.fst | dot -Tpdf  > transducers/r2a_zero.pdf

### Concatenation e Union operation for final transducer generation
fstunion transducers/r2a_uni.fst transducers/r2a_zero.fst > transducers/r2a_uni_zero.fst
fstconcat transducers/r2a_dec.fst transducers/r2a_uni_zero.fst > transducers/r2a_dec_zero_uni.fst

fstconcat transducers/r2a_cen.fst transducers/r2a_zero.fst > transducers/r2a_cen_zero.fst
fstconcat transducers/r2a_cen_zero.fst transducers/r2a_zero.fst  > transducers/r2a_hundred.fst

fstunion transducers/r2a_hundred.fst transducers/r2a_dec_zero_uni.fst > transducers/r2a_almost_final.fst
fstunion transducers/r2a_almost_final.fst transducers/r2a_uni.fst > transducers/r2a.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transducers/r2a.fst | dot -Tpdf  > transducers/r2a.pdf

### Inverting Romans2Arabics --> Arabics2Romans
fstinvert transducers/r2a.fst > transducers/a2r.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transducers/a2r.fst | dot -Tpdf  > transducers/a2r.pdf

#############################################################

######################### Transducer 1 ######################
python compact2fst.py letters.txt > transducers/letters_transducer.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym transducers/letters_transducer.txt | fstarcsort > transducers/letters_transducer.fst
fstcompile --isymbols=syms.sym --osymbols=syms.sym underline.txt | fstarcsort > transducers/underline.fst

###Constructing Transducer 1
fstunion transducers/a2r.fst transducers/letters_transducer.fst > transducers/transducer1_union.fst
fstconcat transducers/transducer1_union.fst transducers/underline.fst > transducers/transducer1_almost_final.fst
fstclosure transducers/transducer1_almost_final.fst > transducers/transducer1.fst

###Printing Transducer 1
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transducers/transducer1.fst | dot -Tpdf  > transducers/transducer1.pdf

######################### Transducer 2 ######################
python compact2fst.py transducer2.txt > transducers/transducer2_final.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym transducers/transducer2_final.txt | fstarcsort > transducers/transducer2.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transducers/transducer2.fst | dot -Tpdf  > transducers/transducer2.pdf

######################### Transducer 3 #######################
python compact2fst.py transducer3.txt > transducers/transducer3_final.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym transducers/transducer3_final.txt | fstarcsort > transducers/transducer3.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transducers/transducer3.fst | dot -Tpdf  > transducers/transducer3.pdf

##################### Codifier Transducer ####################
fstarcsort --sort_type=ilabel transducers/transducer1.fst > transducers/transducer1_sort.fst
fstcompose transducers/transducer1_sort.fst transducers/transducer2.fst > transducers/transducer1_2.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transducers/transducer1_2.fst | dot -Tpdf  > transducers/transducer1_2.pdf

fstcompose transducers/transducer1_2.fst transducers/transducer3.fst | fstarcsort > transducers/codifier.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transducers/codifier.fst | dot -Tpdf  > transducers/codifier.pdf

################### Decodifier Transducer ####################
fstinvert transducers/transducer1_sort.fst > transducers/transducer1_invert.fst
fstinvert transducers/transducer2.fst > transducers/transducer2_invert.fst
fstinvert transducers/transducer3.fst > transducers/transducer3_invert.fst

fstcompose transducers/transducer3_invert.fst transducers/transducer2_invert.fst > transducers/transducer3_2_invert.fst
fstcompose transducers/transducer3_2_invert.fst transducers/transducer1_invert.fst | fstarcsort > transducers/decodifier.fst

fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait transducers/decodifier.fst | dot -Tpdf  > transducers/decodifier.pdf

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
python word2fst.py biblioteca_do_palacio_de_monserrate_na_estante_a_esquerda_no_dia_14_de_novembro_pelas_10_23_de_maio_ > tests/test_cod_email.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  tests/test_cod_email.txt | fstarcsort > tests/test_cod_email.fst

python word2fst.py Xs_21_pm_32111_d9_d9z97r0_3332111_3412_312_n_13_32111_31_0_ > tests/test_decod1_email.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  tests/test_decod1_email.txt | fstarcsort > tests/test_decod1_email.fst

python word2fst.py 3332111_3412_321_n_13_2111_321_0_3311_d9_jXn9Vr0_p9lXs_312_h_ > tests/test_decod2_email.txt
fstcompile --isymbols=syms.sym --osymbols=syms.sym  tests/test_decod2_email.txt | fstarcsort > tests/test_decod2_email.fst

################# Testing Codifier Transducer ################
fstcompose tests/test_cod_email.fst transducers/codifier.fst | fstproject --project_output | fstrmepsilon > results/result_cod_email.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_cod_email.fst | dot -Tpdf  > results/result_cod_email.pdf

################ Testing Decodifier Transducer ###############
fstcompose tests/test_decod1_email.fst transducers/decodifier.fst | fstproject --project_output | fstrmepsilon > results/result_decod1_email.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_decod1_email.fst | dot -Tpdf  > results/result_decod1_email.pdf

fstcompose tests/test_decod2_email.fst transducers/decodifier.fst | fstproject --project_output | fstrmepsilon > results/result_decod2_email.fst
fstdraw    --isymbols=syms.sym --osymbols=syms.sym --portrait results/result_decod2_email.fst | dot -Tpdf  > results/result_decod2_email.pdf

##############################################################

######### Copying important files to root directory ##########
cp transducers/a2r.fst            transdutorRomanos.fst
cp transducers/a2r.pdf            transdutorRomanos.pdf
cp transducers/transducer1.fst    transdutor1.fst
cp transducers/transducer1.pdf    transdutor1.pdf
cp transducers/transducer2.fst    transdutor2.fst
cp transducers/transducer2.pdf    transdutor2.pdf
cp transducers/transducer3.fst    transdutor3.fst
cp transducers/transducer3.pdf    transdutor3.pdf
cp transducers/codifier.fst       codificador.fst
cp transducers/codifier.pdf       codificador.pdf
cp transducers/decodifier.fst     descodificador.fst
cp transducers/decodifier.pdf     descodificador.pdf
##############################################################
