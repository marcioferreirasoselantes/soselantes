# Dicionário de Dados Físico — PostgreSQL / Supabase

**Versão:** 1.0  
**Data:** 11/08/2026  
**Status:** Snapshot estrutural do banco atual  
**Projeto:** Só Selantes

> Este documento descreve o que foi efetivamente encontrado no PostgreSQL/Supabase nesta data. Ele não substitui a validação da origem Firebird. Quando uma informação é apenas inferida pelo nome do campo, isso é indicado como **semântica a validar**.

---

## 1. Inventário atual

A inspeção de `information_schema` encontrou:

| Schema | Tabelas |
|---|---:|
| `public` | 72 |
| `soselantes` | 1 |

### Observação arquitetural importante

O `public` atualmente contém tanto tabelas do ERP quanto estruturas complementares criadas para o projeto. Isso confirma a necessidade de separar essas estruturas antes da próxima reconstrução limpa do `public`.

---

# 2. Tabelas núcleo do ERP

## 2.1 `public.dep001`

**Função:** cadastro de produtos.

| # | Campo | Tipo PostgreSQL | Nulo | Observação |
|---:|---|---|:---:|---|
| 1 | `DEP001` | integer | Não | Identificador do produto |
| 2 | `DESCRICAO` | varchar(100) | Sim | Descrição |
| 3 | `EAN` | varchar(15) | Sim | Código EAN |
| 4 | `REFERENCIA` | varchar(100) | Sim | Referência comercial |
| 5 | `DEP002` | integer | Sim | Referência a estrutura DEP002 |
| 6 | `DEP003` | integer | Sim | Referência a estrutura DEP003 |
| 7 | `DEP006` | integer | Sim | Referência a estrutura DEP006 |
| 8 | `CUSTO` | numeric(10,3) | Sim | Custo |
| 9 | `VENDA_VISTA` | numeric(10,3) | Sim | Preço à vista |
| 10 | `MARGEM` | numeric(10,2) | Sim | Margem |
| 11 | `VENDA_SUGESTAO` | numeric(10,2) | Sim | Preço sugerido |
| 12 | `SALDO` | numeric(10,2) | Sim | Saldo |
| 13 | `DEP007` | integer | Sim | Referência a estoque/movimentação |
| 14 | `DEP010` | integer | Sim | Referência a cadastro relacionado |
| 15 | `OBS` | varchar(500) | Sim | Observações |
| 16 | `DEP012` | integer | Sim | Classificação |
| 17 | `ATIVO` | varchar(1) | Sim | Indicador de ativo |
| 18 | `CAMINHO_FOTO` | varchar(500) | Sim | Caminho da foto |
| 19 | `DT_CADASTRO` | date | Sim | Cadastro |
| 20 | `USUARIO` | varchar(50) | Sim | Usuário |
| 21 | `ULTIMO_CUSTO` | numeric(10,2) | Sim | Último custo |
| 22 | `SALDO_ANT` | numeric(10,2) | Sim | Saldo anterior |
| 23 | `ULT_COMPRA` | date | Sim | Última compra |
| 24 | `ULT_VENDA` | date | Sim | Última venda |
| 25 | `CUSTO_MEDIO` | numeric(10,2) | Sim | Custo médio |
| 26 | `SALDO_MAX` | numeric(10,2) | Sim | Estoque máximo |
| 27 | `SALDO_MIN` | numeric(10,2) | Sim | Estoque mínimo |
| 28 | `PER_COMISSAO` | numeric(10,2) | Sim | Comissão |
| 29 | `DESCONTO_MAX` | numeric(10,2) | Sim | Desconto máximo |
| 30 | `ICMS` | integer | Sim | Fiscal — validar semântica |
| 31 | `SUBTR` | varchar(3) | Sim | Fiscal — validar semântica |
| 32 | `MOVIMENTO` | varchar(1) | Sim | Validar semântica |
| 33 | `STATUS` | varchar(1) | Sim | Status |
| 34 | `ULT_REAJ` | date | Sim | Último reajuste |
| 35 | `USUARIO_REAJ` | varchar(50) | Sim | Usuário do reajuste |
| 36 | `VENDA_ANT` | numeric(10,2) | Sim | Venda anterior |
| 37 | `IVA` | numeric(10,3) | Sim | Fiscal |
| 38 | `CLASS_FISCAL` | varchar(20) | Sim | Classificação fiscal |
| 39 | `INICIAL` | numeric(10,2) | Sim | Valor inicial |
| 40 | `COMPRA` | numeric(10,2) | Sim | Compra |
| 41 | `QTDE_CAIXA` | integer | Sim | Quantidade por caixa |
| 42 | `EXPEDICAO` | varchar(1) | Sim | Expedição |
| 43 | `GRUPO_COMISSAO` | integer | Sim | Grupo de comissão |

