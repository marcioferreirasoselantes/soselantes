# Dicionário de Dados — Só Selantes

**Versão:** 1.3  
**Data da auditoria:** 12/08/2026  
**Status:** Em construção — inventário de campos e estrutura física confirmados diretamente no Firebird 2.0  
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

## 3. Inventário das tabelas do ERP

O levantamento realizado diretamente no Firebird confirmou **64 tabelas `DEPxxx`** no banco. O inventário de campos fornecido pelo DBeaver contém **750 campos** distribuídos nessas 64 tabelas.

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

Além dessas, existem estruturas que **não pertencem ao ERP** e devem ficar fora da cópia ERP→`public`:

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

### Índices secundários identificados no banco

No levantamento global dos índices, foram encontrados três índices secundários adicionais em `DEP040`:

| Tabela | Índice | Campo |
|---|---|---|
| DEP040 | `IDX_DEP040_DATA_PGTO` | `DATA_PGTO` |
| DEP040 | `IDX_DEP040_DEP013` | `DEP013` |
| DEP040 | `IDX_DEP040_DEP021` | `DEP021` |

Esses índices são relevantes para consultas e para o desenho de índices equivalentes no PostgreSQL, mas a migração deve ser decidida após análise dos padrões de consulta.

---

## 5. FKs e relacionamentos

A consulta global de Foreign Keys encontrou somente FKs nas tabelas criadas para outro aplicativo:

- `VENDEDORES_FILHOS` → `FK_FILHOS_DEP013`, campo `DEP013`
- `VENDEDORES_FILHOS` → `FK_FILHOS_PAI`, campo `VENDEDOR_PAI`

Portanto, **não foram encontradas FKs físicas nas tabelas `DEPxxx` no levantamento realizado**. As relações comerciais do ERP são, em grande parte, relações lógicas mantidas pela aplicação.

### Relacionamentos lógicos confirmados por estrutura e nomes de campos

O inventário de campos permite identificar os seguintes relacionamentos centrais:

