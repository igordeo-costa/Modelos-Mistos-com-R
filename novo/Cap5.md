# O básico sobre regressão

# ANOVA
Nessa primeira parte, vamos fazer uma Análise de Variância com a função ```aov()```. Começaremos nosso trabalho carregando os dados da tabela ```first fixation.csv```. Essa tabela nos foi cedida gentilmente por Forster, Rodrigues & Corrêa (2019).

```
first=read.csv(file.choose())
```
Vamos investigar a tabela:

```
head(first)
str(first)
```

Ela apresenta:
- 1 coluna com os sujeitos;
- 1 coluna com as condições (```multiple``` e ```single```);
- 4 colunas com as respostas de cada sujeito para cada um dos 4 itens (```X10```, ```X7```, ```X8``` e ```X9```).
- O que está sendo medido é o tempo para a primeira fixação num experimento de rastreamento ocular.

Observe que essa tabela está no formato horizontal (*wide*). Precisamos, então, transformá-la para o formato vertical. Mas antes, vamos fazer umas mudanças nos nomes das colunas. Nomeie as colunas da seguinte forma:

```
colnames(first)=c("suj", "cond", "A", "B", "C", "D")
```

Visualize mais uma vez sua tabela com ```head()```. E então vamos carregar o pacote (```tidyr```).

```
require(tidyr)
```
Lembre-se de que, se você não tiver esse pacote, precisa instalá-lo. Repare que, ao instalar pacote, o nome deve estar entre aspas duplas ```"nome"```.

```
install.packages("tydir")
```

Agora sim vem a mágica! Nós vamos usar a função ```gather()```. Com ela, nós vamos criar duas novas colunas a partir de 4. A primeira coluna terá os elementos: "A", "B, "C" e "D". Ela se chamará: ```itens```. A segunda coluna terá os números correspondentes vinculados a eles: ```tempo```. E distribuídos adequadamente para sujeitos e condições. (Você vai entender melhor depois que ver a tabela pronta.)

```
long=gather(first, itens, tempo, A:D)
```

Perceba que ```tempo``` e ```itens``` foram nomes que acabamos de inventar; eles poderiam ser quaisquer nomes: ```x``` e ```y```; ```pranchas``` e ```fixação```, etc.

Vamos inspecionar a estrutura desse ```data.frame```

```
str(long)
```

Observe que a coluna ```itens``` é do tipo ```chr``` (```character```). E que a coluna ```suj``` é do tipo ```num``` (```numeric```). Vamos transformá-las em colunas do tipo ```factor``` (```fator```).

```
long$itens=as.factor(long$itens)
long$suj=as.factor(long$suj)
```

Verifiquemos mais uma vez a estrutura:

```
str(long)
```

Como no trabalho original os autores apresentaram uma ANOVA, vamos calculá-la. Vamos modelar o tempo em função do tipo de condição: ```single``` ou ```multiple```.

```
mod.anova=aov(tempo~cond, data=long)
```

Observações importantes:
- A ANOVA que acabamos de modelar não é a adequada para esse design experimental, visto que ela não incorpora a variabilidade devida aos sujeitos e aos itens, mas como ainda não discutimos "efeitos aleatórios", vamos mantê-la assim para fins didáticos.
- O R tem a função ```aov()``` e a função ```anova()```. A função que realiza um modelo de Análise de Variância é ```aov()```. Faça uma busca com ```help```:

```
?anova
?aov
```

Então fique atento!

Dito isso, vamos visualizar o sumário da nossa ANOVA.

```
summary(mod.anova)
```

Aqui temos a clássica tabela da Análise de Variância com um resultado significativo para ```cond```. Mas qual condição é mais lenta/rápida, ```single``` ou ```multiple```?! A ANOVA não nos dá. Ela apenas diz que há uma diferença sigificativa entre as amostras. Mas nós podemos conseguir diretamente da nossa tabela de dados.

```
aggregate(long$tempo, by=list(long$cond), mean)
```

O que essa função faz:
- calcula a média (```mean```) dos tempos (```long$tempo```) em função da variável condição (```long$cond```). Segundo esses dados, a condição ```single``` torna o tempo para a primeira fixação mais lento!

Pare um minutinho aqui e vá até o pôster onde esses dados foram publicados (Forster, Rodrigues & Corrêa, 2019) e procure pelo Gráfico 3. Compare as médias de lá com as daqui! Se você quiser, pode visualizar os dados com um ```boxplot```:

```
boxplot(tempo~cond, data=long)
```

