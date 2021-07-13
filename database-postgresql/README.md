# Desafio SQL

## Requisitos de utilização

- docker
- docker-compose
- dbeaver

## Requisitos da prova

0. Carregar o postgreSQL com o dump dentro da pasta [`devops/sql/dump.sql`](./devops/sql/dump.sql)
1. utilizar as operações basicas de SQL (insert,delete,update,select simples, select com join )

## A prova

Terá uma tabela com id e numero da moeda, valor atual
outra tabela com id da moeda (fk), numero da moeda e volume por dia de compra
terceira tabela com numero da moeda, dia, e quantos posts houveram no dia falando da moeda

## Avaliação

- fazer um select que traga o total de posts feitos por dia de cada moeda
- inserir novas moedas e atualizar as existentes
- fazer um relatorio aonde traga as 3 tabelas agrupadas

## Execução do banco

```bash
docker-compose up --build
```
