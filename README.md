# Só Selantes

Projeto de evolução da plataforma comercial, de dados e digital da Só Selantes.

## Objetivo

Centralizar no GitHub o código, a documentação técnica, as decisões de arquitetura, os dados-modelo e os artefatos relacionados à evolução dos sistemas da Só Selantes.

## Documentação

### Arquitetura e dados

- [Arquitetura de Dados](docs/arquitetura-dados.md)
- [Dicionário de Dados](docs/dicionario-dados.md)
- [Sincronização Firebird](docs/sincronizacao-firebird.md)
- [Integrações](docs/integracoes.md)
- [Decisões Técnicas](docs/decisoes-tecnicas.md)
- [Banco de Dados](database/README.md)

### Negócio e produto

- [Escopo do Projeto](docs/escopo-projeto.md)
- [Inteligência Comercial](docs/inteligencia-comercial.md)
- [Site Só Selantes](docs/site-soselantes.md)
- [Roadmap](docs/roadmap.md)

## Princípios

1. O Firebird do ERP é a origem operacional dos dados legados.
2. O Supabase/PostgreSQL é a camada de dados destinada às novas aplicações, integrações e automações.
3. A sincronização deve ser controlada, incremental e auditável.
4. O banco de origem não deve ser alterado pela rotina de sincronização.
5. A documentação técnica deve evoluir junto com o sistema.
6. Segredos, tokens e credenciais nunca devem ser versionados.
7. Informações não confirmadas no banco ou nos documentos oficiais devem ser marcadas como pendentes de validação.

## Status

Fundação documental em andamento. O próximo marco técnico é o levantamento do schema real do Firebird e sua tradução para o modelo do Supabase.