**Constraint física observada:** apenas `NOT NULL` em `DEP001`; não foi encontrada `PRIMARY KEY` nem `FOREIGN KEY` no snapshot atual.

---

## 2.2 `public.dep011`

**Função:** cadastro de clientes.

| # | Campo | Tipo PostgreSQL | Nulo |
|---:|---|---|:---:|
| 1 | `DEP011` | integer | Não |
| 2 | `RAZAOSOCIAL` | varchar(50) | Sim |
| 3 | `FANTASIA` | varchar(30) | Sim |
| 4 | `ENDERECO` | varchar(50) | Sim |
| 5 | `COMPLEMENTO` | varchar(40) | Sim |
| 6 | `BAIRRO` | varchar(30) | Sim |
| 7 | `UF` | varchar(2) | Sim |
| 8 | `CIDADE` | varchar(50) | Sim |
| 9 | `CEP` | varchar(15) | Sim |
| 10 | `CGC_CPF` | varchar(40) | Sim |
| 11 | `INSCRICAO` | varchar(40) | Sim |
| 12 | `TELEFONE` | varchar(20) | Sim |
| 13 | `FAX` | varchar(20) | Sim |
| 14 | `CELULAR` | varchar(20) | Sim |
| 15 | `EMAIL` | varchar(50) | Sim |
| 16 | `SITUACAO` | integer | Sim |
| 17 | `DATA_NASC` | date | Sim |
| 18 | `TIPO` | varchar(1) | Sim |
| 19 | `OBS` | varchar(100) | Sim |
| 20 | `DT_CADASTRO` | date | Sim |
| 21 | `USUARIO` | varchar(50) | Sim |
| 22 | `FONE2` | varchar(20) | Sim |
| 23 | `FILIAL` | varchar(2) | Sim |
| 24 | `CONTATO` | varchar(100) | Sim |
| 25 | `ENDERECOC` | varchar(50) | Sim |
| 26 | `CIDADEC` | varchar(50) | Sim |
| 27 | `UFC` | varchar(2) | Sim |
| 28 | `BAIRROC` | varchar(30) | Sim |
| 29 | `CEPC` | varchar(20) | Sim |
| 30 | `FONEC` | varchar(20) | Sim |
| 31 | `FAXC` | varchar(20) | Sim |
| 32 | `OBS2` | varchar(100) | Sim |
| 33 | `AVISO1` | varchar(45) | Sim |
| 34 | `AVISO2` | varchar(45) | Sim |
| 35 | `AVISO3` | varchar(45) | Sim |
| 36 | `AVISO4` | varchar(45) | Sim |
| 37 | `AVISO5` | varchar(45) | Sim |
| 38 | `ULT_COMPRA` | date | Sim |
| 39 | `DEP016` | integer | Sim |
| 40 | `LIMITE` | numeric(10,2) | Sim |
| 41 | `DATA_CONSULTA` | date | Sim |
| 42 | `DEP013` | integer | Sim |
| 43 | `DEP049` | integer | Sim |
| 44 | `DEP065` | integer | Sim |
| 45 | `NF_IMPRESSA` | varchar(1) | Sim |

**Constraint física observada:** `DEP011` é `NOT NULL`; não foi encontrada PK/FK física.

---

## 2.3 `public.dep013`

**Função:** cadastro de vendedores/usuários comerciais.

| Campo | Tipo | Nulo | Observação |
|---|---|:---:|---|
| `DEP013` | integer | Não | Identificador |
| `NOME_LOGIN` | varchar(30) | Sim | Login |
| `NOME_COMPLETO` | varchar(50) | Sim | Nome |
| `SENHA` | varchar(20) | Sim | **Sensível** |
| `ATIVO` | varchar(1) | Sim | Ativo |
| `PER_COMISSAO` | numeric(10,2) | Sim | Comissão |
| `SENHA_LIBERAR` | varchar(20) | Sim | **Sensível** |
| `SENHA_ACESSO` | varchar(20) | Sim | **Sensível** |
| `SENHA_DEFEITO` | varchar(20) | Sim | **Sensível** |

**Segurança:** campos de senha/credencial não devem ser expostos por API, frontend, logs ou IA.

---

## 2.4 `public.dep021`

**Função:** cabeçalho de pedidos/documentos comerciais.

