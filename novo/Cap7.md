# Checando os pressupostos do modelo

Vamos continuar trabalhando com os dados da primeira fixação de Forster, Rodrigues & Corrêa (2008) e com a tabela ```long``` (volte duas aulas se você não sabe do que estamos falando):

```
require(lme4)
```

```
mod.misto=lmer(tempo~cond+(1|suj)+(1|itens), data=long)
```

Mas, antes de prosseguirmos, vamos olhar com mais atenção para os nossos dados. Até agora investigamos o funcionamento dos modelos mistos. Mas podemos de fato aplicar um modelo misto a esses dados? Essa é uma parte muito importante da estatística, mesmo quando se está fazendo uma ANOVA: *fazer o diagnóstico do modelo*.

Os principais pressupostos dos modelos de regressão (incluindo a ANOVA) são:
- Normalidade;
- Homecedasticidade (homogeneidade de variância);
- Independência das observações.
- Além disso, valores extremos (*ouliers*) sempre podem enviesar os resultados.

Nós vamos seguir aqui (não integralmente) o protocolo proposto por:
- Zuur et al. (2010).
- Esse autor, além de muitos outros, argumenta para se confiar mais na análise visual (gráficos) do que nos testes... Mais à frente discutiremos por quê...

## Valores extremos ou *outliers*

Um *outlier* é um valor relativamente maior ou menor do que a média das observações. Alguns manuais dizem que um *outlier* é um ponto 3.5 vezes além da média ou número que o valha. Não vamos nos ater a isso! Um modo (errado) de identificar um *outlier* é olhando para os pontos além dos extremos em um boxplot:

```
boxplot(tempo~cond, data=long)
```

Outro modo (mais preciso) é investigar os dados com o gráfico de pontos de Cleveland:

```
dotchart(long$tempo)
```

Elementos muito à esquerda ou muito à direita, isolados, geralmente são *outliers*. No nosso caso, não parece haver nenhum ponto muito isolado, apesar de haver alguns bem à direita. Um breve comentário sobre tempo de reação em geral. Nunca são normalmente distribuídos: são geralmente assimétricos (*skewed*), tendo uma cauda maior à direita. No nosso caso, então, tudo bem. *No outliers!* Podemos prosseguir!

Mas se tivéssemos? Se o *outlier* advier de um erro de medição ou algo assim, deve ser excluído! Se representa variação de fato observada, tem de ser mantido! Se retirar, sempre reportar quantos dados tirou (valor bruto) e quantos % representa das observações totais. Se são valores genuínos que comprometem o modelo a ser usado (como geralmente acontece com os modelos de regressão), uma transformação é possível. Ver Zuur et. al (2010) para um debate inicial sobre esse ponto!

## Normalidade

Primeiro ponto: modelos de regressão (mistos ou não, e isso inclui ANOVA), assumem que os dados crus são normalmente distribuídos. Um corolário disso é que, se os dados crus são normais, então os resíduos do modelo também o são. Apesar disso, regressão é robusta contra a violação desse pressuposto!

O método mais comum de acessar normalidade dos dados é acessando a normalidade dos resíduos do modelo por meio de um histograma:

```
hist(residuals(mod.misto), prob=TRUE)
lines(density(residuals(mod.misto)))
```

Um outro modo é fazendo um gráfico em que se plotam os quantis dos resíduos contra os quantis de uma distruição normal padrão ("teórica"). Você pode fazer isso manualmente, usando ```qqnorm```:

```
qqnorm(residuals(mod.misto))
```

E adicionar uma linha a ele:

```
qqline(residuals(mod.misto))
```

Ou, para os modelos mistos, usar a função ```qqmath``` do pacote ```lattice``` (bem melhor!):

```
require(lattice)
qqmath(mod.misto, id=0.05)
```
*Grosso modo*:
- Linha reta: resíduos seguem distribuição normal. Tudo bem com seus dados!
- Do contrário: resíduos não seguem normalidade. É preciso fazer algo!

No nosso caso, não estão, o que já era esperado, visto que dados de tempo geralmente são assimétricos (*skewed*). Solução: uma transformação que garanta normalidade! Já já voltamos a ela!

Mas se o parecerista pedir um teste de normalidade? Você pode fazer alguns:
- Shapiro-Wilk:

```
shapiro.test(residuals(mod.misto)) # Teste de Shapiro-Wilk para normalidade
```
- Komolgorov-Smirnov:

```
ks.test(residuals(mod.misto), "pnorm") # Teste de Komolgorov-Smirnov para normalidade
```

Em ambos, a Hipótese nula: população é normalmente distribuída. Logo: p-valor menor do que 0.05 significa que você tem evidências para sustentar a hipótese alternativa: ela não é normalmente distribuída! Que é o nosso caso... segundo o primeiro teste, mas não o segundo...

Esses uns dos motivos para Zuur et al (2010) sugerirem evitar os testes e se concentrar na análise visual:
- maioria dos modelos estatísticos que assumem normalidade são robustos contra violação;
- para grandes amostras, o teorema central do limite garante normalidade;
- para pequenas amostras, o poder do teste de normalidade é pequeno;
- para grandes amostras, o teste de normalidade é sensível a pequenos desvios (contradizendo o teorema central do limite).

Vamos ficar com ele então e sustentar que nossos dados não são normalmente distribuídos, como mostra o ```qqnorm``` e o ```qqmath```. Qual a solução nesse caso? Uma transformação dos dados! Daqui a pouco voltamos a ela.

# Homoscedasticidade

Homoscedasticidade é o contrário de heteroscedasticidade. Seus dados têm de ser homoscedásticos! Mas primeiro, o que é isso? Homoscesdasticidade se refere à homogeneidade de variância. Em geral, modelos lineares só conseguem comparar fatores quando a variância de cada um deles é semelhante. Você pode verificar visualmente a homogeneidade da variância com um ```boxplot``` dos resíduos.

```
boxplot(residuals(mod.misto)~long$cond)
```

Mas é muito difícil dizer de fato se as variâncias são semelhantes ou não. Pelos ```boxplots``` parece que a variância de ```mult``` é menor do que a de ```sing```. Mas o melhor mesmo é verificar plotando os valores dos resíduos x valores ajustados (```fitted```):

```
plot(residuals(mod.misto)~fitted(mod.misto))
```

Se achar essa opção complexa demais, pode usar essa (bem melhor!):

```
plot(mod.misto)
```

Se os pontos estiverem distribuídos uniformemente pelo gráfico, em torno da linha, então seus dados são homogêneos: não há problemas por aqui! Mas se eles estiverem em algum formato (p. ex. de cone), então são heteroscedásticos: você precisa dar um jeito nisso!

Para melhorar ainda mais, você pode acrescentar os seguintes parâmetros à função ```plot```:

```
plot(mod.misto, type=c("p", "smooth"))
```

Nesse caso, se a linha "smooth" estiver praticamente reta, isso é um bom sinal. Do contrário, seus dados são heteroscedásticos! *Houston, we have a problem!*

Você pode (e deve!) também, plotar um *Scale-Location Plot*. Nesse caso, você vai plotar os valores ajustados contra os resíduos estandardizados: a raiz quadrada dos valores absolutos dos resíduos:

```
plot(mod.misto,
  sqrt(abs(resid(.)))~fitted(.),
  type=c("p", "smooth"))
```

Repare que os resíduos aumentam na medida em que aumentam os valores ajustados (```fitted```). A linha, portanto, não está horizontal e os dados não são homoscedásticos.

Mas... e se o parecerista pedir um teste... Você pode fazer um teste de Levene, que está no pacote ```car```:

```
require(car)
leveneTest(residuals(mod.misto)~long$cond)
```

A Hipótese nula é a de que a variância das populações são iguais. Logo: p-valor menor do que 0.05 significa que você tem evidências para sustentar a hipótese alternativa: ela não é homogênea! No nosso caso, os dados não são normais e não são homoscedásticos! Qual a solução?

Uma primeira possibilidade é uma transformação dos dados! Uma outra opção é desistir do modelo de regressão e investir em um modelo que não requeira homogeneidade de variância! Mas veja na apostila do curso a discussão sobre isso. Como nos informa Howell (2010), descobrir que um tratamento qualquer torna as variâncias diferentes já é um achado em si.

## Correlação

- Notícia ruim: Esse talvez seja o maior problema que os modelos de regressão podem apresentar;
- Notícia boa: Não tem notícia boa!
- Notícia péssima: É um tema tão complexo que não vamos discuti-lo nesse curso.

## Independência das observações

