# Aula 3: Os pressupostos dos modelos mistos
# Parte 3: Interpretando os coeficientes de uma interação

# Agora que vimos um modelo mistos bem simples, vamos ver um um pouco mais complexo:
# Vamos usar os dados de um experimento apresentado em Costa (2013: 65+);
# Era uma tarefa de leitura auto-monitorada e o tempo foi medido palavra por palavra.
# Os tempos para as duas posições finais da sentença estão na pasta como dois arquivos
# separados: "Relativas_p6.csv" (na pasta Exercícios) e "Relativas_p7.csv" (na pasta Aula 3).

# Vamos carregar aqui apenas os dados de p7.

p7=read.csv(file.choose())

# E investigar nossa tabela:

head(p7)

str(p7)

# Observe que temos 512 observações (linhas) e 6 colunas:
# Antes de tudo, vamos mudar os nomes das colunas para facilitar nossa vida, retirando
# aquelas letras maiúsculas do início:

colnames(p7)=c("suj", "itens", "ant", "verbo", "rt", "pos")

head(p7, 3)

# Repare também que suj é um vetor do tipo integer. Vamos mudá-lo para factor:

p7$suj=as.factor(p7$suj)

str(p7)

# Além disso, a coluna "pos" tem um só nível (p7), provavelmente porque essa tabela era parte
# de outra maior com as demais posições. Aqui ela se tornou inútil. Vamos excluí-la!

p7$pos=NULL

head(p7, 3)

# Agora sim! Com o terreno limpo, podemos analisar os dados!

#-----------------------------------------------------------------------------------
# O experimento:

# Nesse experimento, modelou-se o tempo de reação (rt) em função de dois fatores:
# (i) tipo de antecedente (ant): sintagma nominal (np) ou preposicionado (pp);
# (ii) número do verbo (verbo): singular (sg) ou plural (pl).
# Havia 16 itens experimentais e 32 sujeitos.
# Os itens eram mais ou menos assim:
# Letícia viu [as serras] (np) que [chove] (sg) muito
# Paulo correu [nas praias] (pp) que [chovem] (pl) muito.

# O objetivo era investigar se os tempos de reação poderiam ser descritos em função
# do tipo de antecedente e do número do verbo.
#-----------------------------------------------------------------------------------

# Vamos começar, então, com uma inspeção visual por meio de boxplots:

boxplot(rt~ant+verbo, data=p7)

# A condição pp.sg parece ser lida mais rapidamente do que as demais.
# Além disso, nossa distribuição parece ser bem assimétrica à direita, com alguns RTs bem acima
# da média.

# Vamos investigar esses pontos com um gráfico de pontos de Cleveland:

dotchart(p7$rt)

# De fato, parece haver uns 4 pontos (acima de 3000 ms que talvez influenciem no nosso modelo).
# Eles podem ser verdadeiros outliers (sujeitos cansados ou distraídos) ou fruto da natureza dos
# tempos de reação, bem assimétricos à direita.

# Vamos investigar essa distribuição com um histograma dos RTs brutos:

hist(p7$rt, prob=T)
lines(density(p7$rt))

# De fato, ela é bem assimétrica. Logo, os valores altos provavelmente não são outliers, apenas
# uma propriedade da distribuição dos tempos de reação. (Lembre-se: Baayen & Milin: 2010).
# Talvez consigamos resolver isso com uma transformação no futuro.
# Vamos ser conservadores e deixar esses pontos aí (talvez por agora).

# Ignoremos essa questão por enquanto e apliquemos um modelo misto a nossos dados:
# ant e verbo como efeitos fixos; intercepto para sujeitos e itens como aleatórios.

require(lme4)

modelo.misto=lmer(rt~ant+verbo+(1|suj)+(1|itens), data=p7)

# Observe que usamos o símbolo "+" entre os fatores fixos. Isso será importante daqui a pouco!

# Vamos sumarizar o modelo:

summary(modelo.misto)

