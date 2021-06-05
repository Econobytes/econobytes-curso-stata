*******************************************************
***      Curso de Stata (aula 2) - Econobytes       ***
***        Professora Raquel Pereira Pontes         ***
*******************************************************

***abrir log -> File -> Log -> Begin ou comando "log using"

log using "D:\Mega20-21\Econobytes\Curso Stata\Covid_19Brasil\resultados29-05.smcl>"

***Abrir dados da PNAD COVID (que já esá salvo na pasta Mestre)

*vai em File -> open ou use o comando "use"

use "D:\Mega20-21\Econobytes\Curso Stata\Covid_19Brasil\Mestre\pnad_covid_STATA\PNAD_COVID_112020.dta", clear

**arrumando algumas variáveis novamente
***renomear variável
*escolaridade
rename a005 escolaridade

*home office
rename c013 home_office 
label define home_office 1 "sim" 2 "nao"
label values home_office home_office
tab home_office

*Sexo
rename a003 sexo
label define sexo 1 "homem" 2 "mulher"
label values sexo sexo
tab sexo

*cor_raca
rename a004 cor_raca
label define cor_raca 1 "branca" 2 "preta" 3 "amarela" 4 "parda" 5 "indígena" 9 "ignorado"
label values cor_raca cor_raca
tab cor_raca

*Análise com tabelas

tab home_office sexo 

tab home_office cor_raca

*Revendo alguma análises com gráficos

graph bar (count) if cor_raca == 1 | cor_raca == 2 | cor_raca == 4, over(home_office) over(cor_raca) over(sexo) title("Pessoas em home office, por cor/raça e sexo no Brasil - Nov/2020", size(medsmall))

*somente no RS

graph bar (count) if (cor_raca == 1 | cor_raca == 2 | cor_raca == 4) & (uf==43), over(home_office) over(cor_raca) over(sexo) title("Pessoas em home office, por cor/raça e sexo no RS - Nov/2020", size(medsmall))

*vamos arrumar outra variável para analisar

*escolaridade - já está renomeada, agora só falta dar nome para os valores

label define escolaridade 1 "sem instrução" 2 "fund. incompl." 3 "fund. compl." 4 "médio incomp." 5 "médio compl." 6 "sup. incompl." 7 "sup. compl." 8 "pós graduação"
label values escolaridade escolaridade
tab escolaridade

*análise com tabela

tab home_office escolaridade

graph bar (count) [pweight = v1032] if cor_raca == 1 | cor_raca == 2 | cor_raca == 4, over(home_office) over(cor_raca) over(escolaridade) title("Pessoas em home office, por cor/raça e escolaridade no Brasil - Nov/2020", size(medsmall))

gen escolaridade_grupo = escolaridade
recode escolaridade_grupo(1/2=1)(3/4=2)(5/6=3)(7/8=4)
tab escolaridade_grupo
label define escolaridade_grupo 1 "sem instr. e fund. incompl." 2 "fund. compl. e médio incomp." 3 "médio compl. e sup. incompl." 4 "sup. compl. e pós graduação"
label values escolaridade_grupo escolaridade_grupo
tab escolaridade_grupo

*análise com gráfico
*no brasil
graph bar (count) [pweight = v1032] if cor_raca == 1 | cor_raca == 2 | cor_raca == 4, over(home_office) over(cor_raca) over(escolaridade_grupo, label(labsize(vsmall))) title("Pessoas em home office, por cor/raça e escolaridade no Brasil - Nov/2020", size(medsmall))

*no RS
graph bar (count) [pweight = v1032] if (cor_raca == 1 | cor_raca == 2 | cor_raca == 4) & (uf==43), over(home_office) over(cor_raca) over(escolaridade_grupo, label(labsize(vsmall))) title("Pessoas em home office, por cor/raça e escolaridade RS - Nov/2020", size(medsmall))

*outras análises que podem ser feitas
* Por tipo de trabalho

rename c007 tipo_emprego 
label define tipo_emprego 1 "trabalhador doméstico" 2 "militar" 3 "policial ou bombeiro" 4 "empregado do setor privado" 5 "empregado do setor público" 6 "empregador" 7 "conta prória" 8 "trabalhador familiar não remunerado" 9 "produção para consumo próprio"
label values tipo_emprego tipo_emprego
tab tipo_emprego

*análise com gráfico
graph bar (count), over(home_office) over(tipo_emprego, label(angle(forty_five) labsize(small))) title("Pessoas em home office, por tipo de ocupação no Brasil - Nov/2020", size(medsmall))

*Auxilío Emergencial

rename d0051 auxilio_emergencial
label define auxilio_emergencial 1 "sim" 2 "não" 
label values auxilio_emergencial auxilio_emergencial
tab auxilio_emergencial

*análise por tabela
tab auxilio_emergencial cor_raca
tab auxilio_emergencial sexo

*análise gráfica

graph bar (count) if cor_raca == 1 | cor_raca == 2 | cor_raca == 4, over(auxilio_emergencial) over(cor_raca, label(labsize(small))) over(sexo, label(labsize(small))) title("Pessoas que receberam auxílio emergencial, por cor/raça e sexo no Brasil - Nov/2020", size(medsmall))

*outra análise: pessoas que receberam auxílio emergencial por renda (desafio)
*arrumar variável renda (C01012)
*resumo da variável renda
sum c01012
*Ordenar variável renda
sort c01012
*abrir editor para ver as informações dessa variável
edit c01012

*vamos criar uma nova variável de renda por salários mínimos
gen renda = .
edit renda

replace renda = 1 if c01012 <= 1045
replace renda = 2 if c01012 > 1045 & c01012 <= 2090
replace renda = 3 if c01012 > 2090 & c01012 <= 3135
replace renda = 4 if c01012 > 3135 & c01012 <= 4180
replace renda = 5 if c01012 > 4180 & c01012 <= 5225
replace renda = 6 if c01012 > 5225 & c01012 != .

label define renda 1 "menos de um salário mínimo" 2 "entre 1 e 2" 3 "entre 2 e 3" 4 "entre 3 e 4" 5 "entre 4 e 5" 6 "mais de 5" 
label values renda renda

tab renda
edit renda c01012 auxilio_emergencial

tab auxilio_emergencial renda

graph bar (count), over(auxilio_emergencial) over(renda, label(angle(forty_five) labsize(small))) title("Pessoas que receberam auxílio emergencial por renda no Brasil - Nov/2020", size(medsmall))

**********************************************
***********Modelos econométricos**************
**********************************************

* Modelo Básico de regressão linear (Regressão amostral)
* para PNAD - amostra complexa - precisa usar svy - não vamos entrar em detalhes sobre isso aqui
* importante estudar propriedades estatísticas da regresão amostral e do método de Mínimos Quadrados Ordinários
help reg

reg c01012 i.escolaridade

*Modelo básico de regressão logística

*arrumar variável explicada 
tab auxilio_emergencial
tab auxilio_emergencial, nolabel
*o 2 precisa ser zero - para o comando reconhecer que é um resultado negativo
replace auxilio_emergencial = 0 if auxilio_emergencial ==2

*no comando abaixo podemos analisar somente o sinal 
logit auxilio_emergencial c01012 i.cor_raca i.escolaridade

* Para obter razão de probabilidade "odds ratio" (diminuir de 1)
logit, or

log close

*obs: quando fechar o STATA ele vai perguntar se você quer salvar o banco de dados, já que ele foi modificado. Não salve o banco de dados alterado, mantenha sempre a versão original. Se precisar salvar o banco de dados alterado, troque o nome do banco de dados, mantendo sempre o original.
