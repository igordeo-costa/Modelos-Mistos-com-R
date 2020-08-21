# Aula 0 - Parte 1: Uma introdução básica ao R

# (1) Usando o R como uma calculadora:

1+3 # soma
 
5-2 # subtração

16/2 # divisão

3*5 # multiplicação

9^2 # potenciação

# etc. etc. etc.

# (2) Criando um "objeto" do R
# O ideal no R é criar objetos e atribuir a eles certas propriedades:

a=5+7+9+15+397 # O objeto "a" recebe a soma depois do sinal de "=";
b=6-9+13+25 # O objeto "b" recebe a operação depois do sinal de "=".

# Observe que, ao "rodar" os objetos "a" e "b", nada parece acontecer.
# Na verdade, o R já fez a conta "encobertamente", apenas não a mostrou para você.
# Se você quiser vê-la, basta "imprimir" o objeto na tela, digitando o nome dele:

a # imprime na tela o objeto "a"
b # imprime na tela o objeto "b"
  
# Com isso, agora você pode manipular os objetos "a" e "b", realizando operações entre eles:

a+b
a/b
a^b # "a" elevado a "b"
log(a^b) #logaritmo natural de "a" elevado a "b"
sqrt(a+b*(b+a)) # raiz quadrada de a+b*(b+a)

# Lembre-se de que as regras para as operações matemáticas continuam valendo, como a colocação de parênteses:
# Observe a diferença entre os objetos "x" e "y":

x=(a+b)*(b+a)
y= (a+b)*b+a

# OBS: objetos podem ser criados com o operador "=" ou com o operador "<-".

z=500/2 # É lido como: o objeto "z" recebe o resultado da operação 500 divido por 2.

# é a mesma coisa que:

z<-500/2 

#---------
# Comentário importante: o sinal de "=" no R é um comando executável, um operador para criar objetos;
# O sinal matemático de igualdade no R é "==" (dois sinais de igual seguidos).
#---------

# Crianco objetos com a função "concatenar":
# c()

z=c(1,2,3,4,5) # Cria o objeto z que recebe os números de 1 a 5.
w=c("a", "b", "c", "d", "e") # Cria o objeto w que contém as letras de "a" a "e".
k=c(569.2, 326.5, 297.47, 624.1, 358.4)

# Os objetos formados pela função c() são chamados de "vetores" e permitem manipulações
# como os objetos mais básicos:

z*k # Multiplicar z por k. Fique atento aos resultados!!!

# Agora tente fazer o mesmo com z e w:

z*w

# Você provavelmente obteve a resposta abaixo:

#--------------------------------------------------------------
# Error in z * w : non-numeric argument to binary operator
#--------------------------------------------------------------

# Isso ocorre porque o R não consegue multiplicar um número (elementos de z) por uma
# letra (elementos de w).
# Isso ocorre porque o R reconhece diferentes tipos de objetos. Vamos ver alguns deles:

# integer: número inteiro (1, 2, 458, 7895, etc.)

# numeric: número inteiro e fracionário (236.5, 15.2, 794.654798123, etc.)

# character: letra ou palavra ("a", "A irmã do João", "2+321", etc.)
# Repare que objetos do tipo character são criados colocados aspas duplas antes e depois do elemento
# que se quer definir como um character. Assim:

num=2+321 # cria um objeto numérico
str="2+321" # cria um objeto do tipo character

# logical: um valor lógico binário (TRUE ou FALSE).

# Para saber se um objeto é de um desses tipos, basta usar uma das funções abaixo: 

#--------------
# is.integer()
# is.numeric()
# is.character()
# is.logical()
#--------------

# Agora podemos entender por que o R não fez a multiplicação z*W:

is.numeric(z)
is.numeric(w)

is.character(z)
is.character(w)

# z é um objeto numérico, mas w é um objeto do tipo character. Daí a resposta de erro do R:

#---------------------------------------------------------
# Error in z * w : non-numeric argument to binary operator
#---------------------------------------------------------

# Para finalizar, vamos falar de um outro tipo de objeto, os data frames:

#---------------
# data.frame()
#---------------

# Vamos passar os vetores z, w e k como argumentos da função data.frame:
# Vamos dar o nome de "dados" a esse data frame:

dados=data.frame(z, w, k) # o objeto "dados" recebe o data frame criado com os objetos z, w e k.

# Agora imprima na tela o objeto "dados":

dados

# Um data.frame nada mais é do que uma tabela. Ele tem inúmeras propriedades e é diferente
# de outros tipos de "tabelas" do R, como os objetos do tipo "matrix".
# Mas isso não é importante agora.

# Vamos a uma última manipulação:

# Crie o objeto f como abaixo:

f=c("A1","A2","A3","A4")

# Agora vamos fazer um data frame com z, w, k e f:
  
dados2=data.frame(z, w, k, f)

# Você deve ter obtido o seguinte erro:

#----------------------------------------------------
# Error in data.frame(z, w, k, f) : 
#   arguments imply differing number of rows: 5, 4
#----------------------------------------------------

# Entendeu por quê?
# Todas as colunas de um data frame têm de ter o mesmo número de linhas!!!

# Vamos recriar o vetor f então, incluindo, no final, o elemento NA.

f=c("A1","A2","A3","A4", NA)

# Agora refaça o data frame "dados2"

dados2=data.frame(z, w, k, f)

# E imprima-o na tela:

dados2

# Mas o que é o NA? Vamos perguntar para o R:

?NA

# Sempre que houver alguma dúvida sobre uma função do R, você pode usar o ponto de interrogação
# seguido da função para obter ajuda.

# NA ("Not Available/Missing Values") é o valor que usamos quando queremos deixar um "lugar vazio".

# Por enquanto é só!
# Vamos para a parte 2, em que aprenderemos como importar dados para o R.
