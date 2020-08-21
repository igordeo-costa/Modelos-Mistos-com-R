# Programa do curso

# Aula 0
## Parte 1
- Usando o R como uma calculadora;
- Criando objetos e tipos de objetos;
- Usando a função concatenar para criar vetores.

## Parte 2
- Setar um diretório de trabalho;
- Importar um arquivo .csv;
- Investigar as propriedades de um data.frame;
- Mudar os nomes das colunas em um data.frame;
- Fazer um subset de um data.frame.

## Parte 3:
- Fazer resumos das propriedades estatísticas dos dados em um data.frame;
- Visualizar os dados de um data.frame com um boxplot.


## Ao final das aulas 1 e 2 você deverá ser capaz de:
- entender o que é uma regressão linear e como ela pode te ajudar a entender um modelo misto;
- compreender os motivos pelos quais os modelos mistos têm sido amplamente adotados na psicolinguística em substituição à ANOVA;
- definir a estrutura de efeitos aleatórios de um modelo misto com base no seu design experimental;
- entender o que são interceptos e slopes (fixos e aleatórios);
- aplicar um modelo linear misto aos seus dados;
- ser capaz de ler o output do R no que diz respeito aos modelos mistos mais básicos;
- ser capaz de realizar o diagnóstico dos modelos mistos quanto à normalidade, linearidade e homoscedasticidade;
- saber aplicar uma transformação logarítmica a seus dados;
- saber reportar os resultados de um modelo linear misto.

## Ao final da aula 3 você deverá ser capaz de:
- aplicar um modelo misto a um design que contenha dois fatores fixos;
- compreender o que é uma interação entre fatores;
- entender a lógica por trás dos contrastes básicos dos modelos mistos (*dummy code*);
- saber mudar o fator que é modelado no intercepto de um modelo misto;
- saber o que fazer quando seus dados não se adéquam aos pressupostos dos modelos mistos;
- saber reportar seus resultados de modo adequado.

# Recursos tecnológicos para o curso

1. ter instalado o R, baixando-o [aqui](https://cran.r-project.org/);
2. ter instalado o R Studio, baixando-o [aqui](https://rstudio.com/);
3. ter instalado os pacotes que usaremos no curso. São eles: ```lme4```; ```lattice```; ```dplyr```; ```tidyr```; ```afex```; ```ggplot2```; ```car```. Se você não sabe como instalar um pacote, basta, após os passos 1 e 2, abrir o R Studio e digitar no “Console” o comando ```install.packages(“nome do pacote entre aspas”)```. Após fazer isso, aperte “Enter” e aguarde a instalação. Veja na imagem da página seguinte o exemplo de instalação do pacote *lme4*. Você deve fazer o mesmo para todos os pacotes listados acima.

4. Todos os arquivos que usaremos estão disponíveis neste repositório

# Quanto à organização deste repositório
Na pasta do nosso curso você vai encontrar este arquivo que você agora está lendo (```README.md```) e 5 subpastas. Vamos explicar cada uma delas para você não ficar perdido.

- Nas pastas Aula 0, Aula 1 e 2 e Aula 3: Você terá os arquivos que serão usados no curso. Arquivos do tipo ```.xlsx``` (Excel), ```.csv``` (Excel e R) e ```.R``` (esses são os ```scripts```, arquivos que contêm comandos executáveis pelo R).

- Na pasta exercício: Você terá arquivos ```.csv``` a serem usados no exercício; e dois ```scripts```, incluindo um protocolo de execução de modelos mistos.

- Na pasta leituras: Você terá um conjunto de arquivos ```.doc``` e ```.pdf``` com a apostila do curso e artigos acadêmicos relevantes.

- Sugestões quanto à ordem das leituras: Todo o material de leitura está na pasta do curso. Sugerimos ao leitor que siga as recomendações e ordem abaixo para facilitar o entendimento.

### Apostila:
- Se você não sabe nada de estatística, recomendamos começar do início: estatística descritiva;
- Se você não sabe o que são Erro padrão, Intervalo de Confiança e ANOVA, mas sabe sobre estatística descritiva, recomendados começar por: estatística inferencial;
- Se você já sabe sobre estatística inferencial, mas não sabe a diferença entre efeitos fixos e aleatórios, recomendamos: seções 3.3.1. Fatores fixos e fatores aleatórios; e 3.3.2. Itens como fatores aleatórios.

### Sobre falácia da língua como efeito fixo:
- anexo da dissertação de Costa (2013);
- Raaijmakers (2003);
- Os textos que estão na pasta “Falácia da língua como efeito fixo”.

## Os textos na pasta são:
- Clark (1974) é a obra fundamental que coloca o problema e as soluções clássicas;
- Baayen et. al. (2008) e Jaeger (2008) são os textos que introduzem os modelos mistos na área da psicolinguística;
- Jaeger (2008) trata dos modelos logísticos, sobre os quais não falaremos nesse curso.

3. Outras leituras:
- Sobre diagnósticos: Zuur et. al. (2010);
- Sobre transformação de dados temporais: Baayen & Millin (2010);
- Sobre manter o modelo máximo: Barr et. al. (2013).

# Recomendações quanto à Aula 0
Se você quiser -- e tiver tempo -- recomendamos que faça a Aula 0 em casa, antes de o curso começar. Se você quiser fazer isso (e não sabe nada de R), basta seguir os seguintes passos:

1. Abra o R Studio;
2. Clique na pastinha de abrir scripts, como na imagem abaixo:

{inserir imagem 1}

3. E carregue o arquivo de nome: Aula 0_Parte 1_Revisando o básico.R

{inserir imagem 2}

4. O script vai aparecer assim (ver na página seguinte), na parte de cima da tela:
Observe que as cores no seu provavelmente estarão diferentes. O meu é roxo porque roxo é *legal*.

{inserir imagem 3}

5. Observe que se ele aparecer assim (com problemas nos acentos), como na imagem abaixo, você deve ir em File > Reopen with encodin > UTF-8. Com isso ele irá automaticamente abrir como acima.

{inserir imagem 4}

6. Agora que você carregou o seu script, você pode ir seguindo as instruções nele.
Tudo que estiver precedido por # é código não executável (é apenas instrução para você);
Tudo que não estiver precedido de # é código executável (é um comando para o R fazer algo).
Para executar um código, você tem três opções: (i) clicar na linha em que ele está; (ii) selecioná-lo e então clicar em Run, como na imagem; ou (iii):

{inserir imagem 5}

Na imagem acima, como o cursor estava sobre a linha 8, ao clicar em Run, foi executado no Console (lá embaixo) a subtração de 5-2, nos dando o resultado 3. Tudo que está depois de # não é executado (foi apenas impresso na tela).

Um modo mais fácil de executar um comando é, em vez de clicar em Run, apertar simultaneamente, no teclado em ctrl + Enter (Windows) ou command + Enter (Mac). Mas lembre-se que você tem de ter clicado antes sobre a linha que deseja executar.

Espero que você se divirta com esse trabalho tanto quanto eu me diverti fazendo-o para você.
