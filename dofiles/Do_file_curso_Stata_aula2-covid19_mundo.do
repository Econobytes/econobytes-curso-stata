************************************************************
*** Curso de Stata (aula 2 - dados mundiais) - Econobytes **
***             Professora Raquel Pereira Pontes         ***
************************************************************

***abrir log -> File -> Log -> Begin ou comando "log using"

***Abrir dados do Our World in data no STATA com o comando "insheet", existe um comando mais novo "import delimited”
help insheet

insheet using "https://covid.ourworldindata.org/data/owid-covid-data.csv", clear

save "D:\Mega20-21\Econobytes\Curso Stata\Covid_19mundo\covid19_mundo.dta"

**ver dados comando edit ou br

edit // para abrir o data editor
br // para navegar pelos dados
tab location

**variáveis string estarão em vermelho, variáveis numéricas estarão em preto e variáveis rotuladas estarão em azul
*gerar algumas variáveis
edit date
gen ano = substr(date,1,4)
gen mes = substr(date,6,2) 
gen dia = substr(date,9,2)

*converter variáveis String para numéricas
destring ano mes dia, replace

*criar nova variável de data
gen data = mdy(mes,dia,ano)
format data %tdDD-Mon-yyyy

*converter location (string) para variável numérica, criando uma nova variável rotulada.
encode location, gen(país)   

*declarar para o Stata que é são dados em painel

xtset país data 

*plotar gráfico básico
*total de casos (normalizado pela população) por milhão de pessoas (= (total_cases/population) * 1000000)
xtline total_cases_per_million, overlay
xtline total_cases_per_million if location ==  "Brazil", overlay
xtline total_cases_per_million if (location ==  "Brazil") | (location =="United States") | (location == "India") , overlay

*total de mortes (normalizado pela população) por milhão de pessoas (=total_deaths/population) * 1000000) 
xtline total_deaths_per_million if (location ==  "Brazil") | (location =="United States") | (location == "India") , overlay

*total de vacinação por cem pessoas
xtline total_vaccinations_per_hundred if (location ==  "Brazil") | (location =="United States") | (location == "India") , overlay

**gerar médias de suavização (média móvel) de 3 dias de novos casos e novas mortes
*Os comandos abaixo geram uma média móvel de 3 dias com base no dia de hoje e nas duas últimas observações
tssmooth ma new_cases_ma3  = new_cases , w(2 1 0) 
tssmooth ma new_deaths_ma3 = new_deaths, w(2 1 0)

*gráfico de média móveis de 3 dias
* de novos casos
xtline new_cases_ma3 if location ==  "Brazil", overlay
xtline new_cases_ma3 if (location ==  "Brazil") | (location =="United States") | (location == "India"), overlay

*de novas mortes
xtline new_deaths_ma3 if location ==  "Brazil", overlay
xtline new_deaths_ma3 if (location ==  "Brazil") | (location =="United States") | (location == "India"), overlay

**gerar médias de suavização de 7 dias de novos casos / mortes
tssmooth ma new_cases_ma7  = new_cases , w(6 1 0) 
tssmooth ma new_deaths_ma7 = new_deaths, w(6 1 0)

*gráfico de média móveis de 7 dias
* de novos casos
xtline new_cases_ma7 if location ==  "Brazil", overlay
xtline new_cases_ma7 if (location ==  "Brazil") | (location =="United States") | (location == "India"), overlay

*de novas mortes
xtline new_deaths_ma7 if location ==  "Brazil", overlay
xtline new_deaths_ma7 if (location ==  "Brazil") | (location =="United States") | (location == "India"), overlay

*fechar log
log close