| Origem | Campo | Destino | Chave destino | Status |
|---|---|---|---|---|
| DEP001 | `DEP002` | DEP002 | `DEP002` | Provável |
| DEP001 | `DEP003` | DEP003 | `DEP003` | Provável |
| DEP001 | `DEP006` | DEP006 | `DEP006` | Provável |
| DEP001 | `DEP007` | DEP007 | `DEP001 + DATA` | Provável |
| DEP001 | `DEP010` | DEP010 | `DEP010` | Provável |
| DEP001 | `DEP012` | DEP012 | `DEP012` | Provável |
| DEP011 | `DEP016` | DEP016 | `DEP016` | Provável |
| DEP011 | `DEP013` | DEP013 | `DEP013` | Provável |
| DEP011 | `DEP049` | DEP049 | `DEP049` | Provável |
| DEP011 | `DEP065` | DEP065 | `DEP065` | Provável |
| DEP014 | `DEP013` | DEP013 | `DEP013` | Provável |
| DEP014 | `DEP001` | DEP001 | `DEP001` | Provável |
| DEP014 | `DEP002` | DEP002 | `DEP002` | Provável |
| DEP019 | `DEP021` | DEP021 | `DEP021` | Provável |
| DEP019 | `DEP001` | DEP001 | `DEP001` | Provável |
| DEP019 | `DEP002` | DEP002 | `DEP002` | Provável |
| DEP019 | `DEP011` | DEP011 | `DEP011` | Provável |
| DEP021 | `DEP011` | DEP011 | `DEP011` | Confirmado logicamente |
| DEP021 | `DEP013` | DEP013 | `DEP013` | Confirmado logicamente |
| DEP021 | `DEP075` | DEP075 | `DEP075` | Provável |
| DEP021 | `DEP009` | DEP009 | `DEP009` | Provável |
| DEP022 | `DEP021` | DEP021 | `DEP021` | Confirmado logicamente |
| DEP022 | `DEP001` | DEP001 | `DEP001` | Confirmado logicamente |
| DEP022 | `DEP002` | DEP002 | `DEP002` | Provável |
| DEP023 | `DEP001` | DEP001 | `DEP001` | Provável |
| DEP024 | `DEP001` | DEP001 | `DEP001` | Provável |
| DEP024 | `DEP002` | DEP002 | `DEP002` | Provável |
| DEP025 | `DEP021` | DEP021 | `DEP021` | Confirmado logicamente |
| DEP026 | `DEP021` | DEP021 | `DEP021` | Provável |
| DEP028 | `DEP027` | DEP027 | `DEP027` | Provável |
| DEP031 | `DEP010` | DEP010 | `DEP010` | Provável |
| DEP031 | `DEP018` | DEP018 | `DEP018` | Provável |
| DEP031 | `DEP041` | DEP041 | `DEP041` | Provável |
| DEP032 | `DEP031` | DEP031 | `DEP031` | Provável |
| DEP033 | `DEP010` | DEP010 | `DEP010` | Provável |
| DEP033 | `DEP034` | DEP034 | `DEP034` | Provável |
| DEP033 | `DEP031` | DEP031 | `DEP031` | Provável |
| DEP033 | `DEP035` | DEP035 | `DEP035` | Provável |
| DEP033 | `DEP045` | DEP045 | `DEP045` | Provável |
| DEP036 | `DEP034` | DEP034 | `DEP034` | Provável |
| DEP036 | `DEP037` | DEP037 | `DEP037` | Provável |
| DEP036 | `DEP010` | DEP010 | `DEP010` | Provável |
| DEP039 | `DEP027` | DEP027 | `DEP027` | Provável |
| DEP039 | `DEP035` | DEP035 | `DEP035` | Provável |
| DEP040 | `DEP021` | DEP021 | `DEP021` | Confirmado logicamente |
| DEP040 | `DEP011` | DEP011 | `DEP011` | Confirmado logicamente |
| DEP040 | `DEP013` | DEP013 | `DEP013` | Confirmado logicamente |
| DEP040 | `DEP034` | DEP034 | `DEP034` | Provável |
| DEP040 | `DEP059` | DEP059 | `DEP059` | Provável |
| DEP043 | `DEP018` | DEP018 | `DEP018` | Provável |
| DEP043 | `DEP011` | DEP011 | `DEP011` | Confirmado logicamente |
| DEP043 | `DEP041` | DEP041 | `DEP041` | Provável |
| DEP044 | `DEP001` | DEP001 | `DEP001` | Confirmado logicamente |
| DEP044 | `DEP002` | DEP002 | `DEP002` | Provável |
| DEP045 | `DEP021` | DEP021 | `DEP021` | Confirmado logicamente |
| DEP045 | `DEP011` | DEP011 | `DEP011` | Confirmado logicamente |
| DEP045 | `DEP013` | DEP013 | `DEP013` | Confirmado logicamente |
| DEP046 | `DEP021` | DEP021 | `DEP021` | Confirmado logicamente |
| DEP046 | `DEP001` | DEP001 | `DEP001` | Confirmado logicamente |
| DEP046 | `DEP002` | DEP002 | `DEP002` | Provável |
| DEP047 | `DEP011` | DEP011 | `DEP011` | Provável |
| DEP048 | `DEP047` | DEP047 | `DEP047` | Provável |
| DEP048 | `DEP021` | DEP021 | `DEP021` | Confirmado logicamente |
| DEP052 | `DEP011` | DEP011 | `DEP011` | Provável |
| DEP056 | `DEP010` | DEP010 | `DEP010` | Provável |
| DEP056 | `DEP041` | DEP041 | `DEP041` | Provável |
| DEP057 | `DEP056` | DEP056 | `DEP056` | Provável |
| DEP059 | `DEP034` | DEP034 | `DEP034` | Provável |
| DEP060 | `DEP018` | DEP018 | `DEP018` | Provável |
| DEP060 | `DEP011` | DEP011 | `DEP011` | Confirmado logicamente |
| DEP060 | `DEP041` | DEP041 | `DEP041` | Provável |
| DEP061 | `DEP001` | DEP001 | `DEP001` | Confirmado logicamente |
| DEP061 | `DEP002` | DEP002 | `DEP002` | Provável |
| DEP062 | `DEP001` | DEP001 | `DEP001` | Provável |
| DEP064 | `DEP011` | DEP011 | `DEP011` | Provável |
| DEP066 | `DEP001` | DEP001 | `DEP001` | A confirmar |
| DEP067 | `DEP066` | DEP066 | `DEP066` | Provável |
| DEP067 | `DEP010` | DEP010 | `DEP010` | Provável |
| DEP068 | `DEP066` | DEP066 | `DEP066` | Provável |
| DEP068 | `DEP001` | DEP001 | `DEP001` | Provável |
| DEP069 | `DEP001` | DEP001 | `DEP001` | Provável |
| DEP070 | `DEP066` | DEP066 | `DEP066` | Provável |
| DEP075 | `DEP073` | DEP073 | `DEP073` | Provável |
| DEP075 | `DEP074` | DEP074 | `DEP074` | Provável |
| DEP080 | `DEP040` | DEP040 | `DEP040` | Provável |
| DEP080 | `DEP021` | DEP021 | `DEP021` | Confirmado logicamente |
| DEP080 | `DEP011` | DEP011 | `DEP011` | Confirmado logicamente |
| DEP080 | `DEP013` | DEP013 | `DEP013` | Confirmado logicamente |

