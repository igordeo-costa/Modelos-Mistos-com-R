# Aula 2: Os pressupostos dos modelos mistos
# Parte 3: Fatores aleatórios e modelos mistos

#-------------------------------------------------------------------------------
# Se você estava trabalhando na parte 2 da nossa aula, vamos retornar à nossa
# tabela original:

require(dplyr)

long=select(long, -c(intercepto, coefs, residuos))

# do contrário, você precisa da tabela "long" aqui de volta (início da aula 1_parte1)
#--------------------------------------------------------------------------------

# Agora nós já temos uma noção geral de como funcionam os modelos de regressão.
# Mas, se os valores estimados pelo modelo de regressão linear são idênticos
# aos estimados pelo modelo MISTO de regressão linear
# Por que precisamos de um modelo misto e o que é um modelo misto?
# Já dissemos que essa diferença está na estrutura dos resíduos.
# Então vamos investigar esses dados:

summary(mod.misto)

# Vamos olhar especificamente para a parte dos resíduos:
#--------------------------------------------------------------------------------
# Scaled residuals: 
#   Min       1Q        Median      3Q      Max 
#   -2.3253   -0.4842   -0.1857     0.2140  6.2501 
#--------------------------------------------------------------------------------
# Random effects:
#  Groups   Name        Variance Std.Dev.
# Sujeitos (Intercept)  82880   287.89  
# Itens    (Intercept)   2142    46.28  
# Residual             158818   398.52  
# Number of obs: 512, groups:  Sujeitos, 32; Itens, 16
#--------------------------------------------------------------------------------

# Em "Scaled residuals" temos os resíduos divididos em quartis:
# a mediana dos resíduos;
# o primeiro e o terceiro quartis.
# Isso não nos interessa muito!

# Em "Random effects" temos os efeitos aleatórios:
# Observe que aí temos um intercepto para sujeitos e um para itens;
# Mas também um valor dos resíduos!

# Mas o que diabos isso significa?

# Vamos plotar os boxplots dos resíduos em função dos sujeitos:

par(mfrow=c(1,1))

boxplot(residuals(mod.misto)~long$suj)

# Observe que alguns sujeitos são lentos e que alguns são rápidos;
# Alguns têm enorme variância e alguns são muito consistentes.

# O mesmo vale para os itens, mas em menor intensidade, nesse caso:

boxplot(residuals(mod.misto)~long$itens)

# Se você quiser, pode ver a variabilidade dos itens por condição:

boxplot(residuals(mod.misto)~long$itens+long$cond)

# Alguns levam a maior tempo para primeira fixação, alguns para menor.

#-------------------------------------------------------
# Apenas um adendo:
# Se você não gosta do símbolo $, pode usar também:

boxplot(residuals(mod.misto)~itens, data=long)
#-------------------------------------------------------

# Agora pare para pensar uma coisa:
# Olhe com carinho para os boxplots dos sujeitos:
# Alguns são rápidos, alguns lentos, alguns variam muito, outros pouco.
# Como eu posso dizer que essa variação toda não afeta meu resultado?
# Em outras palavras, ao fazer seu experimento, você seleciona, aleatoriamente,
# ALGUNS indivíduos da população, mas não todos.
# Como você poderá fazer uma inferência para toda uma população com isso?

# Essa é a ideia por trás de um fator aleatório:
# Um fator fixo é um fator escolhido/determinado pelo pesquisador;
# No entanto, há fontes de variação dos dados que são escolhidas aleatoriamente
# pelo pesquisador. Essa variação incontrolada precisa ser incluída no modelo.

# Mas aí você irá dizer: isso já não é o fator de Erro?
# Sim, mas se essa variação incontrolada for consistente de algum modo?
# Se ela o for, podemos mensurá-la e controlar ainda mais os nossos resíduos.

# Compare com o modelo simples que fizemos anteriormente:
# Nele, a fórmula da equação era:

#---------------------
# y=(a*x)+b+Erro
#---------------------

# Ou seja, um valor qualquer de y era função de:
# a = influência em y do fator fixo
# b = o intercepto (influência em y comum a todos)
# Erro = os resíduos

# No modelo misto temos:

#----------------------
# y=(a*fixo)+(c*aleatório)+b+Erro
#----------------------

# Agora estamos dizendo que um valor qualquer de y é função de:
# b = o intercepto
# Erro = os resíduos
# fatores fixos
# fatores aleatórios
# a = influência em y do fator fixo
# c = influência em y do fator aleatório
#----------------------------------------------------------------

# Vamos então investigar esses fatores (fixos e aleatórios):

