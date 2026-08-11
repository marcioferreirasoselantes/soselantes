# Escopo do Projeto

## 1. Contexto

A Só Selantes está estruturando uma nova base tecnológica para suportar aplicações comerciais, inteligência de dados, integrações e automações. O projeto deve aproveitar o ERP existente sem ficar limitado à arquitetura legada.

## 2. Objetivos

- Modernizar a camada de dados sem substituir imediatamente o ERP.
- Criar uma base confiável para aplicações comerciais.
- Centralizar integrações e automações.
- Melhorar a inteligência comercial por meio de dados históricos.
- Manter documentação e código versionados.

## 3. Sistemas e tecnologias já consideradas

- ERP existente com Firebird.
- Supabase/PostgreSQL para a nova camada de dados.
- n8n para automações.
- WhatsApp para comunicações operacionais e comerciais.
- GitHub como repositório de código e documentação.

## 4. Regra arquitetural principal

O novo ecossistema deve ser desacoplado do ERP na medida do possível. O ERP permanece como sistema de origem, enquanto novas funcionalidades devem ser construídas sobre serviços e dados modernos.

## 5. Fora do escopo inicial

Não está prevista, nesta primeira fase, a substituição completa do ERP ou uma migração imediata de todos os processos operacionais.