# Vamos olhar para a tabela dos efeitos fixos:
#------------------------------------------------
# Fixed effects:
#               Estimate    Std. Error  t value
# (Intercept)   782.79      63.25       12.377
# Antpp         -89.16      43.36       -2.056
# Verbosg       20.77       43.36       0.479
#------------------------------------------------

# Entender essas estimativas será um pouco mais complicado, mas vamos a elas!

# Primeiro, lembremos que agora temos os seguintes fatores:
# Ant: np ou pp
# Verbo: sg ou pl

# Logo, temos um design 2 x 2 com as seguintes condições:
# np.sg; np.pl; pp.sg; pp.pl ---> como vimos nos boxplots

# Vamos explorar a tabela p7 e descobrir as médias para cada condição:

aggregate(p7$rt, by=list(p7$ant, p7$verbo), mean)

#---------------------------------------------------------------------
# Você pode fazer a mesma coisa em uma clássica tabela condicional:

tapply(p7$rt, list(p7$ant, p7$verbo), mean)

# Nesse caso, gosto até mais dessa!
#---------------------------------------------------------------------

# Agora a coisa complicou! Nenhum desses números aparece nas estimativas do modelo!
# De onde o modelo tirou aquelas estimativas?

# Vamos descobrir, mas primeiro, vamos entender o que essa tabela está nos mostrando.
# Se tivéssemos olhado para ela ANTES, nem teríamos aplicado o modelo que aplicamos!

# As médias parecem nos indicar algo interessante:
# O plural não parece influenciar muito quando mudamos de np para pp (de 734 para 741);
# Mas o singular parece afetar muito quando mudamos de np para pp (de 851 para 666).
# Isso é o que chamamos de interação. Vamos visualizá-la:

interaction.plot(p7$ant, p7$verbo, p7$rt)

# Ora, o nosso modelo não incluía uma interação entre os fatores fixos, marcada no R
# com o símbolo *
# Esse um dos motivos pelos quais suas estimativas são péssimas para descrever os dados.
# E as suas estimativas não chegam nem perto dessas médias aí.
# Mas de onde ele as tirou?
  
# vamos criar duas tabelas, cada uma com as médias globais para Ant e para Verbo:

tapply(p7$rt, p7$ant, mean)

tapply(p7$rt, p7$verbo, mean)

# Agora vamos calcular a diferença entre essa média de médias
# Você pode fazer "no braço" mesmo ou até de cabeça, nesse caso:

704.0156-793.1758

# Agora compare esse resultado com as estimativas do modelo:
# Viu o que está acontecendo?

# Esse valor (-89.16 ms) é justamente o que o modelo estimou para Ant:pp.
# Ou seja, quando Ant=pp, o tempo tende a ser mais rápido em relação a quando o ant=np.
# Pense nisso com calma, olhando para a tabela e veja se de fato entendeu.
# O modelo desconsiderou o número do verbo, olhando apenas para o tipo de antecedente!

# Agora vamos fazer a mesma coisa para o fator Verbo:

758.9805-738.2109

# Se você entendeu bem o que o modelo fez antes, entenderá agora também!

# Agora compare com as estimativas do modelo:
  
fixef(modelo.misto)

# Percebeu?
# O modelo fez o seguinte:
# Considerou o efeito do tipo de Antecedente: antecedente pp acelera o tempo em 89 ms;
# E considerou o efeito do tipo de Verbo: verbo no sg desacelera o tempo em 20 ms.
# Mas ele considerou cada um independentemente!
# Como se tipo de antecedente tivesse sempre o mesmo efeito, seja o verbo sg ou plural.

# Se fôssemos comparar com uma ANOVA, o que esse modelo está nos dando é uma espécie de
# efeito principal ("main effect"), de tipo de Ant e de número do verbo.

#-----------------------------------------------------------------------------------------
# Essa é apenas uma explicação didática. Para discutirmos mais detalhadamente isso,
# precisaríamos falar de contrastes. Algo que não nos cabe nesse momento.
#-----------------------------------------------------------------------------------------

