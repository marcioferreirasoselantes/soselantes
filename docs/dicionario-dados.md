# Dicionário de Dados — Só Selantes

**Versão:** 1.0  
**Data:** 11/08/2026  
**Status:** Base técnica inicial  
**Banco de destino:** Supabase / PostgreSQL  
**Origem principal:** ERP Firebird

---

## 1. Objetivo

Este documento é a referência técnica inicial para o dicionário de dados do projeto Só Selantes.

Ele registra a estrutura conhecida do ERP, as principais entidades comerciais, regras semânticas já validadas e a separação entre dados brutos do ERP e dados complementares criados pelo projeto.

> **Regra documental:** quando o significado de um campo, chave ou relacionamento ainda não tiver sido confirmado no Firebird, ele deve permanecer explicitamente como hipótese/pendência de validação. Não devemos inventar estrutura.

---

## 2. Arquitetura de dados

A arquitetura definida para o projeto separa os dados em duas camadas:

### `public`

Deve representar a **cópia do ERP Firebird** no PostgreSQL/Supabase.

Princípios:

- origem Firebird;
- estrutura próxima à origem;
- nomes das tabelas padronizados para minúsculas no PostgreSQL;
- pode ser apagado e recopiado quando for necessário reconstruir a base do ERP;
- não deve receber permanentemente regras ou dados exclusivos do projeto.

### `soselantes`

Deve representar a **camada complementar de negócio e inteligência**.

Deve concentrar:

- equivalências históricas;
- enriquecimentos;
- classificações;
- metas;
- regras de negócio;
- dados complementares;
- estruturas produzidas pelo projeto.

Isso permite reconstruir o `public` sem perder informações próprias do projeto.

---

## 3. Principais entidades do ERP

| Tabela | Função conhecida | Importância |
|---|---|---:|
| `DEP001` | Produtos | Alta |
| `DEP011` | Clientes | Alta |
| `DEP013` | Vendedores/representantes | Alta |
| `DEP021` | Cabeçalho dos pedidos | Crítica |
| `DEP022` | Itens dos pedidos | Crítica |

Essas cinco tabelas formam o núcleo inicial para as análises comerciais e para a futura rotina de sincronização.

---

## 4. Modelo conceitual principal

```text
DEP013
  │ vendedor
  ▼
DEP021 ───────────► DEP011
 pedido              cliente
  │
  │ itens
  ▼
DEP022 ───────────► DEP001
                     produto
```

Relacionamentos funcionais conhecidos:

- `DEP021.DEP011` → cliente `DEP011.DEP011`;
- `DEP021.DEP013` → vendedor `DEP013.DEP013`;
- `DEP022.DEP021` → pedido `DEP021.DEP021`;
- `DEP022.DEP001` → produto `DEP001.DEP001`.

> Esses são relacionamentos funcionais/conceituais conhecidos. A existência de `FOREIGN KEY` física no PostgreSQL ou no Firebird ainda deve ser confirmada.

---

# 5. DEP001 — Produtos

**Função:** cadastro mestre de produtos.

**Uso no projeto:** análise de portfólio, vendas por produto, preços, custos e normalização histórica.

A estrutura detalhada de campos e tipos deve ser confirmada diretamente no Firebird antes de ser considerada definitiva.

### Regra de referência e cor

Foi definida a seguinte regra comercial para referências com hífen:

```text
SSAC-1
SSAC-2
SSAC-3
```

Os caracteres antes de `-` representam o produto-base e a parte numérica posterior representa a cor.

Portanto, para análises de produto:

> **Cor não deve ser tratada como produto independente.**

Existem referências sem hífen que podem conter cor. Essas exceções precisam ser explicitamente validadas e não devem ser inferidas automaticamente.

---

# 6. DEP011 — Clientes

**Função:** cadastro de clientes do ERP.

Campos e tipos completos ainda devem ser levantados diretamente no Firebird.

Informações conhecidas/esperadas incluem:

- identificador do cliente;
- razão social;
- nome fantasia;
- endereço;
- cidade/UF;
- CEP;
- CNPJ/CPF;
- telefones;
- e-mail;
- situação cadastral;
- vendedor relacionado;
- limite de crédito;
- datas de cadastro e última compra.

> A lista acima é uma descrição funcional das informações conhecidas e não deve ser interpretada como inventário definitivo de colunas.

---

# 7. DEP013 — Vendedores

**Função:** cadastro de vendedores/representantes do ERP.

Informações conhecidas/esperadas incluem:

- identificador do vendedor;
- login;
- nome completo;
- situação/ativo;
- percentual de comissão.

### Segurança

A estrutura histórica do ERP possui campos associados a credenciais/senhas. Esses campos devem ser tratados como **dados sensíveis** e não devem ser expostos por APIs, frontend, relatórios ou integrações de IA.

