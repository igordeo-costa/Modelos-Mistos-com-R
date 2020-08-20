# Parte 3: Compreendendo os dados do seu data frame ANTES de aplicar qualquer modelo

# Vamos continuar trabalhando com o objeto "x", ou seja, com a tabela "Populações Fictícias.csv"
# Se não estiver carregada, carregue-a!

# Agora vamos investigar esses dados com a função summary()

# Vamos começar investigando a popA:

summary(x$popA) # lembre-se: data frame "x", coluna "popA" (x$popA)

# Que informações são essas?
# Se olharmos com calma, elas são (quase) auto-explicativas:

# Min. e Max. são o menor e o maior valor da popA
# Mean é a média aritmética da popA, ou seja, todos os valores de popA somados e divididos
# pelo número total de obervações (no caso, 10 mil).

# Podemos conferir isso usando as funções:

min(x$popA)

max(x$popA)

mean(x$popA)

# ESSA PARTE É UMA COMPLEMENTAÇÃO AO TEXTO: "Apostila.docx", disponível na pasta do curso.

# (A) MEDIDAS DA TENDÊNCIA CENTRAL: média (mean) e mediana (median)

# (B) QUANTIS E QUARTIS

# (C) MEDIDAS DE DISPERSÃO: Desvios, desvio médio, variância, desvio padrão

# Agora que você já entendeu tudo isso, você pode começar a valorizar mais a função summary().
# Ela te dá os mais relevantes desses resultados de uma vez só e de modo muito rápido.

# Mas só fizemos summary() para a popA. Façamos também para popB:

summary(x$popB)

# Ou você pode aplicar a função summary() a todo o data frame:

summary(x)

# Agora compare as populações A e B:
# Vamos supor que os dados sejam de Tempos de Reação à leitura de certas palavras.
# Qual delas lê mais rápido? Por quê?
# Qual delas tem tempos de leitura mais consistentes? Por quê?

# Você também pode visualizar os dados dos quartis e quantis com um boxplot (gráfico de caixas):

boxplot(x$popA, x$popB)

# Perceba como esse tipo de gráfico faz um resumo muito conciso e de apreensão imediata dos dados.

# Perceba que a função boxplot() pode ser aplicada, ainda, de outro modo. Vamos ver esse modo:

# Vamos usar a função sample() para fazer duas amostras aleatórias:

amostra.popA=sample(x$popA, 15) # amostrar aleatoriamente 15 indivíduos de popA
amostra.popB=sample(x$popB, 15) # o mesmo para popB.

# Agora vamos juntar em um único vetor amostra.popA e amostra.popB usando c() --> concatenar

Amostras=c(amostra.popA, amostra.popB)

# Agora vamos criar um vetor (função concatenar) que contenha a letra "A" repetida 15 vezes e a letra "B" repetida 15 vezes.
# Vamos usar a função rep()

População=c(rep("A", 15), rep("B", 15))

# Agora vamos juntar em um data frame o vetor População e o vetor Amostras:

Amostragem=data.frame(População, Amostras)

# Agora vamos ver o que o R fez:

Amostragem

# No data frame original (x), população A e B estavam em colunas diferentes, daí fizemos o boxplot assim:

boxplot(x$popA, x$popB)

# Agora as populações A e B estão na mesma coluna e as medidas em outra coluna.

#-----------------------------------------------------------------------------------------
# Daqui a pouco vamos ver um jeito muito mais fácil de fazer isso, usando o pacote "tidyr"
#-----------------------------------------------------------------------------------------

# Tente plotar um boxplot desse modo e veja o que ocorre:

boxplot(Amostragem$População, Amostragem$Amostras)

# Ele plotou 2 boxplots, mas um está "zerado".
# O jeito correto de plotar o boxplot para esse data frame seria: 

boxplot(Amostragem$Amostras~Amostragem$População)

# Avisar à função boxplot que você deseja plotar a coluna Amostras ($Amostras)
# em função de (~) coluna População ($População).

# Ou, se você não gosta do símbolo $, assim:

boxplot(Amostras~População, data=Amostragem)
