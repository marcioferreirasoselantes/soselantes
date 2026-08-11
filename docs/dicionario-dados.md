# Dicionário de Dados

## Objetivo

Registrar as principais entidades conhecidas do ERP e orientar a futura modelagem no PostgreSQL/Supabase.

## Tabelas legadas identificadas

| Tabela | Função conhecida | Observação |
|---|---|---|
| `DEP011` | Clientes | Cadastro de clientes do ERP |
| `DEP013` | Vendedores | Cadastro de vendedores/representantes |
| `DEP021` | Pedidos | Cabeçalho dos pedidos de venda |
| `DEP022` | Itens dos pedidos | Itens vinculados aos pedidos |

## DEP021 — Pedidos

A rotina de notificações e integrações já identificou como relevantes os pedidos cujo tipo seja `PED` e cuja data corresponda ao dia corrente, conforme a regra de negócio existente.

Campos e tipos completos ainda devem ser levantados diretamente no Firebird antes de serem considerados definitivos neste documento.

## DEP022 — Itens

Contém os itens associados aos pedidos da `DEP021`. A estrutura detalhada, chaves e campos de produto ainda devem ser confirmados no banco de origem.

## DEP011 — Clientes

Cadastro dos clientes utilizado pelo ERP. A estrutura detalhada e os relacionamentos devem ser confirmados antes da criação do modelo definitivo no Supabase.

## DEP013 — Vendedores

Cadastro de vendedores/representantes utilizado pelo ERP.

## Regra importante

Este documento diferencia explicitamente **estrutura conhecida** de **estrutura ainda não confirmada**. Nenhum campo deve ser inventado ou tratado como definitivo sem validação no banco de origem.
