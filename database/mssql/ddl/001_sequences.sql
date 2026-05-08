/*
  Initial MSSQL sequence and ID strategy starter translated from:
  database/postgres/schema/planka_schema.sql

  Notes:
  - This is a temporary ID strategy for early MSSQL compatibility work.
  - Replace it if strict parity with Postgres next_id() generation is required.
*/

IF NOT EXISTS (
  SELECT 1
  FROM sys.sequences
  WHERE name = 'next_id_seq' AND schema_id = SCHEMA_ID('planka')
)
BEGIN
  CREATE SEQUENCE planka.next_id_seq
    AS BIGINT
    START WITH 1
    INCREMENT BY 1;
END;
GO