> **Importante:** “Provável” não significa FK validada. É uma hipótese derivada da estrutura e deve ser validada por dados antes de criar constraints no PostgreSQL.

---

## 6. Modelo lógico central

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

Relacionamentos centrais já utilizados pelo projeto:

- `DEP021.DEP011` → `DEP011.DEP011`
- `DEP021.DEP013` → `DEP013.DEP013`
- `DEP022.DEP021` → `DEP021.DEP021`
- `DEP022.DEP001` → `DEP001.DEP001`

Esses relacionamentos são lógicos/conceituais, não FKs físicas no Firebird.

---

## 7. Inventário completo de campos

O inventário abaixo foi extraído diretamente do catálogo `RDB$RELATION_FIELDS` do Firebird e fornecido pelo DBeaver. A ordem apresentada é a ordem física dos campos na tabela.

### DEP001 — 43 campos

`DEP001`, `DESCRICAO`, `EAN`, `REFERENCIA`, `DEP002`, `DEP003`, `DEP006`, `CUSTO`, `VENDA_VISTA`, `MARGEM`, `VENDA_SUGESTAO`, `SALDO`, `DEP007`, `DEP010`, `OBS`, `DEP012`, `ATIVO`, `CAMINHO_FOTO`, `DT_CADASTRO`, `USUARIO`, `ULTIMO_CUSTO`, `SALDO_ANT`, `ULT_COMPRA`, `ULT_VENDA`, `CUSTO_MEDIO`, `SALDO_MAX`, `SALDO_MIN`, `PER_COMISSAO`, `DESCONTO_MAX`, `ICMS`, `SUBTR`, `MOVIMENTO`, `STATUS`, `ULT_REAJ`, `USUARIO_REAJ`, `VENDA_ANT`, `IVA`, `CLASS_FISCAL`, `INICIAL`, `COMPRA`, `QTDE_CAIXA`, `EXPEDICAO`, `GRUPO_COMISSAO`

### DEP002 — 3 campos

`DEP002`, `DESCRICAO`, `MULTIPLICADOR`

### DEP003 — 3 campos

`DEP003`, `DESCRICAO`, `PER_COMISSAO`

### DEP006 — 3 campos

`DEP006`, `DESCRICAO`, `PERCENTUAL`

### DEP007 — 4 campos

`DEP001`, `DATA`, `HORA`, `QUANTIDADE`

### DEP009 — 2 campos

`DEP009`, `DESCRICAO`

### DEP010 — 22 campos

`DEP010`, `RAZAOSOCIAL`, `FANTASIA`, `ENDERECO`, `BAIRRO`, `UF`, `CIDADE`, `CEP`, `CNPJ`, `INSCRICAO`, `TELEFONE`, `FAX`, `TELEFONE_GRATIS`, `EMAIL`, `SITE`, `OBS`, `CELULAR`, `FILIAL`, `ATIVIDADE`, `CONTATO`, `OBS2`, `DATA`

### DEP011 — 45 campos

`DEP011`, `RAZAOSOCIAL`, `FANTASIA`, `ENDERECO`, `COMPLEMENTO`, `BAIRRO`, `UF`, `CIDADE`, `CEP`, `CGC_CPF`, `INSCRICAO`, `TELEFONE`, `FAX`, `CELULAR`, `EMAIL`, `SITUACAO`, `DATA_NASC`, `TIPO`, `OBS`, `DT_CADASTRO`, `USUARIO`, `FONE2`, `FILIAL`, `CONTATO`, `ENDERECOC`, `CIDADEC`, `UFC`, `BAIRROC`, `CEPC`, `FONEC`, `FAXC`, `OBS2`, `AVISO1`, `AVISO2`, `AVISO3`, `AVISO4`, `AVISO5`, `ULT_COMPRA`, `DEP016`, `LIMITE`, `DATA_CONSULTA`, `DEP013`, `DEP049`, `DEP065`, `NF_IMPRESSA`

### DEP012 — 2 campos

`DEP012`, `DESCRICAO`

### DEP013 — 9 campos

`DEP013`, `NOME_LOGIN`, `NOME_COMPLETO`, `SENHA`, `ATIVO`, `PER_COMISSAO`, `SENHA_LIBERAR`, `SENHA_ACESSO`, `SENHA_DEFEITO`

### DEP014 — 12 campos

`DEP014`, `LOTE`, `DATA`, `HORA`, `DEP013`, `DEP001`, `DEP002`, `QUANTIDADE`, `UNITARIO`, `TOTAL`, `UNIDADE`, `OBS`

### DEP016 — 3 campos

`DEP016`, `CIDADE`, `COD_CIDADE`