---

# 8. DEP021 — Pedidos

**Função:** cabeçalho dos pedidos/documentos comerciais.

**Importância:** crítica.

A rotina de notificações e integrações já identificou como regra relevante:

```text
TIPO = 'PED'
DATA = data atual
```

Essa condição é usada para localizar os pedidos do dia destinados à automação de comunicação.

### Informações conhecidas/esperadas

- identificador do pedido;
- data e hora;
- tipo do documento;
- cliente;
- vendedor;
- condição/prazo de pagamento;
- total;
- total de produtos;
- desconto;
- frete;
- observações;
- situação de faturamento/expedição;
- data de entrega;
- informações de baixa/devolução.

> `DEP021` representa o pedido/documento comercial. Não devemos assumir que `DEP021.TOTAL` seja, isoladamente, o faturamento fiscal líquido da empresa.

---

# 9. DEP022 — Itens dos pedidos

**Função:** itens que compõem os pedidos de `DEP021`.

**Importância:** crítica.

Relaciona o pedido ao produto e contém as informações comerciais do item.

Informações conhecidas/esperadas:

- pedido;
- número/sequência do item;
- produto;
- quantidade;
- unidade;
- preço unitário;
- desconto;
- total;
- custo;
- descrição do item.

### Identificador funcional

O par abaixo é tratado como identificador funcional do item:

```text
(DEP021, ITEM)
```

A confirmação da chave física deve ser feita diretamente na origem.

---

# 10. Outras estruturas do ERP

O banco possui outras tabelas `DEPxxx` relacionadas a cadastro, estoque, documentos fiscais, financeiro e logística.

Entre as estruturas já identificadas no projeto estão:

| Grupo | Tabelas/estruturas conhecidas |
|---|---|
| Cadastros/classificações | `DEP002`, `DEP003`, `DEP006`, `DEP009`, `DEP010`, `DEP012`, `DEP016`, `DEP017`, `DEP018`, `DEP034`, `DEP035`, `DEP037`, `DEP041`, `DEP049`, `DEP065`, `DEP073`, `DEP074` |
| Estoque/movimentação | `DEP007`, `DEP014`, `DEP023`, `DEP024`, `DEP062`, `DEP066`, `DEP067`, `DEP068`, `DEP069`, `DEP070` |
| Pedidos/documentos fiscais | `DEP019`, `DEP021`, `DEP022`, `DEP025`, `DEP026`, `DEP031`, `DEP032`, `DEP043`, `DEP044`, `DEP045`, `DEP046`, `DEP048`, `DEP060`, `DEP061`, `DEP080`, `DEP083` |
| Financeiro | `DEP027`, `DEP028`, `DEP033`, `DEP036`, `DEP039`, `DEP040`, `DEP047`, `DEP057`, `DEP059`, `DEP080` |
| Logística | `DEP075`, `DEP083` |

A função detalhada dessas tabelas deve ser validada conforme forem incorporadas às análises do projeto.

---

# 11. Dados complementares do projeto

Algumas estruturas já utilizadas durante o desenvolvimento não pertencem ao ERP e devem ser tratadas como complementares.

Exemplos identificados anteriormente:

- `cidades_info` — enriquecimento geográfico/comercial;
- `metas_mensais` — metas comerciais por cidade/período;
- `metas_vendedores` — metas por vendedor;
- `staging_cidade_coords` — staging de coordenadas;
- `staging_cidade_regiao` — staging de classificação regional;
- `vendedores_filhos` — hierarquia comercial;
- `vendedores_pais` — dados complementares de comunicação/hierarquia.

### Regra arquitetural

Essas estruturas não devem ser consideradas parte da cópia bruta do ERP.

Quando o `public` for reconstruído integralmente a partir do Firebird, estruturas complementares devem permanecer/migrar para o schema `soselantes` quando fizerem parte definitiva da aplicação.

---

# 12. Produto e equivalências históricas

O projeto possui uma camada específica para equivalências entre referências históricas e atuais.

Tabela:

```text
soselantes.produto_referencia_historica
```

### Regra fundamental

Somente equivalências **explicitamente validadas** podem ser usadas para consolidar produtos históricos.

Não inferir equivalência apenas por:

- nome parecido;
- prefixo semelhante;
- descrição;
- embalagem;
- aplicação presumida.

### Equivalências já validadas

| Referência histórica | Referência atual |
|---|---|
| `SS10` | `DM40` |
| `SSUG` | `DOT40` |
| `PXP` | `DOT40` |
| `PMX` | `DOT40` |

---

# 13. Pedido, faturamento e devolução

Esses conceitos devem permanecer separados.