# Vamos retornar ao nosso interaction plot (se ele já não estiver aí na sua tela):

interaction.plot(p7$ant, p7$verbo, p7$rt)

# Observe que esse efeito é ilusório:
# Tipo de antecedente, quando aplicado a verbos no pl não tem efeito nenhum:
# a linha está praticamente reta.
# Quando aplicado a verbos no singular tem um efeito enorme: se ant for pp, o tempo é bem
# rápido (666 ms); se ant for sg, o tempo é bem lento (851 ms)!

# Se estivéssemos modelando esses dados com uma ANOVA, diríamos que o efeito principal foi
# "puxado" pela condição np.sg em contraste com np.pl.

#------------------------------------------------------------------------------------------
# Apenas para critério de comparação, você pode rodar uma ANOVA com dois fatores:

a1=aov(rt~ant+verbo, data=p7) # Aqui não acrescentamos a interação!

summary(a1)

# observe que há um efeito principal de Ant, mas não de verbo.

# Se você quiser saber qual a intensidade desse efeito, pode buscá-la com os contrastes de
# Tukey (O Teste de Honestidade de Significância de Tukey resolve isso):

TukeyHSD(a1)

# Observe esses resultados! São idênticos aos do modelo misto: -89.16 e 20.76 ms.
#--------------------------------------------------------------------------------------------

# A questão é que não importa o modelo que estejamos modelando, esses dados pedem uma 
# interação: quando os níveis de uma variável têm efeitos diferentes dependendo dos
# níveis da outra variável.

# Nosso modelo, então, precisa de uma alteração. Vamos incluir uma interação entre
# fatores fixos:

mod.int=lmer(rt~ant*verbo+(1|suj)+(1|itens), data=p7) # o símbolo da interação é *

summary(mod.int)

# Primeiro, temos uma enorme tabela de correlação lá embaixo. Vamos ignorá-la por
# enquanto.

# Vamos entender o que está acontecendo aqui:
# Se pp está sendo mostrado, o que sobrou (np) foi modelado no intercepto;
# Se sg está sendo mostrado, o que sobrou (pp) foi modelado no intercepto.
# Logo, o intercepto é a média de np.pl (734.7109): confira a tabela de médias!

tapply(p7$rt, list(p7$ant, p7$verbo), mean)

# Mas como o modelo chegou a esse resultado? Que conta ele está fazendo?

# pode-se dizer que np e pl receberam, respectivamente, contraste zero (0):

contrasts(p7$ant)

contrasts(p7$verbo)

# Algebricamente, na fórmula da regressão:

#-------------------------------
# np.pl
# y=734.71 + (a*ant)+(b*verbo)
# y=734.71 + (a*np)+(b*pl)
# y=734.71 + (a*0)+(b*0)
# y=734.71-------------------------> A média de np.pl
#-------------------------------

# Mas o que significa ant:pp 7, estimado pelo modelo?
# Ora, como vimos com os contrastes, se np é zero, então pp é 1;
# Se pl é zero, então sg é 1.

# Substituamos na fórmula da regressão:
#------------------------------
# pp.pl
# y=734.71 + (a*ant)+(b*verbo)
# y=734.71 + (a*pp)+(b*pl)
# y=734.71 + (a*1)+(b*0)
# y=734.71 + (a*1)
# y=734.71 + a

# Ora, o modelo sabe que a média de pp.pl (y) é 741.71 (ela está na tabela). Logo:

# 741.71=734.71 + a 
# a=741.71-734.71
# a=7 -------------------> a estimativa para essa condição!
#------------------------------

# Você entendeu o que o modelo está te mostrando com aquele 7 em ant:pp?
# Mantendo o intercepto como base (np.pl) e mudando só o antecedente (para pp.pl),
# temos um acréscimo de 7 no RT. Confira o gráfico de interação!

