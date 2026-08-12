/*
 * Auditoria de metadados - Firebird 2.0
 * Projeto: Só Selantes
 * Origem: DEPOSITO.FDB
 *
 * Somente leitura. Não altera dados, tabelas, índices ou constraints.
 * Executar localmente no servidor Firebird para evitar quedas da conexão DDNS.
 */

/* 1) Inventário das tabelas DEPxxx */
SELECT
    TRIM(rf.rdb$relation_name) AS TABELA,
    COUNT(*) AS CAMPOS
FROM rdb$relation_fields rf
WHERE rf.rdb$system_flag = 0
  AND TRIM(rf.rdb$relation_name) STARTING WITH 'DEP'
GROUP BY rf.rdb$relation_name
ORDER BY rf.rdb$relation_name;

/* 2) Campos, tipos e nulabilidade de todas as DEPxxx */
SELECT
    TRIM(rf.rdb$relation_name) AS TABELA,
    rf.rdb$field_position + 1 AS POSICAO,
    TRIM(rf.rdb$field_name) AS CAMPO,
    f.rdb$field_type AS TIPO_CODIGO,
    CASE f.rdb$field_type
        WHEN 7 THEN 'SMALLINT'
        WHEN 8 THEN 'INTEGER'
        WHEN 9 THEN 'QUAD'
        WHEN 10 THEN 'FLOAT'
        WHEN 11 THEN 'DOUBLE PRECISION'
        WHEN 12 THEN 'DATE'
        WHEN 13 THEN 'TIME'
        WHEN 14 THEN 'CHAR'
        WHEN 16 THEN 'NUMERIC/DECIMAL'
        WHEN 27 THEN 'DOUBLE PRECISION'
        WHEN 35 THEN 'TIMESTAMP'
        WHEN 37 THEN 'VARCHAR'
        WHEN 261 THEN 'BLOB'
        ELSE 'OUTRO'
    END AS TIPO,
    f.rdb$field_length AS TAMANHO,
    f.rdb$field_precision AS PRECISAO,
    f.rdb$field_scale AS ESCALA,
    CASE
        WHEN rf.rdb$null_flag = 1 THEN 'NAO'
        ELSE 'SIM'
    END AS PERMITE_NULO
FROM rdb$relation_fields rf
JOIN rdb$fields f
  ON f.rdb$field_name = rf.rdb$field_source
WHERE rf.rdb$system_flag = 0
  AND TRIM(rf.rdb$relation_name) STARTING WITH 'DEP'
ORDER BY rf.rdb$relation_name, rf.rdb$field_position;

/* 3) Constraints das DEPxxx */
SELECT
    TRIM(rc.rdb$relation_name) AS TABELA,
    TRIM(rc.rdb$constraint_name) AS CONSTRAINT_NAME,
    TRIM(rc.rdb$constraint_type) AS TIPO,
    TRIM(seg.rdb$field_name) AS CAMPO,
    seg.rdb$field_position + 1 AS POSICAO
FROM rdb$relation_constraints rc
JOIN rdb$index_segments seg
  ON seg.rdb$index_name = rc.rdb$index_name
WHERE TRIM(rc.rdb$relation_name) STARTING WITH 'DEP'
ORDER BY rc.rdb$relation_name, rc.rdb$constraint_name, seg.rdb$field_position;

/* 4) Índices das DEPxxx */
SELECT
    TRIM(i.rdb$relation_name) AS TABELA,
    TRIM(i.rdb$index_name) AS INDICE,
    CASE WHEN i.rdb$unique_flag = 1 THEN 'UNIQUE' ELSE 'NORMAL' END AS TIPO,
    TRIM(s.rdb$field_name) AS CAMPO,
    s.rdb$field_position + 1 AS POSICAO,
    CASE WHEN i.rdb$index_inactive = 1 THEN 'INATIVO' ELSE 'ATIVO' END AS STATUS
FROM rdb$indices i
JOIN rdb$index_segments s
  ON s.rdb$index_name = i.rdb$index_name
WHERE TRIM(i.rdb$relation_name) STARTING WITH 'DEP'
ORDER BY i.rdb$relation_name, i.rdb$index_name, s.rdb$field_position;

