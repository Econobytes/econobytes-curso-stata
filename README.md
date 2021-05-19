## Curso de Stata

Professora Raquel Pereira Pontes         

### Abrir dados da PNAD COVID no STATA com o pacote do Datazoom

PRIMEIRO: baixar dados do PNAD-COVID no site do IBGE: https://www.ibge.gov.br/estatisticas/investigacoes-experimentais/estatisticas-experimentais/27946-divulgacao-semanal-pnadcovid1?t=downloads

-> acessar a pasta Microdados/Dados:
- baixar PNAD_COVID_112020.zip
- extrair arquivo do zip para manter somente o arquivo csv na sua pasta

-> acessar a pasta Documentação:
- baixar dicionário_PNAD_COVID_112020_20210429

SEGUNDO: instalar pacote datazoom, depois rodar a linha abaixo de instalação:
- Clique no pacote da pesquisa de interesse
- Clique no link de instalação "(click here to install)"

net from http://www.econ.puc-rio.br/datazoom/portugues

*Utilização do pacote datazoom para acessar o help
help datazoom_pnad_covid

*para acessar a caixa de dialago
db datazoom_pnad_covid

***********************************************************