### DEP017 — 6 campos

`DEP017`, `NOME`, `TELEFONE`, `TELEFONE2`, `OBS`, `USUARIO`

### DEP018 — 6 campos

`DEP018`, `DESCRICAO`, `SIGLA`, `GERA_DUPLICATA`, `TIPO`, `ATIVO`

### DEP019 — 12 campos

`DEP019`, `DEP021`, `DEP001`, `DEP002`, `DESCONTO`, `QUANTIDADE`, `UNITARIO`, `TOTAL`, `UNIDADE`, `VLR_VISTA`, `DEP011`, `DATA`

### DEP020 — 2 campos

`NCM`, `IMPOSTO`

### DEP021 — 42 campos

`DEP021`, `DATA`, `HORA`, `TIPO`, `DEP011`, `NOME`, `CONDICAO_PGTO`, `TOTAL`, `DEP013`, `VALOR_PAGO`, `DATA_PGTO`, `PAGO`, `TOTAL_PRODUTOS`, `TOTAL_DEVOL`, `OBS`, `QTDE_IMP`, `NOTA`, `DESCONTO`, `PRAZO_ENTREGA`, `VALIDADE`, `PRAZO_PGTO`, `USUARIO_LIBEROU`, `LIBERACAO_CADASTRO`, `MOTIVO_CADASTRO`, `DATANOTA2`, `BAIXA_EMP`, `OBS_BAIXA`, `DEP013_USER`, `PENDENTE`, `FRETE`, `LOCAL`, `ORIGEM`, `DEP075`, `DATA_ENTREGA`, `DATA_DEV`, `OBS_ENTREGA`, `OBS_DEV`, `QTDE_VOL`, `FATURADO`, `DEP009`, `EXPEDICAO`, `PRONTA_ENTREGA`

### DEP022 — 13 campos

`DEP021`, `ITEM`, `DEP001`, `DEP002`, `DESCONTO`, `QUANTIDADE`, `UNITARIO`, `TOTAL`, `UNIDADE`, `VLR_VISTA`, `CUSTO`, `TIPO`, `DESCRICAO`

### DEP023 — 7 campos

`DEP001`, `ANO`, `MES`, `COMPRAS`, `VENDAS`, `ENTRADAS`, `SAIDAS`

### DEP024 — 16 campos

`DEP024`, `DEP001`, `DATA_MOV`, `DEP002`, `QUANTIDADE`, `VENDA_VISTA`, `VENDA_PRAZO`, `VALOR_CUSTO`, `VALOR_VENDA`, `DOCUMENTO`, `TIPO_MOV`, `SALDO`, `NOME`, `USUARIO`, `MOTIVO`, `DATA_BASE`

### DEP025 — 16 campos

`DEP021`, `LIMITE_USER`, `LIMITE_DATA`, `LIMITE_HORA`, `RESTRI_USER`, `RESTRI_DATA`, `RESTRI_HORA`, `PRAZO_USER`, `PRAZO_DATA`, `PRAZO_HORA`, `DESCONTO_USER`, `DESCONTO_DATA`, `DESCONTO_HORA`, `ESTOQUE_USER`, `ESTOQUE_DATA`, `ESTOQUE_HORA`

### DEP026 — 5 campos

`DEP026`, `USUARIO`, `DATA`, `HORA`, `DEP021`

### DEP027 — 17 campos

`DEP027`, `DATA_ABERTURA`, `HORA_ABERTURA`, `COD_USUARIO`, `VALOR_INICIAL`, `DATA_FECHAMENTO`, `HORA_FECHAMENTO`, `DINHEIRO`, `CHEQUE`, `CARTAO_DEB`, `CARTAO_CRE`, `FINANCIAMENTO`, `DEPOSITO`, `SANGRIA`, `REFORCO`, `USUARIO`, `VALOR_CONFERIDO`

### DEP028 — 14 campos

`DEP028`, `DEP027`, `DATA`, `HORA`, `HISTORICO`, `COMPLEMENTO`, `TIPO`, `DINHEIRO`, `CHEQUE`, `CARTAO_DEB`, `CARTAO_CRE`, `FINANCIAMENTO`, `DEPOSITO`, `OBS`

### DEP031 — 22 campos

`DEP031`, `DATA`, `DEP010`, `NUMERO`, `SERIE`, `FNG`, `BASE_ICMS`, `VALOR_ICMS`, `BASE_ICMS_SUB`, `VALOR_ICMS_SUB`, `IPI`, `FRETE`, `DESCONTO`, `ACRESCIMO`, `TOTAL_NOTA`, `TOTAL_PRODUTOS`, `PENDENTE`, `DEP018`, `DATA_BASE`, `VLR_CONF_ICMS`, `DEP041`, `CONDICAO`

