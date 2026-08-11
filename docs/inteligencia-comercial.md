# Inteligência Comercial

## Objetivo

Construir uma camada de inteligência comercial capaz de transformar o histórico de vendas em decisões de metas, oportunidades de crescimento e acompanhamento de desempenho.

## Princípios

As metas não devem ser definidas apenas por crescimento linear ou pela repetição do mês anterior. Devem considerar histórico, sazonalidade, potencial regional, carteira de clientes, capacidade operacional e sustentabilidade.

## Histórico

A análise deve utilizar, quando disponível e validado, o histórico de vendas desde 2020, permitindo comparar o desempenho do mês correspondente em diferentes anos.

## Critério estratégico de metas

Uma das diretrizes comerciais já definida é buscar o maior crescimento percentual sustentável possível para o mês comparado, respeitando uma receita mínima estabelecida pela direção e as restrições operacionais.

## Dimensões relevantes

- Cidade.
- Vendedor.
- Cliente.
- Produto.
- Mês e ano.
- Receita.
- Quantidade.
- Histórico de crescimento.
- Potencial de mercado.

## Regiões inicialmente relevantes

Entre as cidades/regiões já consideradas estão Franca, Ribeirão Preto, São José do Rio Preto, Uberaba, Uberlândia e Araraquara. A lista pode evoluir conforme a estratégia comercial.

## Arquitetura esperada

```text
Firebird / ERP
      ↓
Supabase
      ↓
Dados históricos e indicadores
      ↓
Motor de análise / IA
      ↓
Metas e recomendações comerciais
```

## Regra de governança

Toda regra de cálculo de metas deve ser documentada antes de ser implementada em código, especialmente critérios de crescimento, pisos de receita, sazonalidade e capacidade operacional.
