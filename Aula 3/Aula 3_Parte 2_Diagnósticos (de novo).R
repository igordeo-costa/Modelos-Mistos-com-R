# Diagnósticos do modelo: lidando com correlação!

# Agora você já sabe como fazer.

# Veja os outliers potenciais com:

boxplot(rt~ant+verbo, p7)

dotchart(p7$rt)

# Veja normalidade com:

# (i) histograma dos resíduos:

hist(residuals(mod.int), prob=T)
lines(density(residuals(mod.int)))

# (ii) qqplots

require(lattice)

qqmath(mod.int, id=0.05)

# (iii) um teste de normalidade:

shapiro.test(residuals(mod.int)) #hipótese nula = população normalmente distribuída!

# Veja também a heteroscedasticidade com:

# (i) um boxplot dos resíduos em cada condição

boxplot(residuals(mod.int)~p7$ant+p7$verbo)

# (ii) um gráfico de resíduos x ajustados (residuals x fitted):

plot(mod.int, type=c("p", "smooth"))

# (iii) um scale-location plot:

plot(mod.int, sqrt(abs(resid(.)))~fitted(.), type=c("p", "smooth"))

#----------------------------------------------------------------------------------------
# Vamos a uma transformação logaritmica então:

mod.int=lmer(log(rt)~ant*verbo+(1|suj)+(1|itens), data=p7)

# Refaça os testes e gráficos de diagnóstico!

# Veja os outliers potenciais com:

boxplot(log(rt)~ant+verbo, p7)

dotchart(log(p7$rt))

# Veja normalidade com:

# (i) histograma dos resíduos:

hist(residuals(mod.int), prob=T)
lines(density(residuals(mod.int)))

# (ii) qqplots

require(lattice)

qqmath(mod.int, id=0.05)

# (iii) um teste de normalidade:

shapiro.test(residuals(mod.int)) #hipótese nula = população normalmente distribuída!

# Veja também a heteroscedasticidade com:

# (i) um boxplot dos resíduos em cada condição

boxplot(residuals(mod.int)~p7$ant+p7$verbo)

# (ii) um gráfico de resíduos x ajustados (residuals x fitted):

plot(mod.int, type=c("p", "smooth"))

# (iii) um scale-location plot:

plot(mod.int, sqrt(abs(resid(.)))~fitted(.), type=c("p", "smooth"))

#----------------------------------------------------------------------------------------

# Melhorou? Resolveu todos os problemas?

# Um caminho talvez seja retirar alguns valores extremos dos dados:

dotchart(p7$rt)

# Observe que há alguns valores acima de 2000 ms que podem ter influenciado os dados:
# Vamos retirá-los:

corte=subset(p7, p7$rt<=2000)

# Veja que retiramos apenas 13 observações (2.5% do total de dados):

nrow(p7)-nrow(corte)

(13/512)*100

# Investigue por outliers com o Cleveland dotplot:

dotchart(corte$rt)

dotchart(log(corte$rt))

# Refaça o modelo com a transformação:
  
mod.int=lmer(log(rt)~ant*verbo+(1|suj)+(1|itens), data=corte)

# E refaça os diagnósticos!
# Agora é por sua conta!
# Observe que estamos (propositalmente, para fins pedagógicos) trabalhando
# com uma tabela diferente "corte" e não mais com "p7".

# Agora voê tem que tomar uma decisão!
# A heteroscedasticidade foi resolvida, mas a normalidade não totalmente.
# Você pode:
# (i) buscar outra transformação que não a logaritmica, por exemplo, a gamma
# ou a inversa da normal (Wald Distribution) (ver Baayen & Milin, 2010);
# (ii) assumir que a regressão é robusta contra violação de normalidade e prosseguir;
# (iii) excluir ainda mais dados que possam estar "puxando" a cauda para a direita;
# (iv) buscar um outro modelo que não assuma normalidade dos dados.