Cada uma das observações da variável resposta são independentes? Em outras palavras, mensurou-se o tempo para a primeira fixação do sujeito ```x``` em 4 momentos diferentes. Como saber que o tempo na primeira condição não influenciou na segunda? Como saber que o sujeito não está sofrendo de um efeito de fadiga e ficando mais lento à medida que realiza o experimento? Ou que está ficando mais rápido à medida que avança no experimento? Se isso ocorre, as observações não são independentes!

- Notícia ruim: Não é problema fácil de identificar.
- Notícia boa: Modelos mistos lidam bem com esse problema, como informa Baayen, Davidson & Bates (2008). Por isso, vamos ficar aqui por enquanto.

## Aplicando uma transformação
Agora que fizemos o diagnóstico, vamos tentar solucionar os problemas. Vamos tentar uma transformação logarítmica da variável resposta: a função ```log()``` realiza a transformação. Vamos aplicá-la direto no modelo:

```
mod.log=lmer(log(tempo)~cond+(1|suj)+(1|itens), data=long)
```

Você deve ter recebido uma mensagem de erro parecida com essa:

```
Error in mkRespMod(fr, REML = REMLpass) : NA/NaN/Inf in 'y'
```

Tentemos descobrir o que está acontecendo. Comecemos criando uma nova coluna na nossa tabela com os tempos transformados para então investigá-la visualmente!

```
log.t=log(long$tempo) # cria um vetor com os logaritmos
long$log.t=log.t # adiciona à tabela
```
Agora imprima a tabela na tela e veja se encontra algo estranho na coluna ```log.t``` Achou? Em pelo menos dois lugares há ```-Inf``` em vez de um número. Isso ocorre porque a observação era ```zero``` e o logaritmo de zero não é computável.

```
log(0)
```

Daí o modelo misto não saber lidar com essa informação. Foi isso que o código de erro nos informou: ```NA/NaN/Inf in 'y'```. (```NA = Not Available```; ```NaN = Not a Number```; e ```Inf = Infinito```). Vamos excluí-la, portanto!

Observe que há apenas dois casos desse na tabela:

```
subset(long, long$tempo==0)
long=subset(long, long$tempo!=0) # Retira as duas linhas de zero da tabela
```
Agora vamos rodar o modelo novamente!

```
mod.log=lmer(log(tempo)~cond+(1|suj)+(1|itens), data=long)
summary(mod.log)
```

Antes de concluir qualquer coisa, lembre-se de que as estimativas agora não mais estão em segundos, mas em logaritmo de segundos! Poderíamos partir para uma investigação dos pressupostos do modelo, mas precisamos interromper novamente, porque há uma consideração teórica muito importante nesse ponto: há, nos nossos dados, valores entre 0 e 1 e valores acima de 1:

```
plot(long$tempo, ylim=c(-1,10))
abline(h=1, col="blue") # linha horizontal em 1 segundo
```
Como nos informa Osborne (2008), não podemos aplicar uma transformação logarítmica a dados dessa natureza (veja mais detalhes sobre isso na apostila do curso). Temos agora uma opção antes da transformação: fazer outra transformação. Vamos começar com a sugerida por Osborne (2008): simplesmente somar 1 a todos os valores de tempo, de modo que todos eles fiquem acima de 1.

```
plot(long$tempo+1, ylim=c(-1,10))
abline(h=1, col="blue")
```

Acima apenas mostramos no gráfico por motivos didáticos. Agora vamos fazer de verdade, já aplicando no modelo ambas as transformações (```+1``` e ```log()```).

```
mod.log2=lmer(log(tempo+1)~cond+(1|suj)+(1|itens), data=long)
summary(mod.log2)
```

Daí podemos fazer a análise dos pressupostos do modelo, que não parecem muito bons (faça um exercício: olhe para os gráficos e tente explicar por que eles não estão legais):

```
qqmath(mod.log2, id=0.05) # Não normal!

plot(mod.log2, type=c("p", "smooth")) # Não homoscedástico!

plot(mod.log2, sqrt(abs(resid(.)))~fitted(.), type=c("p", "smooth"))
```

O teste de Levene, porém, deu significativo, ou seja, temos evidência para sustentar a hipótese alternativa, de que os dados são homogêneos:

```
leveneTest(residuals(mod.log2)~long$cond)

```

E o teste de Shapiro-Wilk dá não significativo, apesar de o Komolgorov-Smirnof dar:

