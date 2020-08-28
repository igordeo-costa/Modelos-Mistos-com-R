# Investigando os efeitos aleatórios
Até agora, trabalhamos com um modelo cuja estrutura de efeitos aleatórios era:

```
# (1|suj)+(1|itens)
```

Ou seja, ```intercepto``` para sujeitos e para itens. O que estamos investigando com isso? Estamos dizendo que o modelo calculou a média de cada sujeito e a média de cada item e as considerou na análise.

{inserir gráfico aqui!}

Mas vamos investigar nosso design experimental e averiguar se isso é o bastante. Primeiro, a estrutura dos sujeitos:

Vamos fazer um ```subset``` com um sujeito aleatório do nossa tabela p7, digamos o sujeito 13:

```
suj13=subset(p7, p7$suj==13)
suj13
nrow(suj13)
```

Para esse sujeito, temos 16 observações, 4 para cada condição. Isso significa que o mesmo sujeito estava exposto a todos os níveis de cada fator. Observe, então, que a média global desse sujeito...

```
mean(suj13$rt)
```

...não é suficiente para descrever a sua variabilidade, visto que ele pode ser mais lento em uma condição e mais rápido em outra:

```
tapply(suj13$rt, list(suj13$ant, suj13$verbo), mean)
```

Observe que isso é bem verdade. Em média, esse sujeito tem um tempo de reação de 1367.6ms, mas esse valor parece ter sido "puxado" pela condição ```pp.pl``` (1772.5). Isso significa que teríamos que considerar não apenas um intercepto para os sujeitos, mas também um *slope* (uma inclinação) para cada um dos fatores do nosso experimento.

```
require(lattice)
qqmath(~rt|suj, data=p7)
```

Em segundo lugar, vamos olhar para os itens: Vamos fazer um ```subset```, digamos, do item D:

```
itemD=subset(p7, p7$itens=="D")
itemD
nrow(itemD)
```

Observe que temos 32 observações para o item D, uma para cada sujeito. Repare, também, que o item D aplicava-se apenas a um tipo de antecedente (np) e a um tipo de verbo (pl).

Observe que, no caso dos itens desse experimento, não faz sentido dizer que há tempos diferentes para cada item em cada condição, porque um item só pode aparecer em uma condição. Logo, não são necessários *slopes* para itens nesse modelo.

```
qqmath(~rt|itens, data=p7)
```

Mas lembre-se que um certo item pode ser lido mais rapidamente ou mais lentamente do que outro. Logo, o intercepto para os itens ainda faz sentido.

```
tapply(p7$rt, p7$itens, mean)
```

Apenas para fins didáticos, vamos começar mexendo na estrutura dos itens. Vamos ajustar um modelo com intercepto para itens e slopes com interação entre ant e verbo para itens:
```
mod.itens=lmer(log(rt)~ant*verbo+(1|suj)+(1+ant*verbo|itens), data=corte)
```

Você provavelmente recebeu essa informação:

```
# boundary (singular) fit: see ?isSingular
```

Nós já falamos antes sobre essa mensagem, que indica que o seu modelo foi sobreajustado quanto à estrutura de efeitos aleatórios. Isso não significa que ele não foi feito. Se você quiser, pode vê-lo:
```
summary(mod.itens)
```

Observe que, agora, nós temos uma tabela de correlação junta aos efeitos aleatórios. O que fazer nesse momento? Ficar com esse modelo? Fazer outro? Vamos investigar a função isSingular():
```
?isSingular
```

Você não precisa entender o que está aí em detalhes, mas há uma parte em "details" que diz assim:
```
# "There is not yet consensus about how to deal with singularity..."
```

E várias opções sobre o que fazer. Vamos seguir o terceiro item da lista:
- "Keep it maximal" (o texto citado aí está na pasta do curso e já foi recomendado aqui).

Ou seja, vamos tentar a mais complexa estrutura dos efeitos aleatórios que conseguirmos. Com a interação vimos que não dá. E sem ela?

```
mod.itens=lmer(log(rt)~ant*verbo+(1|suj)+(1+ant+verbo|itens), data=corte)
```

