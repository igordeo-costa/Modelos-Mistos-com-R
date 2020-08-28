# Manipulando tabelas de dados

## Importando arquivos ```.csv``` para o R

### O que é um arquivo .csv?
O R permite a importação de planilhas direto do excel, mas essa é uma funcionalidade pouco usada. Por isso, não falaremos dela aqui. O melhor caminho para importar dados para o R é, ANTES de importá-los, convertê-los para formato ```.csv```(*comma separated values*). Basicamente, um arquivo ```.csv``` é uma planilha, mas em formato de texto, o que a deixa muito leve (mas praticamente impossível de ler a olho nu). Por isso, é preciso um programa (como o R), para ler os dados.

### Setando um diretório de trabalho

Importando uma planilha em formato .csv para o R:
A função ```read.csv()``` permite que se coloque um "caminho" e se busque um arquivo em uma pasta.

IMPORTANTE: Por padrão, o R tem um diretório de trabalho onde as pastas devem ser colocadas para serem acessadas. Para saber seu diretório de trabalho, use a função:

```
getwd()
```

No meu caso, esse é o diretório:

```
[1] "C:/Users/Igor/Documents
```
Os documentos (planilhas, por exemplo) que você usar têm de estar salvos dentro desse diretório. Na verdade, eles não têm de fato que estar lá, mas, se estiverem, isso facilitará a sua vida. Agora que você sabe onde seus dados estão, você pode importá-los com a função:
```
read.csv()
```
Não se esqueça de atribuir um "nome" para seu objeto, no caso ```x```:

```
x=read.csv2("C:/Users/Igor/Documents/minha_tabela.csv")
```

O objeto ```x``` recebe o arquivo chamado ```minha_tabela.csv```. Perceba que ```minha_tabela.csv``` é o nome do arquivo na pasta ```Documents```. No seu computador será diferente, por isso, o comando acima não funcionou para você. Mas não se desespere. Pule esse parte e venha aqui para baixo. Vou te mostrar um jeito mais fácil se você acha difícil de buscar as coisas por meio de caminhos escritos.

Primeiro, vamos "setar" um novo diretório de trabalho. Minimize o R, vá até uma pasta de sua escolha (no meu caso: ```Igor>Documents```) e crie uma nova pasta.
Dê o nome de ```Curso de R``` para essa nova pasta. Em seguida, use o seguinte código, definindo o caminho até sua pasta:

```
setwd("C:/Users/Igor/Documents/Curso de R")
```
Confira se de fato foi setado com ```getwd()```.

Você pode fazer isso manualmente também:

No painel à direita, abaixo, clique em ```Files```. Ache sua "Área de trabalho" ou "Mesa" aí ou a pasta que quiser. Se você não achou, vá nos 3 pontinhos ```...``` bem à direita e clique ali. Daí clique na sua área de trabalho ou pasta escolhida. Terceiro, marque a pasta que acabamos de criar ```Curso de R```. Vá em ```More``` (a engrenagem azul) e clique em ```Set as working directory```. (Parece que a linha de comando é mais fácil, não é?)

A partir de agora, tudo o que você fizer no R estará vinculado a essa pasta (enquanto você não fechá-lo). Sempre que abrir o R você deverá setar seu diretório de trabalho novamente. Baixe a pasta do curso do diretório do ```github``` e coloque dentro dessa pasta. Agora vamos começar a trabalhar no que realmente interessa.

## Importando dados ```.csv```:
Vamos importar os dados incorporando à função ```read.csv()``` a função ```file.choose()```:


```
x=read.csv(file.choose())
```

Nesse caso, a função ```file.choose()``` abre uma janela para que você busque o arquivo no diretório adequado. Vamos carregar o arquivo chamado ```Populações Fictícias.csv``` e investigar suas propriedades. Esse arquivo está dentro da pasta Aula 0.

```
x=read.csv(file.choose())
```
- Mostrar as 6 primeiras linhas do objeto ```x```:

```
head(x)
```

- Mostrar as 20 primeiras linhas do objeto ```x```:

```
head(x, 20)
```

- Mostrar as 6 últimas linhas do objeto ```x```:

```
tail(x)
```

- Mostrar as 15 últimas linhas do objeto ```x```:

```
tail(x, 15)
```

- Dizer o número total de linhas do objeto ```x```:

```
nrow(x)
```

- Dizer o número de colunas do objeto ```x```:

```
ncol(x)
```

- Visualizando a "estrutura" dos seus dados:

```
str(x)
```

Interpretando os resultados de ```str()```:
- Objeto é um ```data.frame```: o R tem outro objetos, como já vimos.
- Esse data frame tem dez mil observações (10 mil linhas) e 3 variáveis (3 colunas).
- As variáveis ou colunas (precedidas do símbolo ```$```) têm o seguinte nome: ```X```, ```popA``` e ```popB```.
- A variável ```X``` é do tipo ```int``` (```integer```, ou seja, números inteiros);
- As variáveis ```popA``` e ```popB``` são do tipo ```num``` (```numeric```, ou seja, números inteiros ou não).

OBS: Como já visto anteriormente, o R trabalha com diversos tipos de variáveis:
```
character
numeric
integer
logical
complex
```
Além de outras.

### Manipulando bem pouquinho seu data frame:

Observe que o objeto ```x``` tem 3 colunas (reimprima sua "cabeça" na tela). A primeira coluna se chama ```X```. Vamos usar a função ```colnames()``` para mudar isso. Com essa função, você pode mudar manualmente os nomes das colunas. Mude os nomes para ```indivíduos```, ```A``` e ```B```, respectivamente.

```
colnames(x)=c("indivíduos", "A", "B")
```

Veja a cabeça da sua tabela:

```
head(x)
```

Vamos mudar mais uma vez os nomes das colunas, voltando ao que estava antes:

```
colnames(x)=c("X", "popA", "popB")
```

Agora vamos buscar fazer uma outra manipulação nos dados. Imagine que eu queira saber quantos indivíduos na ```popA``` tem valores acima de ```200```. Vamos usar a função ```subset()``` para isso:

```
maior.200=subset(x, x$popA>200)
```

Como funciona a função ```subset()```:
- ```x```: data frame de onde ela está "pegando" os dados;
- ```x$popA```: no data frame ```x```, pegue a coluna de nome ```popA``` (lembre-se da função ```str()```, que marcava cada coluna com o símbolo ```$```). Assim, se queremos acessar apenas uma coluna de um data.frame, podemos colocar o ```nome.do.data.frame$nome.da.coluna```;
- ```>```: é o sinal de maior que;
- ```200```: é o valor

Vamos tentar outros:

```
maior.ou.igual.200=subset(x, x$popA>=200)
menor.ou.igual.200=subset(x, x$popA<=200)
diferente.de=subset(x, x$popA!=200) # != é o mesmo que "diferente de"
igual.a=subset(x, x$popA==200) # == é o mesmo que "igual a"
```
Existem métodos mais práticos de fazer *subsets*, usando outros pacotes do R, mas por enquanto vamos ficar por aqui.
