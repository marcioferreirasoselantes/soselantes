# Só Selantes

Projeto de evolução da plataforma comercial e de dados da Só Selantes.

## Objetivo

Centralizar no GitHub o código, a documentação técnica, as decisões de arquitetura e os artefatos relacionados à evolução dos sistemas da Só Selantes.

## Documentação

- [Arquitetura de Dados](docs/arquitetura-dados.md)
- [Dicionário de Dados](docs/dicionario-dados.md)
- [Sincronização Firebird](docs/sincronizacao-firebird.md)
- [Decisões Técnicas](docs/decisoes-tecnicas.md)
- [Banco de Dados](database/README.md)

## Princípios

1. O Firebird do ERP é a origem operacional dos dados legados.
2. O Supabase/PostgreSQL é a camada de dados destinada às novas aplicações, integrações e automações.
3. A sincronização deve ser controlada, incremental e auditável.
4. O banco de origem não deve ser alterado pela rotina de sincronização.
5. A documentação técnica deve evoluir junto com o sistema.

## Status

Em construção. A primeira fase está concentrada na consolidação da arquitetura de dados e na documentação da sincronização Firebird → Supabase.