### DEP032 — 16 campos

`DEP031`, `ITEM`, `COM001`, `QUANTIDADE`, `UNITARIO`, `PER_DESCONTO`, `PER_ACRESCIMO`, `PER_IPI`, `PER_ICMS`, `TOTAL`, `VALOR_REAL`, `NOVA_MAR_V`, `NOVO_PRE_V`, `NOVA_MAR_P`, `NOVO_PRE_P`, `SUBST`

### DEP033 — 23 campos

`DEP010`, `DUPLICATA`, `LETRA`, `PARCIAL`, `EMISSAO`, `VENCIMENTO`, `VALOR`, `VALOR_PGTO`, `DATA_PGTO`, `JUROS`, `DESCONTO`, `DATA_ENTRADA`, `DEP034`, `DEP031`, `DEP035`, `DEP045`, `OBS`, `NCHEQUE`, `NOTA`, `FNG`, `DEP033`, `OBS2`, `IMPOSTO`

### DEP034 — 2 campos

`DEP034`, `DESCRICAO`

### DEP035 — 3 campos

`DEP035`, `DESCRICAO`, `GERA_CPG`

### DEP036 — 15 campos

`CPF_CGC`, `NUM_CHEQUE`, `DEP034`, `AGENCIA`, `CONTA`, `VALOR`, `DATA_EMISSAO`, `DATA_VENCIMENTO`, `DATA_BAIXA`, `DATA_DEVOLUCAO`, `DEP037`, `OBS`, `DEP010`, `CLIENTE`, `DEP034_DEP`

### DEP037 — 2 campos

`DEP037`, `DESCRICAO`

### DEP039 — 9 campos

`DATA`, `HORA`, `DEP027`, `DINHEIRO`, `CHEQUE`, `MOTIVO`, `TIPO`, `RETIRADA`, `DEP035`

### DEP040 — 35 campos

`DEP040`, `NUMERO`, `LETRA`, `PEDDEV`, `DATA`, `VENCIMENTO`, `DEP021`, `DATA_PGTO`, `VALOR_PAGO`, `VALOR`, `GEROU_BOLETO`, `NR_BOLETO`, `NOTA`, `TIPO`, `DEP011`, `OBS`, `OBS2`, `OBS3`, `DEP034`, `JUROS`, `DESCONTO`, `NCHEQUE`, `DEP013`, `DATANOTA`, `PER_COMISSAO`, `GEROU_NOTA`, `DT_ALTERACAO`, `OBS_LIVRO`, `DT_BAIXA_SISTEMA`, `MAQUINA`, `DT_DESCONTO`, `GERADO`, `DATA_GERADO`, `DATA_FLUXO`, `DEP059`

### DEP041 — 14 campos

`DEP041`, `DESCRICAO`, `QTDE_PARCELAS`, `DIA_1`, `DIA_2`, `DIA_3`, `DIA_4`, `DIA_5`, `DIA_6`, `DIA_7`, `DIA_8`, `DIA_9`, `DIA_10`, `MODALIDADE`

### DEP042 — 7 campos

`DEP042`, `DATA`, `HORA`, `TIPO`, `MAQUINA`, `COD_USUARIO`, `NOME_USUARIO`

### DEP043 — 31 campos

`NOTA`, `SERIE`, `EMISSAO`, `SAIDA`, `DT_IMPRESSAO`, `DEP018`, `DEP011`, `TIPO`, `BASE_ICMS`, `VALOR_ICMS`, `DESCONTO`, `ACRESCIMOS`, `FRETE`, `TOTAL_PRODUTOS`, `TOTAL_NOTA`, `OBS1`, `OBS2`, `OBS3`, `CANCELADA`, `DEP041`, `CONDICAO`, `MOTIVO_CANC`, `LIBERACAO_CADASTRO`, `MOTIVO_CADASTRO`, `BASE_ICMS_SUB`, `VALOR_ICMS_SUB`, `IPI`, `VLR_CONF_ICMS`, `DT_LIQUIDADO`, `OBS_LIQUI`, `VLR_FRETE`

### DEP044 — 15 campos

`NOTA`, `SERIE`, `ITEM`, `DEP001`, `DESCRICAO`, `DEP002`, `QTDE`, `UNITARIO`, `TOTAL`, `ICMS`, `IPI`, `ST`, `CUSTO`, `VENDA`, `SIGLA_CFOP`

### DEP045 — 16 campos

`DEP045`, `DEP021`, `DATA`, `HORA`, `TIPO`, `DEP011`, `NOME`, `CONDICAO_PGTO`, `TOTAL`, `DEP013`, `TOTAL_PRODUTOS`, `TOTAL_DEVOL`, `OBS`, `DATA_EXCLUSAO`, `ATUALIZAR`, `DEP009`