| # | Campo | Tipo PostgreSQL | Nulo |
|---:|---|---|:---:|
| 1 | `DEP021` | integer | Não |
| 2 | `DATA` | date | Sim |
| 3 | `HORA` | time | Sim |
| 4 | `TIPO` | varchar(3) | Sim |
| 5 | `DEP011` | integer | Sim |
| 6 | `NOME` | varchar(50) | Sim |
| 7 | `CONDICAO_PGTO` | varchar(100) | Sim |
| 8 | `TOTAL` | numeric(10,2) | Sim |
| 9 | `DEP013` | integer | Sim |
| 10 | `VALOR_PAGO` | numeric(10,2) | Sim |
| 11 | `DATA_PGTO` | date | Sim |
| 12 | `PAGO` | varchar(1) | Sim |
| 13 | `TOTAL_PRODUTOS` | numeric(10,2) | Sim |
| 14 | `TOTAL_DEVOL` | numeric(10,2) | Sim |
| 15 | `OBS` | varchar(500) | Sim |
| 16 | `QTDE_IMP` | integer | Sim |
| 17 | `NOTA` | integer | Sim |
| 18 | `DESCONTO` | numeric(10,2) | Sim |
| 19 | `PRAZO_ENTREGA` | varchar(100) | Sim |
| 20 | `VALIDADE` | varchar(50) | Sim |
| 21 | `PRAZO_PGTO` | varchar(50) | Sim |
| 22 | `USUARIO_LIBEROU` | varchar(100) | Sim |
| 23 | `LIBERACAO_CADASTRO` | varchar(40) | Sim |
| 24 | `MOTIVO_CADASTRO` | varchar(500) | Sim |
| 25 | `DATANOTA2` | date | Sim |
| 26 | `BAIXA_EMP` | varchar(80) | Sim |
| 27 | `OBS_BAIXA` | varchar(500) | Sim |
| 28 | `DEP013_USER` | integer | Sim |
| 29 | `PENDENTE` | varchar(1) | Sim |
| 30 | `FRETE` | numeric(10,2) | Sim |
| 31 | `LOCAL` | varchar(1) | Sim |
| 32 | `ORIGEM` | varchar(20) | Sim |
| 33 | `DEP075` | integer | Sim |
| 34 | `DATA_ENTREGA` | date | Sim |
| 35 | `DATA_DEV` | date | Sim |
| 36 | `OBS_ENTREGA` | varchar(500) | Sim |
| 37 | `OBS_DEV` | varchar(500) | Sim |
| 38 | `QTDE_VOL` | numeric(10,2) | Sim |
| 39 | `FATURADO` | varchar(1) | Sim |
| 40 | `DEP009` | integer | Sim |
| 41 | `EXPEDICAO` | varchar(1) | Sim |
| 42 | `PRONTA_ENTREGA` | varchar(1) | Sim |

**Regra operacional conhecida:** para a automação de pedidos do dia, utiliza-se `TIPO = 'PED'` e `DATA = data atual`.

**Constraint física observada:** `DEP021` é `NOT NULL`; não foi encontrada PK/FK física.

---

## 2.5 `public.dep022`

**Função:** itens dos pedidos.

| # | Campo | Tipo PostgreSQL | Nulo |
|---:|---|---|:---:|
| 1 | `DEP021` | integer | Não |
| 2 | `ITEM` | integer | Não |
| 3 | `DEP001` | integer | Sim |
| 4 | `DEP002` | integer | Sim |
| 5 | `DESCONTO` | numeric(10,2) | Sim |
| 6 | `QUANTIDADE` | numeric(10,3) | Sim |
| 7 | `UNITARIO` | numeric(10,3) | Sim |
| 8 | `TOTAL` | numeric(10,2) | Sim |
| 9 | `UNIDADE` | varchar(10) | Sim |
| 10 | `VLR_VISTA` | numeric(10,3) | Sim |
| 11 | `CUSTO` | numeric(10,3) | Sim |
| 12 | `TIPO` | varchar(1) | Sim |
| 13 | `DESCRICAO` | varchar(200) | Sim |

**Identificador funcional:** `(DEP021, ITEM)`.

**Constraint física observada:** ambos são `NOT NULL`, mas não existe PK física no snapshot atual.

---

# 3. Estruturas fiscais relevantes

## `public.dep043` — Cabeçalho de nota

Campos observados incluem `nota`, `serie`, `emissao`, `saida`, `dep011`, `tipo`, `total_produtos`, `total_nota`, `cancelada`, `dep041`, `condicao`, `motivo_canc`, `dt_liquidado` e `vlr_frete`.

## `public.dep044` — Itens de nota

Campos observados incluem `nota`, `serie`, `item`, `dep001`, `descricao`, `qtde`, `unitario`, `total`, `icms`, `ipi`, `st`, `custo`, `venda` e `sigla_cfop`.

