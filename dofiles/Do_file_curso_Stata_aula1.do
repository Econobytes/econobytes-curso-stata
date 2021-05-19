*******************************************************
***           Curso de Stata - Econobytes           ***
***        Professora Raquel Pereira Pontes         ***
*******************************************************

***comando log
help log

log using "D:\Mega20-21\Econobytes\Curso Stata\Covid_19Brasil\resultados14-05.smcl>"

***Abrir dados da PNAD COVID no STATA com o pacote do Datazoom

/*PRIMEIRO: baixar dados do PNAD-COVID no site do IBGE: https://www.ibge.gov.br/estatisticas/investigacoes-experimentais/estatisticas-experimentais/27946-divulgacao-semanal-pnadcovid1?t=downloads
-> acessar a pasta Microdados/Dados:
- baixar PNAD_COVID_112020.zip
- extrair arquivo do zip para manter somente o arquivo csv na sua pasta
-> acessar a pasta Documentação 
- baixar dicionário_PNAD_COVID_112020_20210429
*/
*SEGUNDO: instalar pacote datazoom
/*
depois de rodar a linha abaixo de instalação:
- Clique no pacote da pesquisa de interesse
- Clique no link de instalação "(click here to install)"
*/
net from http://www.econ.puc-rio.br/datazoom/portugues

*Utilização do pacote datazoom
*para acessar o help
help datazoom_pnad_covid
*para acessar a caixa de dialago
db datazoom_pnad_covid

***********************************************************

*** ver a base de dados
edit

***ver os dados em gerenciador de variáveis - direto na barra de tarefas

*** gerar uma nova variável
gen mes = "novembro"
edit mes

***renomear variável
rename a005 escolaridade

************************************************************
***Análise Estatística Descritiva, Tabelas e Gráficos
**descrever o banco de dados
describe

**estatísticas descritivas simples, tais como medianas, médias e desvios-padrão das variáveis avaliadas
* estatística descritiva da base de dados
summarize

* estatística descritiva de determinadas variáveis
sum a006b

sum d0053

*estatística descritivas através de tabelas
tab a006b 
tab a006b [iw = v1032]

tab a007
tab b0011
tab b008

tab b0011 b008
tab b009b

tab c002
tab c003
tab c004
tab c013

tab d0051

**vamos arrumar algumas variáveis para fazer algumas análises
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

*Análise com gráficos

graph bar (count), over(home_office) over(cor_raca) over(sexo)

graph bar (count) if cor_raca == 1 | cor_raca == 2 | cor_raca == 4, over(home_office) over(cor_raca) over(sexo)

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

log close

*obs: quando fechar o STATA ele vai perguntar se você quer salvar o banco de dados, já que ele foi modificado. Não salve o banco de dados alterado, mantenha sempre a versão original. Se precisar salvar o banco de dados alterado, troque o nome do banco de dados, mantendo sempre o original.