### DEP046 — 11 campos

`DEP021`, `ITEM`, `DEP001`, `DEP002`, `DESCONTO`, `QUANTIDADE`, `UNITARIO`, `TOTAL`, `UNIDADE`, `TIPO`, `DESCRICAO`

### DEP047 — 12 campos

`DEP047`, `DATA`, `DEP011`, `NOME`, `DESCONTO`, `TOTAL`, `PAGO`, `TIPO`, `COD_USUARIO`, `VLR_ORIGINAL`, `TIPO_RECEBER`, `DESCRICAO`

### DEP048 — 2 campos

`DEP047`, `DEP021`

### DEP049 — 2 campos

`DEP049`, `DESCRICAO`

### DEP052 — 8 campos

`DEP052`, `DATA`, `HORA`, `DEP011`, `SITUACAO_ATUAL`, `COD_USUARIO`, `USUARIO`, `MOTIVO`

### DEP056 — 12 campos

`DEP056`, `DEP010`, `DATA`, `TOTAL`, `OBS`, `HORA`, `COD_USUARIO`, `USUARIO`, `BAIXA`, `PRAZO_ENTREGA`, `CONDICAO`, `DEP041`

### DEP057 — 7 campos

`DEP056`, `ITEM`, `COM001`, `QTDE`, `UNITARIO`, `TOTAL`, `DESCRICAO`

### DEP059 — 6 campos

`DEP059`, `NOME`, `DEP034`, `AGENCIA`, `CONTA`, `DATA_ABERTURA`

### DEP060 — 22 campos

`NOTA`, `SERIE`, `EMISSAO`, `SAIDA`, `DEP018`, `DEP011`, `TIPO`, `BASE_ICMS`, `VALOR_ICMS`, `DESCONTO`, `ACRESCIMOS`, `FRETE`, `TOTAL_PRODUTOS`, `TOTAL_NOTA`, `OBS1`, `OBS2`, `OBS3`, `CANCELADA`, `DEP041`, `CONDICAO`, `DATA_EXCLUSAO`, `USUARIO`

### DEP061 — 14 campos

`NOTA`, `SERIE`, `ITEM`, `DEP001`, `DESCRICAO`, `DEP002`, `QTDE`, `UNITARIO`, `TOTAL`, `ICMS`, `IPI`, `ST`, `CUSTO`, `VENDA`

### DEP062 — 8 campos

`ANO`, `MES`, `DEP001`, `QTDE_BALANCO`, `SALDO`, `CUSTO`, `VENDA`, `DATA`

### DEP063 — 6 campos

`DEP063`, `DATA`, `HORA`, `MENSAGEM`, `USUARIO`, `FEITO`

### DEP064 — 8 campos

`DEP064`, `DATA`, `HORA`, `MENSAGEM`, `USUARIO`, `DEP011`, `TIPO`, `DATA_RETORNO`

### DEP065 — 2 campos

`DEP065`, `DESCRICAO`

### DEP066 — 8 campos

`DEP066`, `DESCRICAO`, `CUSTO`, `SALDO`, `PRODUTO`, `UNIDADE`, `SALDO_MIN`, `SALDO_MAX`

### DEP067 — 11 campos

`DEP067`, `DEP066`, `NUMERO`, `DATA`, `DEP010`, `QTDE`, `UNITARIO`, `TOTAL`, `OBS`, `NOTA`, `FNG`

### DEP068 — 4 campos

`DEP068`, `DEP066`, `DEP001`, `QTDE`

### DEP069 — 9 campos

`DEP069`, `DEP001`, `QTDE`, `DATA`, `NUMERO`, `USUARIO`, `CUSTO_TOTAL`, `CUSTO_ITEM`, `PENDENTE`

### DEP070 — 8 campos

`DEP070`, `DEP066`, `QTDE`, `USUARIO`, `TIPO`, `SALDO`, `VALOR`, `DATA`

### DEP071 — 12 campos

`DEP071`, `CAMPO`, `ANTIGO`, `NOVO`, `USUARIO`, `MAQUINA`, `DATA`, `HORA`, `COD_CLI`, `LOCAL`, `ATUALIZAR`, `NOME`

### DEP072 — 11 campos

`CAMPO`, `ANTIGO`, `NOVO`, `USUARIO`, `MAQUINA`, `DATA`, `HORA`, `COD_CLI`, `LOCAL`, `ATUALIZAR`, `NOME`

### DEP073 — 2 campos

`DEP073`, `NOME`

### DEP074 — 3 campos

`DEP074`, `DESCRICAO`, `PLACA`

### DEP075 — 10 campos

