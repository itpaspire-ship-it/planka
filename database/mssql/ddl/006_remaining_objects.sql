/*
  Remaining MSSQL objects translated from the Postgres source schema.

  This closes the gap for tables that were not included in the initial core
  translation, including custom-field tables and Knex migration bookkeeping.
*/

IF OBJECT_ID(N'planka.[action]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[action] (
    id BIGINT NOT NULL CONSTRAINT DF_action_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    card_id BIGINT NOT NULL,
    user_id BIGINT NULL,
    [type] NVARCHAR(MAX) NOT NULL,
    [data] NVARCHAR(MAX) NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL,
    board_id BIGINT NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[base_custom_field_group]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[base_custom_field_group] (
    id BIGINT NOT NULL CONSTRAINT DF_base_custom_field_group_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    project_id BIGINT NOT NULL,
    [name] NVARCHAR(MAX) NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[custom_field_group]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[custom_field_group] (
    id BIGINT NOT NULL CONSTRAINT DF_custom_field_group_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    board_id BIGINT NULL,
    card_id BIGINT NULL,
    base_custom_field_group_id BIGINT NULL,
    [position] FLOAT(53) NOT NULL,
    [name] NVARCHAR(MAX) NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[custom_field]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[custom_field] (
    id BIGINT NOT NULL CONSTRAINT DF_custom_field_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    base_custom_field_group_id BIGINT NULL,
    custom_field_group_id BIGINT NULL,
    [position] FLOAT(53) NOT NULL,
    [name] NVARCHAR(MAX) NOT NULL,
    show_on_front_of_card BIT NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[custom_field_value]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[custom_field_value] (
    id BIGINT NOT NULL CONSTRAINT DF_custom_field_value_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    card_id BIGINT NOT NULL,
    custom_field_group_id BIGINT NOT NULL,
    custom_field_id BIGINT NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[migration]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[migration] (
    id INT IDENTITY(1,1) NOT NULL,
    [name] NVARCHAR(255) NULL,
    batch INT NULL,
    migration_time DATETIMEOFFSET(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[migration_lock]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[migration_lock] (
    [index] INT IDENTITY(1,1) NOT NULL,
    is_locked INT NULL
  );
END;
GO