# Para investigar os modelos mistos, vamos usar três funções:

#---------------------------------------------------------
# fixef()
# ranef()
# coef() # não vamos discutir essa função por agora
#---------------------------------------------------------

# A primeira é a mais fácil:

fixef(mod.misto)

# Ela simplesmente retorna os parâmetros estimados para os fatores fixos:
# Ela funciona como a função coefficients() ou coef() para o modelo lm()
# Nesse caso, a condição no intercepto (mult) foi estimada em 2.022 ms
# E a condição contrastada com ela (sing) aumenta o tempo em 1.281 ms.

contrasts(long$cond)

# Mostra que mult foi modelada no intrercepto e sing é a contrastada
# Lembre-se de que a condição sing nem sempre é idêntica à média do grupo, visto que os
# modelos mistos estimam esse parâmetro não com o método OLS (Ordinary Least Square),
# mas sim com o método dos REML (Restricted Maximum Likelihood).

aggregate(long$tempo, by=list(long$cond), mean)

# Vamos juntar à tabela long o valor do intercepto:

long$intercepto=rep(2.022, length(long))

# Isso é o mesmo que dizer que mult acrescenta 0 ms ao tempo e sing acrescenta 1.281 ms:
# vamos juntar esse valor à nossa tabela "long"

#------------------------------------------------------------------------------------------
require(dplyr) # se ainda não o tiver feito

long=mutate(long, fixos=if_else(long$cond=="mult", 0, 1.267))

# Não vamos discutir essa sintaxe agora, mas veja o que ocorreu com sua tabela

head(long)

tail(long)
#------------------------------------------------------------------------------------------

# Agora vamos investigar as outras funções: coef() e ranef()

ranef(mod.misto)

# Primeiro, observe que ranef() apresenta dois subconjuntos de dados: $suj e $itens
# Isso ocorre porque tínhamos dois efeitos aleatórios (random effects)

#-------------------------------------------------------------------------------------------
# Se quiser, você pode acessá-los separadamente com:

ranef(mod.misto)$suj

ranef(mod.misto)$itens
#-------------------------------------------------------------------------------------------
# Mas o que essa função está mostrando?

# No nosso modelo, cuja fórmula dos efeitos aleatórios era:

#-----------------------
# (1|suj) + (1|itens)
#-----------------------

# Nós pedimos para o modelo ajustar um intercepto para os sujeitos e um intercepto
# para os itens: esse "1" na fórmula significa "intercepto".

# Logo, para cada sujeito, o modelo calculou um intercepto diferente baseado
# nas observações desse sujeito em particular.
# O mesmo para os itens.

# Compare o gráfico de caixas para os itens:

boxplot(tempo~itens, data=long)

# Com os valores estimados pelo modelo para os itens:

ranef(mod.misto)$itens

# Basicamente, o que ranef está nos mostrando é como cada indivíduo/item particular difere
# da média populacional.

#-----------------------------------------------------------------------------------------
# Como ele faz isso?
# Essa é uma matemática complexa, mas os modelos lineares usam um negócio chamado:
# BLUPs: best linear unbiased predictors.
# Você pode ler Baayen, Davidson & Bates (2008) para saber mais.
#-----------------------------------------------------------------------------------------

# Vamos tentar entender isso de outra forma:
# No caso, fazendo uma tabela como fizemos para a regressão simples: lm()

# Primeiro, vamos acrescentar os efeitos aleatórios dos sujeitos à nossa tabela:

#################
# De verdade, você não precisa entender o que está acontecendo aqui.
# Se quiser, pode rodar isso e pular para a parte em que discutimos a tabela já pronta!
#################

#-----------------------------------------------------------------------------------------------------
ranef.suj=as.data.frame(ranef(mod.misto)) # recupera os dados dos efeitos aleatórios em um data frame

ranef.suj=ranef.suj[1:34,] # pega apenas os dados dos sujeitos e ignora os itens

ranef.suj=select(ranef.suj, c(grp, condval)) # seleciona apenas as colunas grp e condval

ranef.suj$condval=round(ranef.suj$condval, 3) # arredonda a coluna condval para 3 casas decimais

colnames(ranef.suj)[2] <- "ranef.suj" # renomeia a coluna "condval" para "ranef.suj

long=inner_join(long, ranef.suj, by=c("suj"="grp")) # junta o data frame ranef.suj a long baseado
# na coluna "suj" e "grp"

#-----------------------------------------------------------------------------------------------------

# E também os efeitos aleatórios dos itens:
#---------------------------------------------------------------------------------------------
itens=as.factor(c("A", "B", "C", "D"))

