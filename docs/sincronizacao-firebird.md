# Sincronização Firebird → Supabase

## Objetivo

Disponibilizar no Supabase os dados necessários do ERP Firebird para novas aplicações, integrações, automações e inteligência comercial, preservando o ERP como sistema operacional de origem.

## Diretrizes

- Não alterar o Firebird durante a sincronização.
- Priorizar sincronização incremental.
- Registrar erros e execuções.
- Evitar duplicidade de registros.
- Permitir reprocessamento seguro.
- Manter as regras documentadas neste repositório.

## Dados prioritários

A primeira frente conhecida envolve pedidos, itens, clientes e vendedores:

- `DEP021` — pedidos
- `DEP022` — itens dos pedidos
- `DEP011` — clientes
- `DEP013` — vendedores

## Pedidos e notificações

Uma automação já planejada utiliza os pedidos da `DEP021` com `TIPO = 'PED'` e `DATA` igual à data corrente para processos de comunicação via WhatsApp.

A implementação definitiva da sincronização deve confirmar os nomes e tipos dos campos diretamente no Firebird.

## Próxima etapa técnica

Levantar o schema real das tabelas no Firebird, incluindo campos, tipos, chaves, índices e relações. A partir desse levantamento será definida a estrutura correspondente no Supabase.