Outro comentário importante: se estivéssemos aplicando um modelo "pra valer", e não apenas dando um exemplo didático, deveríamos aqui testar os pressupostos do nosso modelo. Vamos ignorar essa etapa por enquanto.

# REGRESSÃO LINEAR

Carregar o pacote ```lme4```:

```
require(lme4)
```

Existem duas funções principais que usaremos desse pacote. São elas:

- ```lmer()```: realiza modelos mistos que se sustentam na distribuição normal;
- ```glmer()```: realiza modelos mistos que se sustentam em outras distribuições;

Dica mnemônica: o ```g``` em ```glmer``` é de *generalized*. Os modelos lineares default são os que tratam de variáveis dependentes contínuas, mas eles foram "generalizados" para outros tipos de variáveis dependentes: binárias, contagem, etc. Nesse curso, vamos trabalhar apenas com variáveis contínuas. Vamos usar apenas a função ```lmer()```.

Fazer um modelo misto com tempo em função de (```~```) ```cond``` e ```Sujeitos``` e ```Itens``` como fatores aleatórios (não vamos explicar em detalhes essa sintaxe agora. Primeiro vamos entender a lógica por aqui. Quando estivermos mais avançados, detalharemos melhor.)

```
mod.misto=lmer(tempo~cond + (1|suj) + (1|itens), data=long)
```

Sumarizar o modelo:

```
summary(mod.misto)
```

Os modelos mistos têm um output gigantesco. Vamos observá-lo com calma! Informações básicas sobre o modelo rodado:
```
#-------------------------------------------------------------------------------
# Linear mixed model fit by REML ['lmerMod']
# Formula: tempo ~ cond + (1 | suj) + (1 | itens)
# Data: long
# REML criterion at convergence: 534.1
#-------------------------------------------------------------------------------
# Quantis dos resíduos do modelo
#-------------------------------------------------------------------------------
# Scaled residuals:
#   Min       1Q        Median    3Q       Max
#   -2.15994  -0.57818  -0.09132  0.40515  2.99107
#-------------------------------------------------------------------------------
# Tabela sobre os efeitos aleatórios
#-------------------------------------------------------------------------------
# Random effects:
#   Groups   Name        Variance Std.Dev.
# suj      (Intercept) 0.3474   0.5894  
# itens    (Intercept) 1.5878   1.2601  
# Residual             2.4805   1.5750  
# Number of obs: 136, groups:  suj, 34; itens, 4
#-------------------------------------------------------------------------------
# Tabela sobre os efeitos fixos
#-------------------------------------------------------------------------------
# Fixed effects:
#               Estimate    Std. Error  t value
# (Intercept)   2.0221      0.6737      3.001
# condsing      1.2674      0.3374      3.757
#-------------------------------------------------------------------------------
# Tabela de correlação entre os efeitos fixos
#-------------------------------------------------------------------------------
# Correlation of Fixed Effects:
#           (Intr)
# condsing  -0.250
#------------------------------------------------------------------------------
```

Não vamos entrar em detalhes agora sobre toda ela. Isso será feito ao longo das aulas. Vamos ficar com a Tabela sobre efeitos fixos e entender o que ela significa.

Vamos comparar essa tabela com a de um modelo linear simples (sem fatores aleatórios). A função para aplicar esse modelo é default do R e se chama ```lm()```:

```
mod.simples=lm(tempo~cond, data=long)
```

Olhe com atenção para essa sintaxe. Agora compare-a com a sintaxe da ANOVA que fizemos:

```
mod.anova=aov(tempo~cond, data=long)
```

Elas são idênticas. Agora vamos sumarizar o modelo simples:

```
summary(mod.simples)
```

Observe as estimativas dos ditos "Coefficients" (```mod.simples```) em contraste com as estimativas dos "Fixed effects" (```mod.misto```). Se você quiser, pode acessá-las com as seguintes funções:

```
coefficients(mod.simples)
```
Mais abreviadamente, você pode usar ```coef()```:

```
coef(mod.simples)
fixef(mod.misto)
```

Como você deve ter notado, elas são idênticas! Mas às vezes podem não ser:

Por que isso ocorre?
- ```lm()``` calcula a estimativa baseada no método dos Mínimos Quadrados Ordinários (OLS);
- ```lmer()``` calcula a estimativa baseada no método REML (*Restricted Maximum Likelihood* ou *Máxima Verossimilhança Restrita*).

Mas de onde surgiram essas estimativas? Vamos usar de novo a função ```aggregate()``` para descobrir as médias:

```
aggregate(long$tempo, by=list(long$cond), mean)
```

Agora observe com carinho o resultado. Percebeu? A média do tempo para ```mult``` é idêntica ao intercepto dos dois modelos (o misto e o simples). O que isso significa? Que o modelo simplesmente calculou a média dos tempos para a condição ```mult``` e a "segurou" no intercepto. Daqui a pouco vamos discutir o que isso significa.

Mas, e o valor para ```sing``` (```3.289412```)?

Vamos trabalhar apenas com o modelo simples por enquanto. No modelo simples, esse valor era de ```1.2674```. Nada a ver com essa média. Façamos o seguinte então: subtraia o tempo de ```sing``` do de ```mult```:

```
3.289412-2.022059
```

O valor é exatamente o do modelo: ```1.267353```. O que o modelo linear está fazendo é uma coisa muito simples: tirar a média de um fator (```sing```), subtrair da média do outro (```mult```), e te dar essa diferença.

Isso é exatamente o que a ANOVA faz: comparar médias. A ANOVA diz: o tempo médio para a primeira fixação, para o fator ```mult```, é menor do que para o fator ```sing```. O modelo linear diz: mudar do fator ```sing``` para o fator ```mult``` reduz o tempo para a primeira fixação. Na verdade, a ANOVA é um tipo especial de modelo linear (mas isso fica para outra hora). Por isso tem a mesma sintaxe do modelo linear.

Quanto aos nossos dados, acabamos de descobrir algo:
- ```cond``` do tipo ```sing``` torna o tempo para primeira fixação mais lento em ```1.26 ms```.

Mas por que chamamos isso de modelo linear? Por que o modelo está "traçando" uma linha entre os pontos médios de ```mult``` e ```sing```, como no gráfico.

Vamos plotar um gráfico, usando o pacote ```ggplot2``` para visualizar esses dados:

```
require(ggplot2)
```

```
ggplot(long, aes(x=cond, y=tempo)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(col="grey")+
  theme_bw()+theme_classic()
  ```

Não discutiremos essa sintaxe aqui. Precisaríamos de um curso inteiro sobre o pacote ```ggplot2```. Mas agora precisamos entender aquelas estimativas do modelo algebricamente. Isso pode parecer idiota agora, mas será bem importante mais à frente. Então, tenha fé!

A fórmula mais básica de uma equação linear é:

```
y = (a*x) + b
```

Assim, imagine que ```a=3``` e ```b=5```:

```
y = (3*x) + 5
```

Logo, com dois valores de ```x```, podemos montar uma reta no plano cartesiano:

```
slope=c(rep(3, 5)) # cria vetor com o número 3 repetido 5 vezes
x=c(1, 2, 3, 4, 5) # vetor com os valores de 1 a 5
y=(slope*x)+5 # vetor com slope multiplicando x e somando mais 5

dados=data.frame(slope, x, y) # monta uma tabela de resultados

dados
```
Vamos plotar esses dados num gráfico:

```
plot(y~x, ylim=c(-5, 25), xlim=c(-5, 10))
```

E acrescentar algumas linhas com ```abline()```: linhas horizontal e vertical cortando o ponto (```x=0```, ```y=0```):

```
abline(h=0, col="grey") # são de cor cinza ("grey")
abline(v=0, col="grey")
```

Ora, olhando para os pontos, vemos que eles formam uma linha. Essa linha tem duas características importantes:
- Quando ```x=0```, ```y=5```: Vamos plotar uma linha azul horizontal cortando o eixo ```y``` em ```5```:

```
abline(5, 0, col="blue")
```

- Quando ```x``` aumenta em uma unidade, ```y``` aumenta em ```3```. Basta olhar para a relação entre x e y na tabela ```dados```. Esse valor de ```y``` é chamado de inclinação da reta (*slope*) (ou, tecnicamente, *coeficiente angular*):

```
20-17
17-14 # etc.
```

Vamos então plotar uma linha com esses parâmetros:

```
abline(5, 3, col="red")
```

Se você usar:

```
?abline
```

Verá que o primeiro parâmetro é chamado de ```intercept``` e o segundo de ```slope```. Agora retomemos nossa equação da reta:

```
y = (3*x) + 5
```

O ```3``` é justamente o valor que multiplica ```x``` na nossa função. E o ```5```?! É justamente o ponto onde a reta corta (intercepta) o eixo ```y```. Mas o que isso tudo tem a ver com nosso modelo linear? Voltemos a ele:

```
summary(mod.simples)
```

O intercepto (```2.0221```) é justamente a média de ```mult```, como já vimos. E o valor de ```sing``` (```1.2674```) é a diferença de ```mult-sing```. Imagine que tenhamos uma regressão, então, do tipo:

```
y = (1.2674)*(cond)+2.0221
```

Ora, ```cond``` pode ser de dois tipos, ```mult``` ou ```sing```, mas não podemos fazer uma conta com letras, apenas com números. Sabemos também que o intercepto (```mult```) é onde o valor de ```x``` é zero. Logo, o programa deve ter dito que ```cond```, quando ```mult```, seria codificado como ```0```.

```
# y = (1.2674)*(mult)+2.0221
# y=(1.2674)*(0)+2.0221
# y = 0+2.0221
# y = 2.0221
```

Ora, sabemos também que a inclinação é o valor que multiplica a variável (```cond```), o nosso ```x```. Logo, a inclinação é ```1.2674 ms```. Mas a inclinação é também a mudança de uma unidade da variável. Logo, o programa deve ter codificado ```cond sing``` como 1 (ou seja, uma unidade).

```
# y = (1.2674)*(sing)+2.0221
# y = (1.2674)*(1)+2.0221
# y = (1.2674)+2.0221
# y = 3.289412
```

Se você tiver alguma dúvida sobre o que o R está chamando de 0 e de 1, pode pedir a ele os contrastes que aplicou automaticamente ao fator ```cond```:

```
contrasts(long$cond)
```

Lembra das médias que calculamos com a função ```aggregate()```? O que fizemos aqui foi apenas andar em círculos: dos coeficientes para as médias para os coeficientes para as médias. *There and back again!*

Mas como isso se reflete em termos teóricos? O que essas contas todas dizem sobre os meus dados? Voltemos à fórmula da regressão linear:

```
y=(a*x)+b
```

Vamos pegar um sujeito aleatório da tabela ```long```, digamos, o de número 10:

```
dec=subset(long, long$suj==10)
dec
```

Agora vamos pegar esse sujeito em um item qualquer da condição ```mult``` digamos, o item B. O tempo para primeira fixação desse sujeito nesse item é de ```1.63 ms```. Ora, o tempo médio para primeira fixação na condição ```mult``` é de ```2.02 ms```.

```
2.02-1.63
```

Esse cidadão, portanto, é mais rápido (```0.39 ms```) do que a média dada. Ora, se o tempo fosse influenciado apenas pelo tipo ```cond``` e por um valor básico comum a todos (o intercepto), ele teria que ter um tempo idêntico ao de todos!!!

Fatores outros que não a ```cond``` e o intercepto compõem esse tempo de ```1.63 ms```. Que fatores são esses?! Não sabemos, mas precisamos incluí-los no modelo: A esses fatores não sabidos, chamamos de ```Fator de Erro, Erro ou Resíduos```.

```
# y=(a*x)+b+Erro
```

A nossa equação linear agora é do tipo acima. No caso do sujeito 10, no item B, podemos dizer que seu tempo ```y``` é dado por:

```
# y=(1.2674)*(mult)+2.0221+Erro
```

Ora, sabemos que ```mult=0```, então:

```
# y=(1.2674)*(0)+2.0221+Erro
# y=2.0221+Erro
```

Ora, sabemos que seu tempo ```y``` é de ```1.63 ms```:

```
# 1.63=2.0221+Erro
```

Logo, o Erro é de:

```
# Erro=0.39
```

Basicamente, é o valor observado menos o valor estimado (ajustado) para cada observação. Se você quiser ver os resíduos do seu modelo, você pode acessá-los:

```
mod.simples$residuals # uma lista enorme será impressa na tela!!!
```

Observe que essa lista tem exatamente 136 números, a mesma quantidade de observações da nossa tabela: um resíduo para cada observação! Agora você pode entender melhor a tabela dos modelos simples e mistos.

```
summary(mod.simples)
```

Lá existe uma parte chamada "Residuals". É justamente a distribuição dos resíduos do seu modelo, organizados em quantis. Agora que você já sabe acessá-los, você pode fazer aquela tabela do modelo manualmente com a função ```summary()```, que usamos na primeira aula:

```
summary(mod.simples$residuals)
```

Perceba que esses valores são idênticos aos resíduos apresentados no modelo simples, exceto pela média, que o modelo não mostra. Mas se você achar confuso vê-los assim, pode plotá-los também.

