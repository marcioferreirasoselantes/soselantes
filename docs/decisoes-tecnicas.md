# Decisões Técnicas

Registro das decisões relevantes do projeto.

## ADR-001 — GitHub como fonte oficial da documentação

**Status:** aprovado

A documentação técnica do projeto será mantida no GitHub, junto ao código e aos demais artefatos do sistema. A conversa com o assistente será utilizada para discussão, análise e evolução, mas as decisões consolidadas devem ser registradas no repositório.

## ADR-002 — Firebird como origem do ERP legado

**Status:** aprovado

O Firebird existente continua sendo a fonte operacional dos dados do ERP. A nova arquitetura não deve exigir alterações no banco de origem para funcionar.

## ADR-003 — Supabase/PostgreSQL como camada moderna

**Status:** aprovado

O Supabase será utilizado como camada de dados para novas aplicações, APIs, integrações e automações.

## ADR-004 — Não inventar estrutura de dados

**Status:** aprovado

Campos, tipos, chaves e relacionamentos do ERP somente serão considerados definitivos após validação no banco de origem. A documentação deve distinguir claramente informações confirmadas de hipóteses ou itens pendentes de levantamento.
