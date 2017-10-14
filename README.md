# NLP-1st-Mini-Project
Natural Language Processing 1st Mini Project

**Grupo 40:**
- Sofia Aparício 81105
- Rodrigo LOusada 81115

**Explicação do funcionamento:**
O script run.sh cria 3 pastas:
Sendo enviado todos os testes para a pasta **tests**, todos os resultados para a pasta **results** e todos os transdutores para a pasta **transducer**. Por uma questão de cumprimento do enunciado são gerados os ficheiros pedidos com os nomes respectivos na directoria raiz.

**Descrição da Solução:**
O grupo optou por começar a fazer o transdutor de Romanos para Decimais, sendo mais simples a implementação deste que depois seria invertido para obter o Transdutor Romanos. Simplificando mais ainda, começamos por desenvolver 4 transdutores, Referente ao zero, às unidades, às dezenas e ao numero 100. Estes quatro foram então concatenados e unidos de forma a obter um transdutor que contemplasse todos e somente os números de 1 a 100. 

(Colocar imagem?)

A necessidade de ter um transdutor apenas para o zero, deve-se ao facto do trandutor das unidades apenas poder contemplar o 0 caso já tenha sido lida uma dezena. Esta solução facilitaria-nos escalar assim a solução para o caso de aceitarmos numero de 0 a 999, evitar outputs como 00.

Para obter o trandutor 1 acabamos por criar mais dois transdutores:
 -um trandutor que aceita todas as letras de a-z
 -um transdutor que aceita após receber o caracter _(underline)
É obtido assim o transdutor 1 com a união entre o Transdutor Romanos, e o transdutor das letras com a posterior concatenação com o underline, e closure.

O transdutor 2 é um simples transdutor que apenas vai para o estado final caso receba um underline, e que ao receber qualquer numero Romano o codifica.

O transdutor 3 revela-se o mais dificil aplicando uma solução não determinista para os casos de receber um m ou um i, Segundo o seguinte esboço:

(Colocar imagem)

O transdutor codificador é um simples compose entre os transdutor 1, 2 e 3 respectivamente, enquanto o transdutor descodificador resulta da inversão dos transdutores e respectivo compose pela ordem 3, 2 e 1.