`DEP075`, `DATA`, `USUARIO`, `DEP073`, `DEP074`, `OBS`, `DATA_ENTREGA`, `KM_SAIDA`, `KM_CHEGADA`, `DATA_COLETA`

### DEP080 — 30 campos

`DEP040`, `NUMERO`, `LETRA`, `PEDDEV`, `DATA`, `VENCIMENTO`, `DEP021`, `DATA_PGTO`, `VALOR_PAGO`, `VALOR`, `GEROU_BOLETO`, `NR_BOLETO`, `NOTA`, `TIPO`, `DEP011`, `OBS`, `OBS2`, `OBS3`, `DEP034`, `JUROS`, `DESCONTO`, `NCHEQUE`, `DEP013`, `DATANOTA`, `PER_COMISSAO`, `GEROU_NOTA`, `DT_ALTERACAO`, `OBS_LIVRO`, `DT_BAIXA_SISTEMA`, `MAQUINA`

### DEP083 — 5 campos

`DEP083`, `DATA`, `HORA`, `USUARIO`, `DEP021`

---

## 8. PKs de todas as tabelas `DEPxxx`

As constraints de chave primária levantadas no Firebird foram:

| Tabela | Constraint | Campos |
|---|---|---|
| DEP001 | `INTEG_2` | DEP001 |
| DEP002 | `INTEG_4` | DEP002 |
| DEP003 | `INTEG_6` | DEP003 |
| DEP006 | `INTEG_8` | DEP006 |
| DEP007 | `INTEG_11` | DEP001, DATA |
| DEP009 | `INTEG_143` | DEP009 |
| DEP010 | `INTEG_13` | DEP010 |
| DEP011 | `INTEG_15` | DEP011 |
| DEP012 | `INTEG_17` | DEP012 |
| DEP013 | `INTEG_19` | DEP013 |
| DEP014 | `INTEG_21` | DEP014 |
| DEP016 | `INTEG_23` | DEP016 |
| DEP017 | `INTEG_25` | DEP017 |
| DEP018 | `INTEG_27` | DEP018 |
| DEP019 | `INTEG_29` | DEP019 |
| DEP020 | `INTEG_31` | NCM |
| DEP021 | `INTEG_33` | DEP021 |
| DEP022 | `INTEG_36` | DEP021, ITEM |
| DEP023 | `INTEG_40` | DEP001, ANO, MES |
| DEP024 | `INTEG_42` | DEP024 |
| DEP025 | `INTEG_115` | DEP021 |
| DEP026 | `INTEG_145` | DEP026 |
| DEP027 | `INTEG_44` | DEP027 |
| DEP028 | `INTEG_46` | DEP028 |
| DEP031 | `INTEG_48` | DEP031 |
| DEP032 | `INTEG_51` | DEP031, ITEM |
| DEP033 | `INTEG_56` | DEP010, DUPLICATA, LETRA, PARCIAL |
| DEP034 | `INTEG_58` | DEP034 |
| DEP035 | `INTEG_60` | DEP035 |
| DEP036 | `INTEG_63` | CPF_CGC, NUM_CHEQUE |
| DEP037 | `INTEG_65` | DEP037 |
| DEP039 | `INTEG_68` | DATA, HORA |
| DEP040 | `INTEG_70` | DEP040 |
| DEP041 | `INTEG_72` | DEP041 |
| DEP042 | `INTEG_74` | DEP042 |
| DEP043 | `INTEG_77` | NOTA, SERIE |
| DEP044 | `INTEG_81` | NOTA, SERIE, ITEM |
| DEP045 | `INTEG_83` | DEP045 |
| DEP046 | `INTEG_86` | DEP021, ITEM |
| DEP047 | `INTEG_88` | DEP047 |
| DEP048 | `INTEG_91` | DEP047, DEP021 |
| DEP049 | `INTEG_117` | DEP049 |
| DEP052 | `INTEG_93` | DEP052 |
| DEP056 | `INTEG_95` | DEP056 |
| DEP057 | `INTEG_98` | DEP056, ITEM |
| DEP059 | `INTEG_100` | DEP059 |
| DEP060 | `INTEG_103` | NOTA, SERIE |
| DEP061 | `INTEG_107` | NOTA, SERIE, ITEM |
| DEP062 | `INTEG_111` | ANO, MES, DEP001 |
| DEP063 | `INTEG_119` | DEP063 |
| DEP064 | `INTEG_121` | DEP064 |
| DEP065 | `INTEG_123` | DEP065 |
| DEP066 | `INTEG_125` | DEP066 |
| DEP067 | `INTEG_127` | DEP067 |
| DEP068 | `INTEG_129` | DEP068 |
| DEP069 | `INTEG_131` | DEP069 |
| DEP070 | `INTEG_133` | DEP070 |
| DEP071 | `INTEG_135` | DEP071 |
| DEP073 | `INTEG_137` | DEP073 |
| DEP074 | `INTEG_139` | DEP074 |
| DEP075 | `INTEG_141` | DEP075 |
| DEP080 | `INTEG_113` | DEP040 |
| DEP083 | `INTEG_147` | DEP083 |