```
plot(mod.simples$residuals)
```

Observe que eles estão dispostos em torno do ponto zero, ou seja, a média dos resíduos é zero. Isso por que a soma dos resíduos é zero e, logo, a média é zero dividido por algo. Daí o modelo não te mostrar a média, como faz ```summary()```.

Você não vai conseguir plotar os resíduos dos modelos mistos assim:

```
plot(mod.misto$residuals)
```

Mas depois falamos disso!

Vamos então fazer uma tabela resumitiva do que fizemos até agora. É provável que você não entenda essa tabela enquanto a fazemos, mas, no final, ela fará sentido. Prometo!

Primeiro, vamos acrescentar o intercepto ajustado pelo modelo. Esse valor é idêntico para todos!

```
long$intercepto=rep(2.022, length(long))
head(long)
```

Agora, vamos acrescentar os valores de cada condição:
- ```mult```, como está no intercepto, acrescenta ```0 ms``` ao tempo;
- ```sing```, como ajustou o modelo, acrescenta ```1.281 ms``` ao tempo.

Vamos acrescentar então ```0``` quando a condição for ```mult``` e ```1.281``` quando for ```sing```:

```
require(dplyr)
long=mutate(long, coefs=if_else(long$cond=="mult", 0, 1.267))
```

Agora que você já sabe acessar e visualizar os resíduos, vamos incluí-los também!

```
long$residuos=round(residuals(mod.simples), 3)
```

Investigue novamente a tabela.

```
head(long, 2)
tail(long, 2)
```

Repare que:
- o valor observado é igual à soma dos valores restantes:

```
2.022+0+(-0.852) # para o sujeito 1
2.022+1.267+(-0.309) # para o sujeito 33
```

O que o modelo fez, portanto, foi decompor cada valor observado nos seus componentes. Na verdade, ele estimou, a partir dos valores observados, o que comporia esses valores para aquela população específica. Por isso dizemos que estamos estimando parâmetros populacionais:

- um valor comum: o intercepto;
- um valor para a condição: ```mult=0``` (zero); ```sing=1.267```;
- e o que sobrou são os resíduos, o Erro, o valor não explicado.

Observe que o resíduo é justamente isso, um resíduo, uma sobra, o que não pôde ser explicado:

```
2.98-2.022-1.267 # para o sujeito 33
```

Até agora está fácil (está?!). Vamos então fazer uma última coisa antes de complicar: Divida a área para os gráficos em 4 paineis (2 linhas e 2 colunas)

```
par(mfrow=c(2,2))
```

Agora use a função ```plot()``` para plotar um conjunto de gráficos sobre seu modelo:

```
plot(mod.simples)
```

Esses são os gráficos que acessam os pressupostos do modelo de regressão linear. Agora faça o mesmo para a ANOVA que fizemos no início!

```
plot(mod.anova)
```

Percebeu alguma diferença?! Tanto a ANOVA quanto os modelos lineares apresentam os mesmos resíduos. Compare os dois conjuntos de resíudos:

```
summary(residuals(mod.anova))
summary(residuals(mod.simples))
```

A ANOVA e o modelo linear são exatamente a mesma coisa. Agora faça um sumário dos resíduos do modelo misto:

```
summary(residuals(mod.misto))
```

Reparou como a estrutura dos resíduos do modelo misto é diferente? No entanto, lembra-se que a estrutura dos efeitos fixos é muito parecida?

```
coef(mod.simples)
fixef(mod.misto)
```

Essa a grande questão: modelos mistos apresentam resultados de efeitos fixos muito parecidos com as dos modelos simples. A diferença está em como eles lidam com os fatores de erro, a estrutura dos resíduos. E isso faz toda a diferença quando se trata de trabalhar com dados linguísticos. Quer ver como os resíduos são mesmo bem diferentes?

```
par(mfrow=c(2,1)) # divide a tela dos gráficos em dois paineis
```

Plota um histograma para os resíduos do modelo simples:

```
hist(residuals(mod.simples), prob=TRUE)
lines(density(residuals(mod.simples)))
```

Plota um histograma para os resíduos do modelo misto:

```
hist(residuals(mod.misto), prob=TRUE)
lines(density(residuals(mod.misto)))
```

Repare que os resíduos dos modelos simples são, digamos, menos próximos de uma curva normal do que os do modelo misto. Deve haver, portanto, algum componente que explica os dados no modelo misto que o modelo simples (e a ANOVA) não capturam.

Vamos então investigar esses aspectos!