Também não. E com slopes só para ant?
```
mod.itens=lmer(log(rt)~ant*verbo+(1|suj)+(1+ant|itens), data=corte)
```
Também não. E com slopes para verbo?
```
mod.itens=lmer(log(rt)~ant*verbo+(1|suj)+(1+verbo|itens), data=corte)
```
Também não!

Então descobrimos algo (que já sabíamos, na verdade, porque nosso design
nos dizia isso): devemos ter apenas intercepto para itens:
```
mod.itens=lmer(log(rt)~ant*verbo+(1|suj)+(1|itens), data=corte)
```

Agora vamos fazer a mesma coisa para os sujeitos. Primeiro, com interação:
```
mod.suj=lmer(log(rt)~ant*verbo+(1+ant*verbo|suj)+(1|itens), data=corte)
```
Não funcionou! Então, sem interação:
```
mod.suj=lmer(log(rt)~ant*verbo+(1+ant+verbo|suj)+(1|itens), data=corte)
```
Também não funcionou! Com slopes para ant:
```
mod.suj=lmer(log(rt)~ant*verbo+(1+ant|suj)+(1|itens), data=corte)
```
Também não! Com slopes para verbo:
```
mod.suj=lmer(log(rt)~ant*verbo+(1+verbo|suj)+(1|itens), data=corte)
```
Também não. Logo, a estrutura máxima de efeitos aleatórios que conseguimos ajustar foi com interceptos para sujeitos e itens. Podemos, então, ficar com esse modelo final:
```
mod.final=lmer(log(rt)~ant*verbo+(1|suj)+(1|itens), data=corte)
```
Se quisermos reportar o p-valor, temos que instalar o pacote "afex":
```
install.packages("afex")
require(afex)
```
E rodar mais uma vez o modelo:
```
mod.final=lmer(log(rt)~ant*verbo+(1|suj)+(1|itens), data=corte)
summary(mod.final)
```

Observe que temos um efeito significativo da interação, que você já sabe o que significa. Lembre-se do ```interaction.plot()```:
```
interaction.plot(corte$ant, corte$verbo, corte$rt, mean)
```

Apenas um comentário: plot agora a interação com log(rt) em vez de rt:
```
interaction.plot(corte$ant, corte$verbo, log(corte$rt), mean)
```
Pense um pouco sobre isso! Vamos plotar também nossa tabela de médias para os dados finais:
```
tapply(corte$rt, list(corte$ant, corte$verbo), mean)
```

E reportar nossos achados:

>Ajustou-se um modelo linear de efeitos mistos, com tipo de antecedente e número do verbo como efeitos fixos; intercepto para sujeitos e itens como efeitos aleatórios (a máxima estrutura de efeitos aleatórios antes de o modelo alcançar singularidade - Barr et. al, 2013). Apenas a interação pp x sg mostrou-se significativa (pp x sg=-0.24 logRTs, t=-3.213, p=0.007). P-valor obtido com o pacote "afex". O modelo mostrou que, na condição np.sg os tempos de reação são muito mais lentos (791.95 ms) do que quando na condição pp.sg (609.56 ms), uma diferença de 172.39 ms.

Se quiser, para acompanhar seus dados, você pode acrescentar um gráfico com a interação (que seja digno de se publicar):
```
require(dplyr)
require(ggplot2)
```
E criar um gráfico bonitinho:

```
corte%>%
  ggplot() +
  aes(x = ant, y = rt, color = verbo, group = verbo) +
  stat_summary(fun.y = mean, geom = "point") +
  stat_summary(fun.y = mean, geom = "line") +
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar",
               fun.args = list(mult = 1), width=0.05)+
  theme_classic()+
  xlab("Tipo de Antecedente") +
  ylab("Tempos de reação (ms)") +
  ggtitle("Efeito significativo de interação",
          subtitle = "entre tipo de antecedente e número do verbo")
```
Que você pode salvar em formato .png:
```
ggsave("Meu gráfico bonitinho.png")
```
Agora que você tem um resultado, precisa explicar isso em termos teóricos. O que esse resultado significa para o fenômeno que você está estudando?
