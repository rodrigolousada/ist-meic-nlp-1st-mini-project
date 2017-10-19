# NLP-1st-Mini-Project
Natural Language Processing 1st Mini Project

**Work with: **
 - Graphviz
 - FSTOpen

**Grupo 40:**
- Sofia Aparício 81105
- Rodrigo Lousada 81115

**Grade:** 4/4

**Explicação do funcionamento:**
Existem 3 ficheiros que pode correr com o comando **sh**:
 - **run.sh** - Cria as pastas transducers, tests e transducers onde colocará todos os ficheiros gerados. No final copia os ficheiros referidos no enunciado para a pasta raiz com os nomes pedidos.
 - **tests.sh** - Gera mais testes que estarão na pasta tests com os respectivos resultados na pasta results
 - **clean.sh** - Limpa todos os ficheiros gerados

**Descrição das Opções Tomadas:**
O grupo optou por começar a fazer o transdutor de Romanos para Decimais, sendo mais simples a implementação deste que depois seria invertido para obter o Transdutor Romanos. Simplificando mais ainda, começamos por desenvolver 4 transdutores, Referente ao zero, às unidades, às dezenas e ao numero 100. Estes quatro foram então concatenados e unidos de forma a obter um transdutor que contemplasse todos e somente os números de 1 a 100. 

A necessidade de ter um transdutor apenas para o zero, deve-se ao facto do trandutor das unidades apenas poder contemplar o 0 caso já tenha sido lida uma dezena. Esta solução facilitaria-nos escalar assim a solução para o caso de aceitarmos numero de 0 a 999, evitar outputs como 00.

Para obter o trandutor 1 acabamos por criar mais dois transdutores:
 -um trandutor que aceita todas as letras de a-z
 -um transdutor que aceita após receber o caracter _(underline)
É obtido assim o transdutor 1 com a união entre o Transdutor Romanos, e o transdutor das letras com a posterior concatenação com o underline, e closure.

O transdutor 2 é um simples transdutor que apenas vai para o estado de aceitação caso receba um underline, e que ao receber qualquer numero Romano o codifica.

O transdutor 3 revela-se o mais desafiante, aplicando uma solução não determinista para os casos de receber um m ou um i, Segundo o seguinte esboço:

(Colocar imagem)

O transdutor codificador é um simples compose entre os transdutor 1, 2 e 3 respectivamente, enquanto o transdutor descodificador resulta da inversão dos transdutores e respectivo compose pela ordem 3, 2 e 1.

**Comentários à solução:**
O grupo optou, tal como aconselhado, a criar uma solução que parte de transdutores pequenos e simples para serem usados em transdutores mais complexos através da utilização das FSTools leccionadas.
O transdutor 3 acabou por ser o mais complexo a nivel de concepção "obrigando" a ser feito de uma vez para uma solução mais eficiente.

