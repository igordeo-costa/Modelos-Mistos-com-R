# Reportando seu modelo

Como você deve ter percebido, os modelos mistos não apresentam um p-valor. O motivo se deve ao fato de que é complicado, para esses modelos, calcular os graus de liberdade. Há uma intensa discussão nos meios acadêmicos sobre isso. Então, como fazer?

## Primeira opção: Comparação de modelos
Como você provavelmente já sabe, quando uma ANOVA nos dá um valor significativo, ela está comparando dois modelos: um modelo nulo (*null model*; sem os tratamentos) e um modelo cheio (*full model*; com os tratamentos) e daí dizendo se os tratamentos ajudam a explicar melhor a variabilidade dos dados (veja a apostila do curso para uma explicação mais detalhada).

Para os modelos mistos, podemos fazer a mesma coisa: ajustamos um modelo que considera os tratamentos (o ```mod.final``` com que encerramos a última aula) e agora vamos ajustar um modelo sem considerar os tratamentos e ver se incluir os tratamentos ajudou a descrever/explicar melhor os dados.

Primeiro, crie os modelos (ver [Godoy, seção 3.2, nota 4 sobre o porquê de usar método REML](https://mahayana.me/mlm/#fnref4)).

```
mod.final=lmer(log(tempo*1000)~cond+(1|suj)+(1|itens), data=long, REML=FALSE)
mod.nulo=lmer(log(tempo*1000)~1+(1|suj)+(1|itens), data=long, REML=FALSE)
```
Depois, faça uma comparação com a função ```anova()```:

```
anova(mod.nulo, mod.final)
```
Perceba que, nesse caso, nós não podemos nos dar ao luxo de fazer uma comparação, já que o modelo nulo não convergiu. Se quiser saber mais sobre esse tipo de análise, veja a referência acima.

## Segunda opção: Estatística t
A distribuiçao de t, quando tem altos graus de liberdade, se aproxima de uma distribuição z. Logo, num modelo misto, se o t-valor estimado pelo modelo for maior do que 1.96, isso significa que o p-valor seria menor do que 0.05.

Na verdade, com graus de liberdade infinitos, os valores são (Valores retirados de Bussab & Morettin, 2012: 513):

```
valor.de.t=c(1.960, 2.054, 2.326, 2.576, 3.090, 3.291)
p.valor=c(0.05, 0.04, 0.02, 0.01, 0.002, 0.001)
p.valores=data.frame(valor.de.t, p.valor)

p.valores
```
Se você não confia nesses dados, pode pedir para o R calcular para você:

```
qt(c(.025, .975), df=250) # Aqui com 250 graus de liberdade e 0.05 de confiança
```

O sumário do nosso modelo final diz que o nosso t-valor está em 3.046, o que é equivalente a um p-valor de 0.01. Como reportar? Recomenda-se algo nessa linha:
```
summary(mod.final)
```

>*Aplicou-se aos dados um modelo linear de efeitos mistos, com logaritmo do tempo para a primeira fixação como variável resposta, condição (multiple e single) como efeitos fixos e intercepto para sujeitos e itens como efeitos aleatórios (a máxima estrutura de efeitos aleatórios antes de alcançar um ajuste singular -- Barr et al., 2013). Resultados indicam que a condição single aumenta o tempo em 1.26ms em relação à condição multiple: single=0.448log(ms); t(inf.)=3.046, p<0.01.*

## Terceira opção: intervalo de confiança
Não vamos discutir aqui o que é e como interpretar um intervalo de confiança, mas esse é talvez um dos melhores modos de reportar os dados do seu modelo, e tem se tornado cada vez mais recorrente na literatura da área, inclusive porque evita uma série de questões espinhosas sobre o que significa o p-valor.

Para calcular um intervalo de confiança para seus dados, use a função ```confint()```:

```
confint(mod.final)
```

>Observe que a função deu

>Como reportar: (cond: single = 0.4486 log(ms); IC 95%, 0.29-1.18)

>Como interpretar: Existe 95% de probabilidade de o intervalo que vai de 0.59 a 1.93ms ser um dos intervalos que contenham a média populacional. Se repetirmos o experimento infinitas vezes, 95% do tempo a média estará nesse range. Logo, como a nossa amostra está dentro desse intervalo (1.26ms)...

Caso você peça ajuda para função ```confint()```, verá que existe o argumento ```level```, que define o valor do intervalo desejado (o padrão é 0.95):

```
?confint
```

Vamos tentar com 0.99:

confint(mod.final, level=0.99)

# Nesse caso: (cond: sg = 1.26 ms; IC 95%, 0.36-2.1)
# Observe que tendo mais certeza do meu intervalo (99% deles estão nesse range),
# torna-se menos precisa minha estimativa.

# Vamos analisar o nosso modelo final:

confint(mod.final)

> "Aplicou-se aos dados um modelo linear de efeitos mistos, com logaritmo do tempo para a primeira fixação como variável resposta, condição (multiple e single) como efeitos fixos e intercepto para sujeitos e itens como efeitos aleatórios (a máxima estrutura de efeitos aleatórios antes de alcançar um ajuste singular -- Barr et al., 2013). Resultados indicam que a condição single aumenta o tempo em 1.26ms em relação à condição multiple: single=0.45log(ms); IC 95%, 0.15-0.74."

Uma recomendação importante: Se seu modelo tem *random slopes* (o que não é o nosso caso), então você precisará passar pela função ```confint()``` o argumento ```method="Wald"```:

```
confint(mod.misto, method="Wald")
```

# Quarta opção: calculando p-valor
Se o seu parecerista pedir de fato um p-valor, então você pode tentar achá-lo. Primeiro: ninguém recomenda buscar p-valor com modelos mistos. Os métodos não são precisos, não há modo adequado de calcular os graus de liberdade e há uma séria discussão na literatura a respeito do tema. Justamente por isso, os métodos para calcular o p-valor acabam mudando muito no R.

Até pouco tempo, o pacote ```LanguageR``` tinha a função ```pvals.fnc()```, que não mais funciona (ela foi usado, por exemplo, em [Costa, 2013](ref)). O pacote ```lmerTest``` também tem funções para tal. O método mais prático, porém, é instalar o pacote ```afex```:

```
install.packages("afex")
require(afex)
```

Com esse pacote instalado (não precisa sequer estar carregado), sempre que você rodar um modelo misto, ele já vai te dar um p-valor.

```
mod.final=lmer(log(tempo*1000)~cond+(1|suj)+(1|itens), data=long)
summary(mod.final)
```

Nesse caso, o nosso p-valor é de 0.004. Como reportar sua análise?

> *Aplicou-se aos dados um modelo linear de efeitos mistos, com logaritmo do tempo para a primeira fixação como variável resposta, condição (multiple e single) como efeitos fixos e intercepto para sujeitos e itens como efeitos aleatórios (a máxima estrutura de efeitos aleatórios antes de alcançar um ajuste singular -- Barr et al., 2013). Resultados indicam que a condição single aumenta o tempo em 1.26ms em relação à condição multiple: single=0.4486log(ms), t(inf)=3.046, p=0.004.*

Como há um debate sobre p-valores em modelos mistos, recomendamos sempre informar como os p-valores foram obtidos. Isso pode ser feito ou em nota de rodapé ao experimento, ou na apresentação inicial do mesmo:

> *Os p-valores apresentados nesse trabalho foram obtidos com o uso do pacote 'afex'.*

Se você quiser se livrar do p-valor (algo que recomendamos fortemente), pode desinstalar o pacote ```afex```:

```
remove.packages("afex")
```