ranef.itens=ranef(mod.misto)$itens[1:4,] # acessa os efeitos aleatórios dos itens

z=data.frame(itens, ranef.itens) # cria um data frame com esses dados

z$ranef.itens=round(z$ranef.itens, 3) # arredonda a coluna para 3 casas decimais

long=inner_join(long, z, by=c("itens")) # junta o data frame y a long baseado na coluna "itens"
#---------------------------------------------------------------------------------------------

# Agora vamos acrescentar os resíduos:

#---------------------------------------------------------------------------------------------
long$residuos=round(residuals(mod.misto), 3)
#---------------------------------------------------------------------------------------------

# Observe a estrutura da nossa tabela e veja que o fator suj foi transformado em character.
# Vamos voltá-lo para fator:
  
long$suj=as.factor(long$suj)

#################
# Pronto, agora você já pode voltar para a discussão teórica!
#################

# Agora observe o topo e o final da nossa tabela:

head(long, 3)
tail(long, 3)

# Vamos considerar o sujeito 1: seu tempo observado foi de 1.17 ms
# Repare que esse valor é justamente a soma do restante da tabela:

2.022+0+0.199+(-0.849)+(-0.202)

# Em outras palavras, o modelo decompôs esse tempo em:
# um intercepto, igual para todos, de 2.022 ms;
# o efeito fixo da condição mult: 0 ms (modelada no intercepto);
# o efeito aleatório do sujeito: -0.060 ms (esse é um sujeito mais rápido do que a média populacional);
# um efeito aleatório de item: 1.665 ms (esse é um item que leva a maiores tempos para primeira fixação
# do que a média dos itens da população);
# e o efeito inexplicado que ficou nos resíduos: 0.643 ms.

# Você pode fazer a mesma coisa para qualquer sujeito e item da tabela.
# Digamos, o da linha 92:

long[92,]

# Vamos lembrar da regressão simples gerada com lm()
# Nela, o tempo estimado era função apenas:
# do intercepto
# dos valores ajustados e
# dos resíduos;

# Aqui, o tempo estimado é função:
# do intercepto
# dos valores ajustados para os fatores fixos
# dos fatores ajustados para os efeitos aleatórios e
# dos resíduos.

# como as estimativas dos modelos são idênticas (ou quase), podemos dizer, então,
# que o modelo misto decompõe os resíduos em outros elementos (os fatores aleatórios),
# sendo, desse modo, um modelo mais preciso.

#######################
# Mas, afinal, por que analisar os dados com o modelo misto e não com uma ANOVA?
#######################

# (i) lembre-se, ANOVA te dá que as médias são diferentes, mas não o quanto, algo que
# o modelo de regressão, misto ou não, te dá;

# (ii) o modelo misto considera a variabilidade entre sujeitos e itens e reduz o fator
# de Erro, ou melhor, contrala com mais precisão o fator de erro.

# (iii) ANOVAs levam a um p-valor inflado quando não se controla a variabilidade de sujeitos
# e itens, gerando efeitos significativos quando eles não existem! Isso não significa que as
# ANOVAs sejam modelos ruins. Elas apenas são modelos inadequados para o design experimental
# típico dos dados psicolinguísticos (com sujeitos e itens como fatores aleatórios).
# Uma dica: Raijmakers (2003) faz uma breve discussão sobre modelos contrabalanceados para os
# itens: nesse tipo de design você pode usar ANOVAs normalmente. Sugerimos a leitura aos inte-
# ressados.

# Se você quiser saber mais detalhes sobre por que não usar ANOVAs, recomendamos:
# Baayen, Davidson & Bates (2008: 399): key advantages of mixed-effect modeling.
# a partir da p.409 há um resumo dos motivos de se usar modelos mistos em psicolinguística.

# Mas por que considerar sujeitos e itens como fatores aleatórios?
# Para essa pergunta, recomendados o trecho sobre estatística inferencial da apostila do curso.

# Um resumo:
# porque, do mesmo modo como escolhemos os sujeitos aleatoriamente da população,
# por que não dizemos que também escolhemos os itens?
# Certas frases, palavras, morfemas dentre todos os possíveis morfemas da língua?!
# Pois é isso que disse Clark (1973), num artigo que se tornou clássico:
# The language as a fixed-effect fallacy.

#---------------------
# Uma recomendação extra:
# Para saber por que usar modelos mistos generalizados e não ANOVAS, veja:
# Jaeger (2008), sobretudo a partir da p.443 ("Additional advantages of mixed logit models").