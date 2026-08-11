# Integrações

## Objetivo

Documentar as integrações externas do ecossistema Só Selantes e evitar que regras importantes fiquem dependentes de configurações locais ou de conversas isoladas.

## Integrações já consideradas

### ERP / Firebird

Origem operacional dos dados utilizados por novas aplicações e automações.

### Supabase

Camada moderna de persistência e integração para dados selecionados do ERP.

### n8n

Plataforma prevista para orquestrar automações e fluxos de integração.

### WhatsApp

Canal utilizado para comunicações relacionadas a pedidos e processos comerciais/operacionais. A implementação deve ser desacoplada do restante do sistema para permitir troca do provedor.

### Transportadora / logística

Existe integração/uso de informações da operação de transporte, incluindo referência ao ambiente Brudam. Detalhes técnicos devem ser documentados quando a integração for formalizada neste projeto.

## Princípios

- Credenciais nunca devem ser armazenadas no Git.
- URLs, tokens e segredos devem utilizar variáveis de ambiente ou secret managers.
- Cada integração deve possuir documentação de entrada, saída, autenticação, tratamento de erros e política de retry.
- Integrações críticas devem possuir logs e rastreabilidade.
