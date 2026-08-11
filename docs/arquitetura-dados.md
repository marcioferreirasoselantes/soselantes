# Arquitetura de Dados

## 1. Visão geral

A arquitetura de dados do projeto Só Selantes foi concebida para preservar o ERP existente e, ao mesmo tempo, criar uma base moderna para novas aplicações, integrações e automações.

```text
ERP / Firebird
      │
      │ sincronização controlada
      ▼
Supabase / PostgreSQL
      │
      ├── Aplicações
      ├── APIs
      ├── Automações / n8n
      └── Inteligência Comercial
```

## 2. Sistema de origem

O ERP atual utiliza banco Firebird. Entre as tabelas já identificadas estão:

- `DEP011` — clientes
- `DEP013` — vendedores
- `DEP021` — pedidos
- `DEP022` — itens dos pedidos

Os nomes acima representam a estrutura existente no ERP e devem ser tratados como fonte legada até que exista uma decisão formal de remodelagem.

## 3. Camada de dados moderna

O Supabase utiliza PostgreSQL e será a camada de dados para as novas soluções. A tendência é manter no schema `public` uma estrutura organizada, documentada e independente das limitações de nomenclatura do ERP legado.

## 4. Princípio de sincronização

A sincronização deve transportar os dados necessários do Firebird para o Supabase sem alterar o banco de origem. Deve ser possível executar a rotina de forma recorrente e incremental, evitando cargas desnecessárias.

## 5. Auditabilidade

Processos de sincronização e integrações devem possuir mecanismos de controle de execução, registro de erros e possibilidade de identificar quando um registro foi criado ou atualizado na origem.

## 6. Evolução

Esta documentação é viva. Alterações de arquitetura, novas tabelas, regras de sincronização e decisões importantes devem ser registradas aqui e em `docs/decisoes-tecnicas.md`.
