# Investigando tabelas de dados

## Sumarizando dados do seu data frame

Vamos continuar trabalhando com o objeto ```x```, ou seja, com a tabela ```Populações Fictícias.csv```. Se não estiver carregada, carregue-a! Agora vamos investigar esses dados com a função ```summary()```. Vamos começar investigando a ```popA```:

```
summary(x$popA)
```

Lembre-se: data frame ```x```, coluna ```popA``` é o mesmo que: ```x$popA```.

Que informações são essas? Se olharmos com calma, elas são (quase) auto-explicativas:

- ```Min``` e ```Max``` são o menor e o maior valor da ```popA```;
- ```Mean``` é a média aritmética da ```popA```, ou seja, todos os valores de ```popA``` somados e divididos pelo número total de observações (no caso, 10 mil). Podemos conferir isso usando as funções:

```
min(x$popA)
max(x$popA)
mean(x$popA)
```

Agora que você já entendeu tudo isso, você pode começar a valorizar mais a função ```summary()```. Ela te dá os mais relevantes desses resultados de uma vez só e de modo muito rápido. Mas só fizemos ```summary()``` para a ```popA```. Façamos também para ```popB```:

```
summary(x$popB)
```

Ou você pode aplicar a função ```summary()``` a todo o data frame:

```
summary(x)
```

Agora compare as populações A e B. Vamos supor que os dados sejam de Tempos de Reação à leitura de certas palavras.
- Qual delas lê mais rápido? Por quê?
- Qual delas tem tempos de leitura mais consistentes? Por quê?

Você também pode visualizar os dados dos quartis e quantis com um *boxplot* (gráfico de caixas):

```
boxplot(x$popA, x$popB)
```
O seu gráfico deve ter aparecido em uma janela própria para eles, chamada de ```plots```. Se você não a estiver vendo, basta selecioná-la no painel que contém as abas ```Files```, ```Plots```, ```Packages```, etc.

Perceba como esse tipo de gráfico faz um resumo muito conciso e de apreensão imediata dos dados. Fique atento para o fato de que a função ```boxplot()``` pode ser aplicada, ainda, de outro modo. Vamos ver esse modo.

Usemos a função ```sample()``` para fazer duas amostras aleatórias:

```
a.popA=sample(x$popA, 15) # amostrar aleatoriamente 15 indivíduos de popA
a.popB=sample(x$popB, 15) # o mesmo para popB.
```

Agora vamos juntar em um único vetor ```a.popA``` e ```a.popB``` usando a função concatenar ```c()```:

```
am=c(a.popA, a.popB)
```

Agora vamos criar um vetor (função concatenar) que contenha a letra "A" repetida 15 vezes e a letra "B" repetida 15 vezes. Vamos usar a função ```rep()```. Faça primeiro assim:

```
rep("A", 15)
rep("B", 15)
```

Viu o que essa função faz? Agora o que fizemos abaixo faz mais sentido para você, não?

```
pop=c(rep("A", 15), rep("B", 15))
```

Agora vamos juntar em um data frame o vetor ```pop``` e o vetor ```am```:

```
dados=data.frame(pop, am)
```

Agora vamos ver o que o R fez:

dados

No data frame original (```x```), população A e B estavam em colunas diferentes, daí fizemos o *boxplot* assim:

```
boxplot(x$popA, x$popB)
```

Agora as populações A e B estão na mesma coluna e as medidas em outra coluna. Daqui a pouco vamos ver um jeito muito mais fácil de fazer isso, usando o pacote ```tidyr```. Tente plotar um *boxplot* desse modo e veja o que ocorre:

```
boxplot(dados$pop, dados$am)
```

Ele plotou 2 *boxplots*, mas um está "zerado". O jeito correto de plotar o *boxplot* para esse data frame seria:

```
boxplot(dados$am~dados$pop)
```

Avisar à função *boxplot* que você deseja plotar a coluna ```am``` (```$am```) em função da (```~```) coluna ```pop``` (```$pop```). Ou, se você não gosta do símbolo ```$```, assim:

```
boxplot(am~pop, data=dados)
```

Leia-se: plotar um boxplot de ```am``` em função de ```pop```, colunas do ```data.frame``` de nome ```dados```.
