# Inventário e Classificação das Tabelas — Só Selantes

**Data:** 12/08/2026  
**Status:** Classificação preliminar baseada na estrutura atual do Supabase

## Objetivo

Classificar as tabelas atualmente existentes no PostgreSQL/Supabase para preparar a reconstrução do `public` como cópia do ERP Firebird.

> Esta classificação não autoriza exclusão ou movimentação de tabelas. A decisão física será tomada somente após confronto com a estrutura real do Firebird.

## Resultado da inspeção

A inspeção de `information_schema` e das constraints do PostgreSQL encontrou:

- **72 tabelas no `public`**;
- **1 tabela no schema `soselantes`**;
- nenhuma `FOREIGN KEY` física registrada nas tabelas analisadas;
- as chaves existentes em algumas tabelas complementares são independentes do ERP.

O ponto principal desta etapa é que **não devemos assumir que toda tabela `DEPxxx` atualmente presente no `public` seja necessariamente uma tabela que precisa permanecer no destino final sem confronto com o Firebird**.

## Classificação preliminar

### A — Núcleo comercial do ERP

| Tabela | Classificação | Motivo |
|---|---|---|
| `dep001` | ERP | Produtos |
| `dep011` | ERP | Clientes |
| `dep013` | ERP | Vendedores |
| `dep021` | ERP | Pedidos |
| `dep022` | ERP | Itens dos pedidos |

### B — ERP / estruturas relacionadas

As demais `depxxx` devem ser tratadas inicialmente como **candidatas a ERP**, até que o inventário Firebird confirme sua origem:

`dep002`, `dep003`, `dep006`, `dep007`, `dep009`, `dep010`, `dep012`, `dep014`, `dep016`, `dep017`, `dep018`, `dep019`, `dep020`, `dep023`, `dep024`, `dep025`, `dep026`, `dep027`, `dep028`, `dep031`, `dep032`, `dep033`, `dep034`, `dep035`, `dep036`, `dep037`, `dep039`, `dep040`, `dep041`, `dep042`, `dep043`, `dep044`, `dep045`, `dep046`, `dep047`, `dep048`, `dep049`, `dep052`, `dep056`, `dep057`, `dep059`, `dep060`, `dep061`, `dep062`, `dep063`, `dep064`, `dep065`, `dep066`, `dep067`, `dep068`, `dep069`, `dep070`, `dep071`, `dep072`, `dep073`, `dep074`, `dep075`, `dep080`, `dep083`.

### C — Complementares do projeto

| Tabela | Destino pretendido | Observação |
|---|---|---|
| `cidades_info` | `soselantes` | Enriquecimento geográfico/comercial |
| `metas_mensais` | `soselantes` | Metas por cidade/período |
| `metas_vendedores` | `soselantes` | Metas por vendedor |
| `staging_cidade_coords` | `soselantes`/staging | Coordenadas |
| `staging_cidade_regiao` | `soselantes`/staging | Região |
| `vendedores_filhos` | `soselantes` | Hierarquia comercial |
| `vendedores_pais` | `soselantes` | Hierarquia/comunicação |

### D — Estrutura técnica a investigar

| Tabela | Classificação | Ação |
|---|---|---|
| `dual` | Técnica/compatibilidade | Confirmar origem e necessidade |

## Constraints atuais

O levantamento mostrou que as tabelas `depxxx` atualmente no `public` não possuem `PRIMARY KEY` nem `FOREIGN KEY` físicas registradas no PostgreSQL.

Isso não significa que o Firebird não possua chaves, índices ou regras equivalentes. Significa apenas que a primeira cópia para o PostgreSQL não reproduziu essas constraints, ou elas não foram criadas no destino.

Esse ponto é importante para a nova cópia.

## Próxima auditoria obrigatória

Antes de qualquer `DROP`, `TRUNCATE` ou migração:

1. obter inventário real das tabelas do Firebird;
2. obter campos, tipos e tamanhos;
3. obter PKs e índices;
4. obter FKs/relacionamentos quando existirem;
5. comparar tabela por tabela com o `public`;
6. identificar tabelas do projeto que devem sair do `public`;
7. gerar um plano de reconstrução;
8. somente depois executar a limpeza.

## Regra de segurança

**Nenhuma tabela será excluída neste momento.**

A classificação acima serve para orientar a auditoria e evitar que uma limpeza do `public` apague dados complementares que ainda não foram migrados para `soselantes`.