Essas tabelas reforçam a separação conceitual entre **pedido** e **faturamento fiscal**.

---

# 4. Estruturas financeiras relevantes

- `dep033` — contas/duplicatas a receber;
- `dep040` — parcelas/contas relacionadas a pedidos e notas;
- `dep047` — recebimentos;
- `dep048` — associação entre recebimentos e pedidos;
- `dep080` — estrutura financeira semelhante à `dep040`.

Os significados detalhados dos campos financeiros ainda devem ser validados com o ERP.

---

# 5. Estruturas de estoque

Entre as estruturas físicas observadas:

- `dep007` — produto/data/hora/quantidade;
- `dep014` — movimentação de produto;
- `dep023` — saldos/movimentações mensais;
- `dep024` — movimentos de estoque;
- `dep062` — balanço por período/produto;
- `dep066` — cadastro/controle de estoque;
- `dep067`, `dep068`, `dep069`, `dep070` — estruturas complementares de estoque/custos.

---

# 6. Estruturas de comunicação

O snapshot também contém `dep063` e `dep064`, com campos como `mensagem`, `usuario`, `feito`, `dep011`, `tipo` e `data_retorno`.

Essas estruturas precisam ser analisadas antes de criar qualquer integração paralela de WhatsApp, para evitar duplicidade de responsabilidade com as tabelas/rotinas que serão criadas pelo projeto.

---

# 7. Estruturas complementares atualmente no `public`

Foram encontradas no `public`:

- `cidades_info`
- `metas_mensais`
- `metas_vendedores`
- `staging_cidade_coords`
- `staging_cidade_regiao`
- `vendedores_filhos`
- `vendedores_pais`

Essas estruturas são complementares ao ERP e deverão ser reclassificadas antes da próxima reconstrução limpa do `public`.

---

# 8. Schema `soselantes`

Existe atualmente uma tabela:

## `soselantes.produto_referencia_historica`

| Campo | Tipo | Nulo | Default |
|---|---|:---:|---|
| `prefixo_historico` | text | Não | — |
| `referencia_atual` | text | Não | — |
| `observacao` | text | Sim | — |
| `created_at` | timestamptz | Não | `now()` |
| `updated_at` | timestamptz | Não | `now()` |

**PK física:** `prefixo_historico`.

Essa tabela deve permanecer fora da camada bruta do ERP.

---

# 9. Constraints e chaves

A inspeção atual do PostgreSQL encontrou principalmente constraints de `NOT NULL`.

Foram encontradas PKs físicas nas estruturas complementares, incluindo:

- `cidades_info(cod_ibge)`;
- `metas_mensais(cod_ibge, anomes)`;
- `staging_cidade_coords(cod_ibge)`;
- `staging_cidade_regiao(cod_ibge)`;
- `soselantes.produto_referencia_historica(prefixo_historico)`.

**Não foram encontradas foreign keys físicas nas tabelas centrais do ERP (`dep001`, `dep011`, `dep013`, `dep021`, `dep022`) no snapshot atual.**

Isso é importante: os relacionamentos entre essas tabelas são conhecidos funcionalmente, mas atualmente não estão garantidos por constraints relacionais no PostgreSQL.

---

# 10. Consequência para a sincronização

A ausência de FKs físicas significa que a rotina de sincronização não pode depender do PostgreSQL para garantir a integridade entre `dep021`, `dep022`, `dep011`, `dep013` e `dep001`.

A rotina deverá validar explicitamente:

- existência do cliente referenciado pelo pedido;
- existência do vendedor;
- existência do produto de cada item;
- existência do pedido para cada item;
- duplicidade de chaves funcionais;
- registros órfãos.

Isso deverá entrar na bateria de testes da sincronização Firebird → Supabase.

---

# 11. Próxima etapa

O próximo levantamento deve confrontar este snapshot com a **estrutura real do Firebird**, obtendo:

1. tipos originais;
2. PKs;
3. FKs;
4. índices;
5. generators/sequences;
6. triggers;
7. domínios;
8. constraints;
9. valores codificados dos campos de status/tipo;
10. regras de negócio implementadas no ERP.

Após essa etapa, o `dicionario-dados.md` poderá ser promovido de **base técnica inicial** para **referência estrutural oficial**.

---

# 12. Histórico

| Versão | Data | Alteração |
|---|---|---|
| 1.0 | 11/08/2026 | Primeiro snapshot físico do PostgreSQL/Supabase, incluindo tabelas núcleo, campos, tipos, nulabilidade, constraints e separação entre ERP e estruturas complementares |