```
shapiro.test(residuals(mod.log2))
ks.test(residuals(mod.log2), "pnorm")
```
Vamos assumir, com os gráficos, que nosso modelo não está muito saudável e, já que seguir a recomendação de Osborne (2008) não nos ajudou, então vamos tentar a outra opção: voltar os dados para a escala em que foram mensurados, ou seja, milissegundos em vez de segundos, bastando apenas multiplicar por ```1000```.

```
mod.log3=lmer(log(tempo*1000)~cond+(1|suj)+(1|itens), data=long)
summary(mod.log3)
```

Esse vamos investigar com carinho.

### Normalidade

Vamos comparar os histogramas do ```mod.misto``` com o ```mod.log3```:

```
par(mfrow=c(2,1))

hist(residuals(mod.misto), prob=TRUE)
lines(density(residuals(mod.misto)))

hist(residuals(mod.log3), prob=TRUE)
lines(density(residuals(mod.log3)))
```
Bem melhor, não?! Agora vamos fazer o mesmo com o ```qqmath```:

```
qqmath(mod.misto, id=0.05)
qqmath(mod.log3, id=0.05)
```

Bem melhor mesmo!!! Agora um teste de normalidade!

```
shapiro.test(residuals(mod.log3))
```

Não temos evidência para descartar a hipótese nula... de que há normalidade! Logo, nossos dados são normais! Podemos prosseguir.

### Homoscedasticidade

Agora vamos para a homogeneidade das variâncias:

```
plot(mod.log3, type=c("p", "smooth"))
```

Dados sem formato de cone, bem mais aleatoriamente distribuídos. Linha não perfeitamente horizontal, mas certamente não inclinada! E para o *Scale-Location Plot*:

```
plot(mod.log3,
  sqrt(abs(resid(.)))~fitted(.),
  type=c("p", "smooth"))
```
Bem maior homogeneidade! Não temos evidência para sustentar hipótese alternativa: dados são homogêneos!

Por fim, o teste de Levene nos indica que não temos evidência para descartar a hipótese nula: dados são, portanto, homogêneos.

```
leveneTest(residuals(mod.log3)~long$cond)
```

Poderíamos passar para a próxima aula daqui, mas ainda não acabamos. Fomos informados pelos pesquisadores que essa tabela ainda tem outras questões. Vamos investigá-las.

