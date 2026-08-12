# Classificação das Tabelas do Firebird

**Versão:** 1.0  
**Data:** 12/08/2026  
**Banco:** `C:\Logic\Bancos\DEPOSITO.FDB`  
**Servidor:** Firebird 2.0  
**Status:** classificação inicial validada

---

## 1. Objetivo

Este documento define quais estruturas existentes no `DEPOSITO.FDB` pertencem ao ERP e quais foram criadas posteriormente para outros aplicativos/projetos.

A classificação é importante porque **a existência de uma tabela no arquivo Firebird não significa que ela deva ser sincronizada para o Supabase como parte do ERP**.

---

## 2. Fonte da classificação

A lista de tabelas foi obtida diretamente da conexão com o Firebird de produção utilizando `SHOW TABLES`.

A conexão validada foi:

```text
soselantes.ddns.net:3050
C:\Logic\Bancos\DEPOSITO.FDB
```

O servidor ativo identificado na máquina é o Firebird 2.0.

---

## 3. Classificação oficial atual

### 3.1 ERP — tabelas `DEPxxx`

As tabelas que seguem o padrão `DEPxxx` são, neste momento, classificadas como **estruturas do ERP**.

Lista encontrada no Firebird:

```text
DEP001
DEP002
DEP003
DEP006
DEP007
DEP009
DEP010
DEP011
DEP012
DEP013
DEP014
DEP016
DEP017
DEP018
DEP019
DEP020
DEP021
DEP022
DEP023
DEP024
DEP025
DEP026
DEP027
DEP028
DEP031
DEP032
DEP033
DEP034
DEP035
DEP036
DEP037
DEP039
DEP040
DEP041
DEP042
DEP043
DEP044
DEP045
DEP046
DEP047
DEP048
DEP049
DEP052
DEP056
DEP057
DEP059
DEP060
DEP061
DEP062
DEP063
DEP064
DEP065
DEP066
DEP067
DEP068
DEP069
DEP070
DEP071
DEP072
DEP073
DEP074
DEP075
DEP080
DEP083
```

**Quantidade:** 65 tabelas `DEPxxx`.

> A classificação como ERP não significa que todas essas tabelas já tenham seu significado funcional documentado. A função detalhada de cada tabela será levantada progressivamente a partir dos metadados e da análise do conteúdo.

---

## 4. DUAL

```text
DUAL
```

### Classificação

**Técnica / compatibilidade do banco.**

Não é uma entidade comercial do ERP e não deve ser tratada como tabela de negócio.

Sua presença não deve ser usada para medir a quantidade de entidades do ERP.

---

## 5. Tabelas criadas pelo projeto/usuário para outro aplicativo

As seguintes tabelas foram explicitamente identificadas pelo responsável pelo sistema como **não pertencentes ao ERP**:

```text
METAS_VENDEDORES
VENDEDORES_FILHOS
VENDEDORES_PAIS
```

### Classificação

**Customizações / outro aplicativo.**

Essas tabelas foram criadas para um aplicativo diferente do projeto de sincronização do ERP.

### Regra

Elas:

- não devem ser consideradas parte da cópia bruta do ERP;
- não devem entrar automaticamente na sincronização Firebird → `public`;
- não devem ser apagadas do Firebird durante a reconstrução da base;
- devem permanecer preservadas caso o outro aplicativo ainda dependa delas;
- somente devem ser migradas para o Supabase se houver uma decisão específica para isso.

---

## 6. Inventário resumido

| Categoria | Quantidade | Tabelas |
|---|---:|---|
| ERP | 65 | `DEPxxx` |
| Técnica | 1 | `DUAL` |
| Outro aplicativo/customização | 3 | `METAS_VENDEDORES`, `VENDEDORES_FILHOS`, `VENDEDORES_PAIS` |
| **Total** | **69** | estruturas listadas pelo `SHOW TABLES` |

> A quantidade acima corresponde à lista obtida no `SHOW TABLES` apresentada durante a auditoria. Antes da reconstrução definitiva, o inventário físico será novamente extraído por consulta às tabelas de sistema do Firebird para eliminar qualquer divergência de contagem.

---

## 7. Regra para a futura sincronização

A rotina de sincronização deverá trabalhar com uma **lista explícita de tabelas de origem**, e não com uma regra genérica como:

```text
sincronizar todas as tabelas do Firebird
```

A regra recomendada é:

```text
Firebird
   │
   ├── DEPxxx ───────────────► Supabase / public
   │
   ├── DUAL ─────────────────► não sincronizar como entidade de negócio
   │
   └── tabelas de outros apps ► fora da sincronização ERP
```

Isso evita que uma tabela criada posteriormente no Firebird seja automaticamente incorporada ao banco do projeto.

---

## 8. Regra para novas tabelas

Se uma nova tabela for criada futuramente no Firebird, ela **não deve entrar automaticamente no Supabase**.

Antes de incluí-la na sincronização, devemos registrar:

1. nome da tabela;
2. origem;
3. responsável pela criação;
4. finalidade;
5. se pertence ao ERP;
6. se pertence a outro aplicativo;
7. se deve ser sincronizada;
8. schema de destino no Supabase.

---

## 9. Próxima etapa da auditoria

A classificação acima está suficientemente definida para impedir que as três tabelas customizadas sejam confundidas com o ERP.

A próxima etapa é extrair diretamente do Firebird, para as **65 tabelas `DEPxxx`**:

- campos;
- tipos;
- tamanhos;
- precisão e escala;
- nulabilidade;
- defaults;
- chaves primárias;
- chaves estrangeiras;
- índices;
- generators;
- triggers.

Depois, comparar esse inventário com o Supabase e produzir o plano de reconstrução do schema `public`.

---

## 10. Regra de segurança

Nenhuma alteração estrutural ou de dados deve ser feita no `DEPOSITO.FDB` durante esta etapa.

A auditoria atual é **somente leitura**.

---

## 11. Histórico

| Versão | Data | Alteração |
|---|---|---|
| 1.0 | 12/08/2026 | Classificação das tabelas do Firebird com confirmação explícita de que `METAS_VENDEDORES`, `VENDEDORES_FILHOS` e `VENDEDORES_PAIS` pertencem a outro aplicativo e não ao ERP |