- **Pedido:** estrutura comercial, principalmente `DEP021` + `DEP022`.
- **Faturamento fiscal:** deve ser analisado nas estruturas de notas/documentos fiscais do ERP, como `DEP043`/`DEP044` e demais tabelas relacionadas.
- **Devolução:** deve considerar as estruturas e regras específicas do ERP.

Não utilizar simplesmente o total de pedidos como sinônimo de faturamento fiscal sem validar a regra de negócio.

---

# 14. Cliente e geografia

O cadastro de clientes contém cidade e UF, mas o projeto também utiliza estruturas complementares com código IBGE.

Para análises geográficas robustas, o modelo futuro deverá possuir uma camada de normalização que associe o cadastro comercial ao código IBGE.

Isso será importante para:

- metas por cidade;
- potencial de mercado;
- análise de crescimento;
- distribuição territorial;
- DDD;
- regiões comerciais.

---

# 15. Dados sensíveis

A base pode conter:

- CNPJ/CPF;
- telefones;
- e-mails;
- informações financeiras;
- credenciais/senhas do ERP.

Esses dados devem receber tratamento apropriado durante sincronização, APIs, logs, relatórios e integrações com IA.

Campos de credenciais nunca devem ser disponibilizados para frontend ou endpoints públicos.

---

# 16. Estratégia de sincronização

A arquitetura de referência é:

```text
ERP Firebird
    │
    ▼
Extração
    │
    ▼
Supabase / public
    │
    ├── dados brutos do ERP
    └── sem regras complementares permanentes

Supabase / soselantes
    │
    ├── equivalências
    ├── enriquecimentos
    ├── classificações
    ├── metas
    └── inteligência comercial
```

### Nova cópia limpa

Quando a estrutura do ERP for recopiada:

1. validar a origem Firebird;
2. limpar/recriar o conteúdo destinado ao `public`;
3. importar estrutura e dados;
4. validar quantidade de tabelas;
5. validar quantidade de registros;
6. validar tabelas críticas;
7. validar campos críticos;
8. verificar relacionamentos funcionais;
9. executar testes de consistência;
10. só então reativar as rotinas dependentes.

O schema `soselantes` deve ser preservado.

---

# 17. Próxima etapa: dicionário físico definitivo

Depois da nova cópia limpa do Firebird, o dicionário deverá evoluir para uma matriz completa contendo, para cada campo:

| Informação | Exemplo |
|---|---|
| Tabela | `DEP021` |
| Campo Firebird | `DEP021` |
| Campo PostgreSQL | `dep021` |
| Tipo Firebird | `INTEGER` |
| Tipo PostgreSQL | `integer` |
| Nulo | Sim/Não |
| Default | valor/default |
| PK | Sim/Não |
| FK | tabela/campo |
| Índice | nome do índice |
| Descrição | significado funcional |
| Regra | regra de negócio |
| Observação | pendência/particularidade |

Essa etapa deve ser gerada a partir da estrutura real, e não por inferência manual.

---

# 18. Pendências de validação

Ainda precisam ser confirmados diretamente no Firebird:

- tipos originais de todos os campos;
- chaves primárias;
- chaves estrangeiras;
- índices;
- triggers;
- generators/sequences;
- constraints;
- domínios;
- valores possíveis dos campos de status;
- códigos possíveis de `TIPO`;
- regras de cancelamento;
- regras de devolução;
- regras de faturamento;
- regras de cálculo de desconto;
- regras de frete;
- regras de comissão;
- relacionamento completo com cidades;
- relacionamento entre pedidos e notas.

Esses itens ficam explicitamente marcados como **VALIDAR** até que a origem seja inspecionada.

---

# 19. Classificação documental

### DECIDIDO

- `public` representa a cópia do ERP.
- `soselantes` representa dados complementares do projeto.
- Dados complementares não devem depender de alterações permanentes no `public`.
- Equivalências históricas só são válidas quando explicitamente confirmadas.
- Cor não deve ser tratada como produto independente nas análises de produto.

### VALIDAR

- Chaves e constraints físicas.
- Tipos originais Firebird.
- Significado detalhado de campos ainda não confirmados.
- Mapeamento completo Firebird → PostgreSQL.
- Separação definitiva entre pedido, faturamento e devolução.

---

# 20. Documentos relacionados

```text
docs/arquitetura-dados.md
docs/sincronizacao-firebird.md
```

Este documento deve ser atualizado sempre que uma nova estrutura ou regra de dados for validada.

---

# 21. Histórico de versões

| Versão | Data | Alteração |
|---|---|---|
| 1.0 | 11/08/2026 | Criação/atualização do dicionário técnico, consolidando entidades principais, arquitetura `public`/`soselantes`, regras já validadas e pendências de confirmação no Firebird |
