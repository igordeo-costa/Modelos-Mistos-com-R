# Reportando seu modelo
# Estatística de t, intervalo de confiança e p-valor

# Os modelos mistos, em geral, não reportam um p-valor.
# Por quê?
# É complicado, para esses modelos, calcular os graus de liberdade.
# Há uma intensa discussão nos meios acadêmicos sobre isso.
# Então, como fazer?

#---------------------------------
# Primeira opção: estatística t
# Recomendação do curso do Denis!
#---------------------------------
# A distribuiçao de t, quando tem altos graus de liberdade, se aproxima de uma
# distribuição z.
# Logo, num modelo misto, se o t-valor estimado pelo modelo for maior do que 1.96, isso
# significa que o p-valor seria menor do que 0.05.

# Na verdade, com graus de liberdade infinitos, os valores são
# (Valores retirados de Bussab & Morettin, 2012: 513):

valor.de.t=c(1.960, 2.054, 2.326, 2.576, 3.090, 3.291)
p.valor=c(0.05, 0.04, 0.02, 0.01, 0.002, 0.001)
p.valores=data.frame(valor.de.t, p.valor)

p.valores

#------------------------------------------------------------------------------
# Se você não confia nesses dados, pode pedir para o R calcular para você:

qt(c(.025, .975), df=250) # Aqui com 250 graus de liberdade e 0.05 de confiança

#-------------------------------------------------------------------------------

# Observe no nosso modelo que o t-valor para cond. sing é igual a 3.75. Logo, temos confiança
# para dizer que temos um valor significativo a 5%.

summary(mod.misto)

# Na verdade, temos um t-valor maior do que 3.2. Logo, nosso p-valor é menor do que 0.001.

# Mas nós não vamos reportar esse modelo. Vamos reportar aquele com as transformações
# logarítmicas e a retirada dos NAs.

summary(mod.final)

# Aqui o nosso t-valor está em 2.98, o que é equivalente a um p-valor de 0.002.

#----------------------------------------------------------------------------------------------------------
# "Aplicou-se aos dados um modelo linear de efeitos mistos, com logaritmo do tempo para a primeira fixação
# como variável resposta, condição (multiple e single) como efeitos fixos e intercepto para sujeitos
# e itens como efeitos aleatórios (a máxima estrutura de efeitos aleatórios antes de alcançar um ajuste
# singular - Barr et al., 2013). Resultados indicam que a condição single aumenta o tempo em 1.26ms em
# relação à condição multiple: single=0.45log(ms); t(inf.)=2.98, p=0.002."
#----------------------------------------------------------------------------------------------------------

#-----------------------------------------
# Segunda opção: intervalo de confiança
#-----------------------------------------

# Primeiro, o que é um intervalo de confiança?
# Imagine uma situação hipotética em que façamos 10 mil amostras de uma população.
# Daí calculamos as médias para cada uma delas.
# Então construímos um intervalo em que estejam, digamos, 95% dessas médias.
# Existe uma probabilidade de 95%, portanto, de que a média populacional real esteja
# dentro desse intervalo, concorda?

# Mas nós não temos 10 mil amostras, temos apenas uma: a do nosso experimento.
# Logo, construímos um intervalo que contenha a média dessa amostra.
# Logo, existe a probabilidade de 95% (ou 90% ou 99%) de que esse intervalo
# que contém a média seja um dos 95% intervalos possíveis que contenham a média poulacional.

# Use a função confint() para calcular o intervalo de confiança do nosso modelo:

confint(mod.misto)

# Como reportar: (cond: sg = 1.26 ms; IC 95%, 0.59-1.93)

# Como interpretar: Existe 95% de probabilidade de o intervalo que vai de 0.59 a 1.93ms ser
# um dos intervalos que contenham a média populacional.
# Se repetirmos o experimento infinitas vezes, 95% do tempo a média estará nesse range.
# Logo, como a nossa amostra está dentro desse intervalo (1.26ms)...

# Caso você peça ajuda para função confint(), verá que existe o argumento level, que define
# o valor do intervalo desejado (o padrão é 0.95):

?confint

# Vamos tentar com 0.99:

confint(mod.misto, level=0.99) 

# Nesse caso: (cond: sg = 1.26 ms; IC 95%, 0.36-2.1)
# Observe que tendo mais certeza do meu intervalo (99% deles estão nesse range),
# torna-se menos precisa minha estimativa.

# Vamos analisar o nosso modelo final:

confint(mod.final)

#----------------------------------------------------------------------------------------------------------
# "Aplicou-se aos dados um modelo linear de efeitos mistos, com logaritmo do tempo para a primeira fixação
# como variável resposta, condição (multiple e single) como efeitos fixos e intercepto para sujeitos
# e itens como efeitos aleatórios (a máxima estrutura de efeitos aleatórios antes de alcançar um ajuste
# singular - Barr et al., 2013) . Resultados indicam que a condição single aumenta o tempo em 1.26ms em
# relação à condição multiple: single=0.45log(ms); IC 95%, 0.15-0.74."
#----------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------
# Uma recomendação do Denis:

# Se seu modelo tem 'random slopes', então você precisará passar pela função confint()
# o argumento "method="Wald":

confint(mod.misto, method="Wald") # o que não é o nosso caso aqui.
#-----------------------------------------------------------------------------------------

#-------------------------------------
# Terceira opção: calculando p-valor
#-------------------------------------
# Se o seu parecerista pedir de fato um p-valor, então você pode tentar achá-lo:
# Primeiro: ninguém recomenda buscar p-valor com modelos mistos.
# Os métodos não são precisos, não há modo adequado de calcular os graus de liberdade
# e há uma séria discussão na literatura a respeito do tema.

# Justamente por isso, os métodos para calcular o p-valor acabam mudando muito no R.

# O pacote LanguageR tinha a função pvals.fnc(), que não mais funciona.
# O pacote lmerTest também tem funções para tal.
# O método mais prático, porém, é instalar o pacote afex:

install.packages("afex")

require(afex)

# Com esse pacote instalado (não precisa sequer estar carregado), sempre que você
# rodar um modelo misto, ele já vai te dar um p-valor.

mod.2=lmer(tempo~cond+(1|suj)+(1|itens), data=long)

summary(mod.2)

# Nesse caso, o nosso p-valor é de 0.002.

# Para o nosso modelo final:

mod.3=lmer(log(tempo)~cond+(1|suj)+(1|itens), data=long)

summary(mod.3)

# Aqui obtivemos um p-valor de 0.005.

#----------------------------------------------------------------------------------------------------------
# Como reportar sua análise?

# "Aplicou-se aos dados um modelo linear de efeitos mistos, com logaritmo do tempo para a primeira fixação
# como variável resposta, condição (multiple e single) como efeitos fixos e intercepto para sujeitos
# e itens como efeitos aleatórios (a máxima estrutura de efeitos aleatórios antes de alcançar um ajuste
# singular - Barr et al., 2013). Resultados indicam que a condição single aumenta o tempo em 1.26ms em
# relação à condição multiple: single=0.45log(ms), t(inf)=2.98, p=0.005."

# Como há um debate sobre p-valores em modelos mistos, recomendamos sempre informar como os p-valores
# foram obtidos. Isso pode ser feito ou em nota de rodapé ao experimento, ou na apresentação inicial do mesmo:

# "Os p-valores apresentados nesse trabalho foram obtidos com o uso do pacote 'afex'."
#----------------------------------------------------------------------------------------------------------

# Se você quiser se livrar do p-valor, pode desinstalar o pacote "afex":

remove.packages("afex")
