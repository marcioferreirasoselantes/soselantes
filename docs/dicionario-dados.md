# Dicionário de Dados — Só Selantes

**Versão:** 1.1  
**Data da auditoria:** 12/08/2026  
**Status:** Em construção — núcleo crítico confirmado diretamente no Firebird 2.0  
**Origem:** `DEPOSITO.FDB`  
**Destino:** Supabase / PostgreSQL

---

## 1. Objetivo

Este documento é a referência técnica do dicionário de dados do projeto Só Selantes. A estrutura física deve ser derivada do banco Firebird real; significado funcional e relacionamentos que não estejam declarados como constraints devem ser identificados separadamente.

> **Regra documental:** não inventar significado, chave ou relacionamento. O que ainda não foi confirmado deve permanecer como `A confirmar`.

## 2. Arquitetura de dados

### `public`

Representa a cópia do ERP Firebird no PostgreSQL/Supabase. Deve permanecer próxima da origem e pode ser reconstruída quando necessário.

### `soselantes`

Representa dados complementares e inteligência do projeto: equivalências, enriquecimentos, classificações, metas e regras próprias.

### Regra de sincronização

A rotina não deve copiar automaticamente toda tabela existente no Firebird. Deve existir uma lista explícita das tabelas pertencentes ao ERP.

---

## 3. Classificação das tabelas encontradas

A consulta de metadados do Firebird confirmou **65 tabelas `DEPxxx`** no banco.

| Tabela | Campos |
|---|---:|
| DEP001 | 43 |
| DEP002 | 3 |
| DEP003 | 3 |
| DEP006 | 3 |
| DEP007 | 4 |
| DEP009 | 2 |
| DEP010 | 22 |
| DEP011 | 45 |
| DEP012 | 2 |
| DEP013 | 9 |
| DEP014 | 12 |
| DEP016 | 3 |
| DEP017 | 6 |
| DEP018 | 6 |
| DEP019 | 12 |
| DEP020 | 2 |
| DEP021 | 42 |
| DEP022 | 13 |
| DEP023 | 7 |
| DEP024 | 16 |
| DEP025 | 16 |
| DEP026 | 5 |
| DEP027 | 17 |
| DEP028 | 14 |
| DEP031 | 22 |
| DEP032 | 16 |
| DEP033 | 23 |
| DEP034 | 2 |
| DEP035 | 3 |
| DEP036 | 15 |
| DEP037 | 2 |
| DEP039 | 9 |
| DEP040 | 35 |
| DEP041 | 14 |
| DEP042 | 7 |
| DEP043 | 31 |
| DEP044 | 15 |
| DEP045 | 16 |
| DEP046 | 11 |
| DEP047 | 12 |
| DEP048 | 2 |
| DEP049 | 2 |
| DEP052 | 8 |
| DEP056 | 12 |
| DEP057 | 7 |
| DEP059 | 6 |
| DEP060 | 22 |
| DEP061 | 14 |
| DEP062 | 8 |
| DEP063 | 6 |
| DEP064 | 8 |
| DEP065 | 2 |
| DEP066 | 8 |
| DEP067 | 11 |
| DEP068 | 4 |
| DEP069 | 9 |
| DEP070 | 8 |
| DEP071 | 12 |
| DEP072 | 11 |
| DEP073 | 2 |
| DEP074 | 3 |
| DEP075 | 10 |
| DEP080 | 30 |
| DEP083 | 5 |

Além dessas, existem tabelas que **não pertencem ao ERP** e devem ficar fora da cópia ERP→`public`:

- `METAS_VENDEDORES`
- `VENDEDORES_FILHOS`
- `VENDEDORES_PAIS`

As três foram criadas pelo projeto para outro aplicativo.

Também existe `DUAL`, que é uma estrutura técnica do Firebird e não uma entidade comercial do ERP.

---

## 4. Núcleo crítico confirmado

| Tabela | Função conhecida | PK física | FK física | Índices secundários |
|---|---|---|---|---|
| `DEP001` | Produtos | `DEP001` | Nenhuma | Nenhum |
| `DEP011` | Clientes | `DEP011` | Nenhuma | Nenhum |
| `DEP013` | Vendedores/representantes | `DEP013` | Nenhuma | Nenhum |
| `DEP021` | Cabeçalho de pedidos | `DEP021` | Nenhuma | Nenhum |
| `DEP022` | Itens de pedidos | `(DEP021, ITEM)` | Nenhuma | Nenhum |

As PKs foram confirmadas pelas constraints do Firebird:

- `DEP001` → `INTEG_2`
- `DEP011` → `INTEG_15`
- `DEP013` → `INTEG_19`
- `DEP021` → `INTEG_33`
- `DEP022` → `INTEG_36`

Os índices observados nessas cinco tabelas são somente os índices das respectivas PKs:

- `DEP001` → `RDB$PRIMARY1`
- `DEP011` → `RDB$PRIMARY7`
- `DEP013` → `RDB$PRIMARY9`
- `DEP021` → `RDB$PRIMARY16`
- `DEP022` → `RDB$PRIMARY17` sobre `DEP021, ITEM`

Todos estavam ativos.

### FKs do ERP

A consulta global de Foreign Keys encontrou somente FKs em `VENDEDORES_FILHOS`:

- `FK_FILHOS_DEP013` → campo `DEP013`
- `FK_FILHOS_PAI` → campo `VENDEDOR_PAI`

Portanto, **não foram encontradas FKs físicas nas cinco tabelas críticas nem nas demais tabelas `DEPxxx` consultadas globalmente**. As relações comerciais do ERP são, em grande parte, relações lógicas mantidas pela aplicação.

---

## 5. Modelo lógico conhecido

```text
DEP013 (vendedor)
      │
      │ DEP021.DEP013
      ▼
DEP021 (pedido)
   │             │
   │ DEP011      │ DEP022.DEP021
   ▼             ▼
DEP011        DEP022 (itens)
                 │
                 │ DEP001
                 ▼
              DEP001
              (produto)
```

Esses relacionamentos são **lógicos/conceituais**, não FKs físicas no Firebird:

- `DEP021.DEP011` → `DEP011.DEP011`
- `DEP021.DEP013` → `DEP013.DEP013`
- `DEP022.DEP021` → `DEP021.DEP021`
- `DEP022.DEP001` → `DEP001.DEP001`

A ausência de FK física deve ser preservada como característica do legado, sem impedir que o modelo PostgreSQL adote integridade referencial quando isso for seguro e deliberado.

---

# 6. DEP001 — Produtos

**Função conhecida:** cadastro de produtos.

**Campos:** 43.

**PK:** `DEP001`.

**Índice secundário:** nenhum identificado.

Regras comerciais já documentadas no projeto incluem a interpretação de referências com hífen, como `SSAC-1`, `SSAC-2`, `SSAC-3`, em que a parte numérica representa a cor. Essa regra é de negócio e não deve ser confundida com a estrutura física do Firebird.

A descrição campo a campo ainda será levantada.

---

# 7. DEP011 — Clientes

**Função conhecida:** cadastro de clientes.

**Campos:** 45.

**PK:** `DEP011`.

**Índice secundário:** nenhum identificado.

A estrutura física completa já foi levantada em parte; a descrição funcional de cada campo será consolidada após o inventário completo.

---

# 8. DEP013 — Vendedores

**Função conhecida:** cadastro de vendedores/representantes.

**Campos:** 9.

**PK:** `DEP013`.

**Índice secundário:** nenhum identificado.

Campos relacionados a credenciais, caso existam, devem ser tratados como sensíveis e nunca expostos por APIs, frontend, relatórios ou integrações de IA.

---

# 9. DEP021 — Pedidos

**Função conhecida:** cabeçalho dos pedidos/documentos comerciais.

**Campos:** 42.

**PK:** `DEP021`.

**Índice secundário:** nenhum identificado.

Regra já utilizada pela automação de pedidos do projeto:

```text
TIPO = 'PED'
DATA = data atual
```

Essa regra é de aplicação e não constitui constraint do Firebird.

---

# 10. DEP022 — Itens dos pedidos

**Função conhecida:** itens que compõem os pedidos de `DEP021`.

**Campos:** 13.

**PK física:** `(DEP021, ITEM)`.

**Índice:** `RDB$PRIMARY17` sobre `(DEP021, ITEM)`.

### Estrutura física confirmada

| Posição | Campo |
|---:|---|
| 1 | `DEP021` |
| 2 | `ITEM` |
| 3 | `DEP001` |
| 4 | `DEP002` |
| 5 | `DESCONTO` |
| 6 | `QUANTIDADE` |
| 7 | `UNITARIO` |
| 8 | `TOTAL` |
| 9 | `UNIDADE` |
| 10 | `VLR_VISTA` |
| 11 | `CUSTO` |
| 12 | `TIPO` |
| 13 | `DESCRICAO` |

`DEP021` e `DEP001` são relacionamentos lógicos conhecidos; nenhuma FK física foi encontrada.

---

## 11. Estratégia de sincronização Firebird → Supabase

```text
             ERP / Firebird 2.0
                     │
                     ▼
              lista explícita
              de tabelas ERP
                     │
                     ▼
              Supabase / public
                     │
          ┌──────────┴──────────┐
          │                     │
     cópia do ERP        sem customizações
          │               permanentes
          ▼
      consultas /
      automações

       Supabase / soselantes
               │
       dados próprios do projeto
```

A reconstrução do `public` deve preservar o schema `soselantes` e outras estruturas complementares definitivas.

---

## 12. Próxima etapa do levantamento

O inventário de quantidade de campos das 65 tabelas está confirmado. A próxima extração deve levantar, para **todas as 65 `DEPxxx`**:

1. campos e posições;
2. tipos Firebird;
3. tamanhos/precisão/escala;
4. nulabilidade;
5. PKs;
6. índices;
7. defaults;
8. generators/sequences;
9. triggers;
10. constraints;
11. domínios;
12. descrições funcionais quando puderem ser confirmadas.

Depois disso será produzido o mapa definitivo **Firebird → PostgreSQL/Supabase**.

---

## 13. Princípios documentais

- **Confirmado:** veio diretamente do Firebird ou de regra de negócio já validada.
- **Lógico:** relacionamento ou significado utilizado pela aplicação, sem constraint física correspondente.
- **A confirmar:** ainda não há evidência suficiente.
- Não transformar hipótese em documentação definitiva.
- Não tratar tabelas de outros aplicativos como tabelas do ERP.
- Não alterar o Firebird durante o levantamento estrutural.