---

## 9. Generators

O catálogo `RDB$GENERATORS` foi consultado diretamente no Firebird 2.0.

Foi encontrado **apenas um generator de usuário**:

| Generator | ID | System flag |
|---|---:|---:|
| `GEN_SEQ_BRADESCO` | 15 | 0 |

Não foram encontrados generators com nomes associados diretamente às PKs das tabelas críticas `DEP001`, `DEP011`, `DEP013`, `DEP021` ou `DEP022`.

Não se deve assumir que `GEN_SEQ_BRADESCO` esteja ligado a uma tabela específica sem validar seus usos no código do ERP.

---

## 10. Observações sobre tipos, nulidade e defaults

O inventário atual confirma nomes e ordem dos campos. O levantamento detalhado de tipos físicos (`VARCHAR`, `INTEGER`, `NUMERIC`, `DATE`, `TIMESTAMP`, `BLOB` etc.), tamanho, precisão, escala, nulidade, defaults e domínios ainda deve ser extraído do catálogo do Firebird.

Essa etapa é necessária antes da criação definitiva das tabelas correspondentes no PostgreSQL.

---

## 11. DEP001 — Produtos

**Função conhecida:** cadastro de produtos.

**Campos:** 43.

**PK:** `DEP001`.

A estrutura de campos foi confirmada no catálogo do Firebird. A descrição funcional campo a campo ainda deve ser validada.

---

## 12. DEP011 — Clientes

**Função conhecida:** cadastro de clientes.

**Campos:** 45.

**PK:** `DEP011`.

A estrutura física completa foi confirmada. A descrição funcional campo a campo ainda deve ser consolidada.

---

## 13. DEP013 — Vendedores

**Função conhecida:** cadastro de vendedores/representantes.

**Campos:** 9.

**PK:** `DEP013`.

Os campos `SENHA`, `SENHA_LIBERAR`, `SENHA_ACESSO` e `SENHA_DEFEITO` devem ser tratados como dados sensíveis e nunca expostos por APIs, frontend, relatórios ou integrações de IA.

---

## 14. DEP021 — Pedidos

**Função conhecida:** cabeçalho dos pedidos/documentos comerciais.

**Campos:** 42.

**PK:** `DEP021`.

Regra já utilizada pela automação de pedidos do projeto:

```text
TIPO = 'PED'
DATA = data atual
```

Essa regra é de aplicação e não constitui constraint do Firebird.

---

## 15. DEP022 — Itens dos pedidos

**Função conhecida:** itens que compõem os pedidos de `DEP021`.

**Campos:** 13.

**PK física:** `(DEP021, ITEM)`.

**Índice:** `RDB$PRIMARY17` sobre `(DEP021, ITEM)`.

`DEP021` e `DEP001` são relacionamentos lógicos conhecidos; nenhuma FK física foi encontrada.

---

## 16. Estratégia de sincronização Firebird → Supabase

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

## 17. Próximas etapas do levantamento

Com o inventário de campos, PKs, índices, FKs e generators levantados, as próximas etapas são:

1. Extrair tipos, tamanhos, precisão e escala de todos os 750 campos.
2. Extrair nulabilidade e defaults.
3. Levantar triggers e verificar se existem regras de negócio implementadas no banco.
4. Validar por amostragem os relacionamentos lógicos identificados.
5. Identificar os campos efetivamente utilizados na sincronização.
6. Definir a lista oficial de tabelas ERP que serão replicadas para `public`.
7. Criar o mapa definitivo **Firebird → PostgreSQL/Supabase**.
8. Só depois definir quais relacionamentos lógicos devem virar FKs no PostgreSQL.

---

## 18. Princípios documentais

- **Confirmado:** veio diretamente do Firebird ou de regra de negócio já validada.
- **Lógico:** relacionamento ou significado utilizado pela aplicação, sem constraint física correspondente.
- **Provável:** forte evidência estrutural, ainda pendente de validação por dados/código.
- **A confirmar:** ainda não há evidência suficiente.
- Não transformar hipótese em documentação definitiva.
- Não tratar tabelas de outros aplicativos como tabelas do ERP.
- Não alterar o Firebird durante o levantamento estrutural.
- A ausência de FK no Firebird não significa ausência de relacionamento no ERP.
- O PostgreSQL não deve receber FKs automaticamente apenas porque os nomes dos campos coincidem.