/* 5) Foreign Keys das DEPxxx */
SELECT
    TRIM(rc.rdb$relation_name) AS TABELA,
    TRIM(rc.rdb$constraint_name) AS CONSTRAINT_FK,
    TRIM(seg.rdb$field_name) AS CAMPO,
    seg.rdb$field_position + 1 AS POSICAO,
    TRIM(ref.rdb$const_name_uq) AS CONSTRAINT_REFERENCIADA
FROM rdb$relation_constraints rc
JOIN rdb$index_segments seg
  ON seg.rdb$index_name = rc.rdb$index_name
JOIN rdb$ref_constraints ref
  ON ref.rdb$constraint_name = rc.rdb$constraint_name
WHERE rc.rdb$constraint_type = 'FOREIGN KEY'
  AND TRIM(rc.rdb$relation_name) STARTING WITH 'DEP'
ORDER BY rc.rdb$relation_name, rc.rdb$constraint_name, seg.rdb$field_position;

/* 6) Defaults das colunas DEPxxx */
SELECT
    TRIM(rf.rdb$relation_name) AS TABELA,
    TRIM(rf.rdb$field_name) AS CAMPO,
    TRIM(f.rdb$default_source) AS DEFAULT_SOURCE
FROM rdb$relation_fields rf
JOIN rdb$fields f
  ON f.rdb$field_name = rf.rdb$field_source
WHERE rf.rdb$system_flag = 0
  AND TRIM(rf.rdb$relation_name) STARTING WITH 'DEP'
  AND f.rdb$default_source IS NOT NULL
ORDER BY rf.rdb$relation_name, rf.rdb$field_position;

/* 7) Triggers das DEPxxx */
SELECT
    TRIM(r.rdb$relation_name) AS TABELA,
    TRIM(r.rdb$trigger_name) AS TRIGGER_NAME,
    r.rdb$trigger_sequence AS SEQUENCIA,
    r.rdb$trigger_type AS TIPO_CODIGO,
    CASE r.rdb$trigger_type
        WHEN 1 THEN 'BEFORE INSERT'
        WHEN 2 THEN 'AFTER INSERT'
        WHEN 3 THEN 'BEFORE UPDATE'
        WHEN 4 THEN 'AFTER UPDATE'
        WHEN 5 THEN 'BEFORE DELETE'
        WHEN 6 THEN 'AFTER DELETE'
        WHEN 17 THEN 'BEFORE INSERT OR UPDATE'
        WHEN 18 THEN 'AFTER INSERT OR UPDATE'
        WHEN 25 THEN 'BEFORE INSERT OR DELETE'
        WHEN 26 THEN 'AFTER INSERT OR DELETE'
        WHEN 27 THEN 'BEFORE UPDATE OR DELETE'
        WHEN 28 THEN 'AFTER UPDATE OR DELETE'
        WHEN 113 THEN 'BEFORE INSERT OR UPDATE OR DELETE'
        WHEN 114 THEN 'AFTER INSERT OR UPDATE OR DELETE'
        ELSE 'OUTRO'
    END AS EVENTO,
    r.rdb$trigger_inactive AS INATIVO
FROM rdb$triggers r
WHERE r.rdb$system_flag = 0
  AND r.rdb$relation_name IS NOT NULL
  AND TRIM(r.rdb$relation_name) STARTING WITH 'DEP'
ORDER BY r.rdb$relation_name, r.rdb$trigger_sequence, r.rdb$trigger_name;

/* 8) Generators/sequences: inventário geral.
 * Firebird 2.0 usa RDB$GENERATORS. Não existe garantia de associação
 * automática entre generator e coluna; essa associação será inferida
 * somente quando houver evidência em trigger/default.
 */
SELECT
    TRIM(g.rdb$generator_name) AS GENERATOR_NAME
FROM rdb$generators g
WHERE g.rdb$system_flag = 0
ORDER BY g.rdb$generator_name;

/* 9) Domínios usados pelas DEPxxx */
SELECT DISTINCT
    TRIM(rf.rdb$relation_name) AS TABELA,
    TRIM(rf.rdb$field_name) AS CAMPO,
    TRIM(f.rdb$field_name) AS DOMINIO
FROM rdb$relation_fields rf
JOIN rdb$fields f
  ON f.rdb$field_name = rf.rdb$field_source
WHERE rf.rdb$system_flag = 0
  AND TRIM(rf.rdb$relation_name) STARTING WITH 'DEP'
ORDER BY rf.rdb$relation_name, rf.rdb$field_position;