# Agora vamos para a próxima estimativa mostrada pelo modelo:
#------------------------------
# np.sg
# y=734.71 + (a*ant)+(b*verbo)
# y=734.71 + (a*np)+(b*sg)
# y=734.71 + (a*0)+(b*1)
# y=734.71 + (b*1)

# Como para o caso anterior, o modelo sabe (pelas observações), que a média(y)
# para np.sg é 851.64. Logo:

# 851.64=734.71 + b
# b=851.64-734.71
# b=116.93 -------------------------> A estimativa de np.sg dada pelo modelo!
#------------------------------

# Dos efeitos fixos mostrados pelo modelo, já entendemos quase todos:
# Faça um exercício: contraste os efeitos fixos com a tabela de médias e diga a que
# contrastes os efeitos fixos estão se referindo:

fixef(mod.int)

tapply(p7$rt, list(p7$ant, p7$verbo), mean)

# Percebeu, o modelo está comparando cada uma das condições com a que foi modelada no
# intercepto.

# Mas ainda falta entendermos a interação ant:pp x verbo: sg.
# O que ela significa?

# Erro: pensar que a interação mostra a média de pp.sg.
# Observe que não:

#------------------------------
# pp.sg
# y=Intercepto - Interação
# y=734.71-192.32
# y=542.39-------------------------> NÃO é a média de pp.sg dada na tabela!
#------------------------------

# A nossa tabela de médias mostrava para pp.sg uma média de 666.3203

# Entendendo a interação!

# Lembra-se dos contrastes?

contrasts(p7$ant)

contrasts(p7$verbo)

# Vamos substituí-los na fórmula da regressão:
#--------------------------------------------------------
# y=intercepto + (a*Ant)+(b*Verbo)+c*(Ant*Verbo)
# y=734.71 + (a*pp)+(b*sg)+(c*(pp*sg))
# y=734.71 + (a*1)+(b*1)+(c*(1*1))

# Ora, aqui está a grande sacada da regressão! O modelo já sabe os valores de a e b
# Então:

# y=734.71 + (7*1)+(116.93*1)+(c*(1*1))
# y=734.71 + 7+116.93+c
# y=734.71 + 123+c

# Ora, ele também sabe o valor de pp.sg (está na tabela de média dos dados!)

# 666.32=734.71 + 123.93+c
# c=666.32-734.71-123.93
# c=-192.32 ------------------> a interação mostrada pelo modelo!
#--------------------------------------------------------

# Olhe para o gráfico da interação e tente entender visualmente cada uma dessas diferenças.

# Como interpretar a interação?
# Eu preciso fazer todas essas contas para usar um modelo misto?!
# Vamos voltar para o nosso gráfico de interação (espero que ele esteja aí na tela);
# E para os efeitos fixos do nosso modelo.

fixef(mod.int)

# Qual era a pergunta teórica que se fazia nesse experimento?
# Vamos fazer uma análise aqui apenas nos valores brutos, porque ainda não discutimos
# a questão dos p-valores, que nos modelos mistos é complexa.

# (i) Se verbos meteorológicos plural eram mais rapidamente lidos com antecedentes
# do tipo pp ou np.
# A diferença de apenas 7 nos mostrou que provavelmente não: o tipo de antecedente não
# influencia no tempo de leitura quando o verbo está no plural.

# (ii) Se verbos meteorológicos singular eram mais rapidamente lidos com antecedentes
# do tipo pp ou np.
# A diferença na interação de -192.32 nos mostrou que provavelmente sim, que quando se tem um
# verbo no singular, o Ant np o faz ser lido muito mais lentamente (maior rt).
# Fixa-se o número do verbo e muda-se o tipo de Antecedente!!!

# (iii) Se, com antecedentes np, os verbos meteorológicos seriam lidos mais rapidamente
# com o plural ou com o singular.
# A diferença de 116.93 nos mostrou que provavelmente sim.
# Fixa-se o tipo de antecedente e muda-se o número do verbo.

