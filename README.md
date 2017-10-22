# NLP-1st-Mini-Project
Natural Language Processing 1st Mini Project

**Work with:**
 - [Graphviz](http://www.graphviz.org/)
 - [OpenFST](http://www.openfst.org/twiki/bin/view/FST/FstDownload)

**Grupo 40:** 
 - Sofia Aparício 81105
 - Rodrigo Lousada 81115

**Grade:** 4/4

**What is it?**  
In this project we created 5 transducers:
 - Reads a sentences with underlines separating diferent words and translates Algebric Numbers from 1 to 100 into Roman Numbers;
 - Reads the output of the 1st transducer and codifies the Roman Numbers;
 - Reads the output of the 2nd transducer and codifies some letters;
 - Uses the 1, 2, 3 transducers to codifie a sentence;
 - Decodifies the sentence codifies by the previous codifier.

**How you run it?**  
There are 3 main files you can run using the **sh** command:
 - **run.sh** - Creates the transducers, tests and results folders where it will put all the generated files. At the end it will copy specific fiels with the requested names for the root folder so it could be used by the professor when evaluating;
 - **tests.sh** - Generates more tests. The tests and results generated will be on the specific folders;
 - **clean.sh** - CLeans all the generated files and folders.