# Lidando com valores perdidos
Primeiro, fomos informados que há alguns "missing values" (valores que não puderam ser computados devido a problemas quaisquer (de medição, por exemplo). E que esses valores foram substituídos pela média de cada grupo em cada item. Vamos eliminá-los, portanto, e ver o que conseguimos: Primeiro, vamos excluir todos as observações para o sujeito 14:

```
long=subset(long, long$suj!="14")
```

Veja que agora ```long``` tem 4 linhas a menos: as 4 observações que foram excluídas:

```
nrow(long)
```

Agora, todos os valores que forem iguais a 2.11 e 3.84 não foram de fato medidos, mas acrescentados a fim de rodar a ANOVA (prática comum no campo. Veja Raajimakers, 2003). Vamos substituí-los por NA (o que o R reconhece como *missing values*):

```
require(dplyr)

long$tempo=na_if(long$tempo, 2.11) # substitui 2.11 por NA
long$tempo=na_if(long$tempo, 3.84) # substitui 3.84 por NA
```
Você pode ver com a função ```summary()``` quantos valores retiramos:

```
summary(long$tempo)
```

Agora vamos realizar um modelo misto com intercepto para sujeitos e itens. Mas antes, vamos rever nossas médias com a função ```tapply()```, ou aplicar tabela (```na.rm=T``` indica para remover (```rm```) os ```NA```; o ```T``` é de ```True```):

```
tapply(long$tempo, long$cond, mean, na.rm=T)
```
Observe que elas mudaram um pouco: Agora é 2.08 e 3.40, o que diz que ```sing``` parece aumentar o tempo em 1.32ms, não mais 1.26ms. A diferença se ampliou!

```
3.40-2.08
```

Primeiro, um modelo com os tempos sem transformação:

```
mod.na=lmer(tempo~cond+(1|suj)+(1|itens), data=long)
summary(mod.na)
```

Observe que as estimativas para os fatores fixos se modificaram um pouco. O intercepto foi de 2.02 ms para 2.04 ms (mas não 2.08, como a média que calculamos!). Mas a estimativa do efeito de ```sing``` permaneceu em 1.26 ms (e não 1.32ms!). Observe também, na tabela de ```random effects```, o número de observações:

```
# Number of obs: 120, groups:  suj, 33; itens, 4
```

Saímos de um modelo com 136 observações para um com 120. Retiramos:
- 4 observações do sujeito 14;
- 10 *missing values* (NA's);
- E dois valores 0 que levavam o logaritmo a ```-Inf```.

```
16/136*100
```
Ou seja, retiramos 11,76% das observações totais, o que é bastante coisa. Vamos investigar a normalidade e heteroscedasticidade:

```
qqmath(mod.na, id=0.05) # Não normal!

plot(mod.na, type=c("p", "smooth")) # E heteroscedástico!

plot(mod.na,
  sqrt(abs(resid(.)))~fitted(.),
  type=c("p", "smooth"))
```

Não vamos nem continuar. Vamos logo rodar o mesmo modelo com a transformação logarítmica já multiplicando por ```1000```:

```
mod.log.na=lmer(log(tempo*1000)~cond+(1|suj)+(1|itens), data=long)
summary(mod.log.na) # resultados dos efeitos em log(tempo)
```

E rodar os diagnósticos:

```
qqmath(mod.log.na, id=0.05) # Normal!

plot(mod.log.na, type=c("p", "smooth")) # E homoscedástico!

plot(mod.log.na,
  sqrt(abs(resid(.)))~fitted(.),
  type=c("p", "smooth"))
```

No caso desse experimento, podemos parar por aqui? Esse é (quase) o modelo mais complexo que podemos conseguir com esse experimento. Mas por quê? Esse experimento tinha uma condição com dois níveis (```mult``` e ```sing```). Havia dois grupos de sujeitos, um para ```mult``` e um para ```sing``` (era um desenho *between subjects*):

```
tapply(long$tempo, list(long$suj, long$cond), mean, na.rm=T)
```

Observe: o sujeito que via uma condição não via a outra. Mas, no que diz respeito aos itens, havia apenas um grupo deles para ambas as condições (era um desenho *within itens*, ou seja, as mesmas pranchas com desenhos eram usadas ora com uma figura ora com duas figuras).

```
tapply(long$tempo, list(long$cond, long$itens), mean, na.rm=T)
```

Recomendamos a leitura de Barr et al. (2013), sobretudo a simulação apresentada a partir da página 258. Logo, como itens estão distribuídos entre as condições, precisamos investigar se a condição em que o item se encontra afeta o tempo de cada item particular.

Colocamos intercepto para itens, mas se o tipo de item interagir com a condição? E se um item tiver seu tempo médio (intercepto) acelerado ou reduzido devido ao nível da condição em que se encontra? Até agora só fizemos um tipo de modelo: aquele com intercepto para sujeitos e itens. O ideal seria que tentássemos também um modelo com *slopes* para sujeitos e/ou itens dada cada condição.

```
mod.novo=lmer(log(tempo*1000)~cond+(1|suj)+(1+cond|itens), data=long)
```

Você deve ter obtido a seguinte mensagem de erro:

```
# boundary (singular) fit: see ?isSingular
```

Quando se obtém esse tipo de resposta - *singular fit* (ou ajuste singular) -, normalmente significa que o seu modelo foi sobreajustado, ou seja, que a estrutura de efeitos aleatórios, no nosso caso, é muito complexa para ser descrita pelos dados. Isso não significa que ele não foi ajustado. Você pode vê-lo normalmente com a função ```summary()```.

```
summary(mod.novo)
```

Mas repare bem na tabela de efeitos aleatórios: a variância do slope para cond:sing é próxima de zero (0.00018) e a correlação é perfeita (1.00). *Grosso modo*, o modelo está nos dizendo que esse slope não contribui em nada para a explicar a variabilidade dos dados. Se você quiser saber mais sobre isso, pode pesquisar pela função, que é exatamente o que o código de erro está dizendo para você fazer:

```
?isSingular
```

O que nós faremos aqui, então, é seguir a recomendação de Barr et al (2013), que, aliás, estão citados aí no help dessa função: manter o modelo na máxima estrutura de efeitos aleatórios antes de alcançar um ajuste singular.

Nosso modelo final então é:

```
mod.final=lmer(log(tempo*1000)~cond+(1|suj)+(1|itens), data=long)
```

Não há nada mais que possamos fazer por aqui! Mas ainda precisamos saber como reportar esses dados e como conseguir (se é que precisamos) os p-valores.