# O que queremos dizer é que: você não precisa fazer as contas para interpretar
# um modelo misto. Mas sabê-las torna mais simples lidar com eles.

#------------------------------------------------------------------------------------
# Observe que, no caso de um ANOVA, você também deveria incluir a interação:

a2=aov(rt~ant*verbo, data=p7) # com interação!

summary(a2) # efeitos principais de ant e da interação!

TukeyHSD(a2)

# Observe que a análise post-hoc deu significativa apenas para o contraste:
# pp:sg x np:sg (p=0.01), com o valor de -185.32 ms (justamente a diferença
# entre as médias dessas duas condições)
# Observe que o valor estimado para "ant" e "verbo" continuam idênticos!
#-------------------------------------------------------------------------------------

# Mas,então você irá se perguntar: se a ANOVA dá os mesmos resultados que um modelo misto,
# por que usar modelos mistos e não ANOVA?!
# O fato é que não dá. Vários autores têm demonstrado, desde Clark (1974), que a ANOVA pode
# levar a erros do tipo II muito facilmente porque ela não controla a variância dos sujeitos
# e dos itens no mesmo modelo. Uma boa leitura inicial (menos técnica) é Raaijmakers_2003,
# disponível na pasta do curso.

###################
# Apenas para imitar o que fizemos com o modelo com um fator apenas, vamos montar uma tabela
# que decomponha os valores estimados pelo modelo misto.
###################

# Você pode só rodar o código abaixo e inspecionar a tabela.
#-------------------------------------------------------------------------------------------------------
require(dplyr) # se ainda não o tiver feito

p7$intercepto=rep(734.71, length(p7$suj)) # intercepto

p7=mutate(p7, fixef.ant=if_else(p7$ant=="np", 0, 7.00)) # Fator fixo do antecedente
p7=mutate(p7, fixef.verbo=if_else(p7$verbo=="pl", 0, 116.92)) # Fator fixo do verbo

# Efeitos aleatórios dos sujeitos (intercepto para os sujeitos)
#-----------------------------------------------------------------------------------------------------
ranef.suj=as.data.frame(ranef(mod.int)) # recupera os dados dos efeitos aleatórios em um data frame

ranef.suj=ranef.suj[1:32,] # pega apenas os dados dos sujeitos e ignora os itens

ranef.suj=select(ranef.suj, c(grp, condval)) # seleciona apenas as colunas grp e condval

ranef.suj$condval=round(ranef.suj$condval, 3) # arredonda a coluna condval para 3 casas decimais

colnames(ranef.suj)[2] <- "ranef.suj" # renomeia a coluna "condval" para "ranef.suj

p7=inner_join(p7, ranef.suj, by=c("suj"="grp")) # junta o data frame ranef.suj a long baseado na coluna "suj" e "grp"

#-----------------------------------------------------------------------------------------------------

# Efeitos aleatórios para os itens (intercepto para os itens)
#---------------------------------------------------------------------------------------------
itens=as.data.frame(ranef(mod.int))

ranef.itens=select(itens, c(grp, condval))

ranef.itens$condval=round(ranef.itens$condval, 3) 

ranef.itens=ranef.itens[33:48,]

colnames(ranef.itens)=c("itens", "ranef.itens")

p7=inner_join(p7, ranef.itens, by=c("itens"))
#---------------------------------------------------------------------------------------------

p7$residuos=round(residuals(mod.int), 3) # Finalmente, os resíduos!
#---------------------------------------------------------------------------------------------
# Agora investigue a tabela!

head(p7)

str(p7)

# Repare que suj e itens foram convertidos para character. Vamos voltá-los para fatores:

p7$suj=as.factor(p7$suj)

p7$itens=as.factor(p7$itens)

str(p7)

# Veja que o modelo está decompondo os valores observados em vários elementos!
# Invista um tempo em analisar cada um desses elementos!

# Vamos dar uma pausa por aqui para prosseguirmos ao diagnóstico do nosso modelo!