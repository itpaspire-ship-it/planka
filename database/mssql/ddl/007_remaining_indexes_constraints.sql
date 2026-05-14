/*
  Secondary indexes and keys for the remaining MSSQL objects.
*/

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_action' AND parent_object_id = OBJECT_ID(N'planka.[action]'))
BEGIN
  ALTER TABLE planka.[action] ADD CONSTRAINT PK_action PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_base_custom_field_group' AND parent_object_id = OBJECT_ID(N'planka.[base_custom_field_group]'))
BEGIN
  ALTER TABLE planka.[base_custom_field_group] ADD CONSTRAINT PK_base_custom_field_group PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_custom_field_group' AND parent_object_id = OBJECT_ID(N'planka.[custom_field_group]'))
BEGIN
  ALTER TABLE planka.[custom_field_group] ADD CONSTRAINT PK_custom_field_group PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_custom_field' AND parent_object_id = OBJECT_ID(N'planka.[custom_field]'))
BEGIN
  ALTER TABLE planka.[custom_field] ADD CONSTRAINT PK_custom_field PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_custom_field_value' AND parent_object_id = OBJECT_ID(N'planka.[custom_field_value]'))
BEGIN
  ALTER TABLE planka.[custom_field_value] ADD CONSTRAINT PK_custom_field_value PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.key_constraints
  WHERE name = 'UQ_custom_field_value_card_group_field'
    AND parent_object_id = OBJECT_ID(N'planka.[custom_field_value]')
)
BEGIN
  ALTER TABLE planka.[custom_field_value]
    ADD CONSTRAINT UQ_custom_field_value_card_group_field UNIQUE (card_id, custom_field_group_id, custom_field_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_migration' AND parent_object_id = OBJECT_ID(N'planka.[migration]'))
BEGIN
  ALTER TABLE planka.[migration] ADD CONSTRAINT PK_migration PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_migration_lock' AND parent_object_id = OBJECT_ID(N'planka.[migration_lock]'))
BEGIN
  ALTER TABLE planka.[migration_lock] ADD CONSTRAINT PK_migration_lock PRIMARY KEY ([index]);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_action_board_id' AND object_id = OBJECT_ID(N'planka.[action]'))
BEGIN
  CREATE INDEX IX_action_board_id ON planka.[action] (board_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_action_card_id' AND object_id = OBJECT_ID(N'planka.[action]'))
BEGIN
  CREATE INDEX IX_action_card_id ON planka.[action] (card_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_action_user_id' AND object_id = OBJECT_ID(N'planka.[action]'))
BEGIN
  CREATE INDEX IX_action_user_id ON planka.[action] (user_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_base_custom_field_group_project_id' AND object_id = OBJECT_ID(N'planka.[base_custom_field_group]'))
BEGIN
  CREATE INDEX IX_base_custom_field_group_project_id ON planka.[base_custom_field_group] (project_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_custom_field_base_custom_field_group_id' AND object_id = OBJECT_ID(N'planka.[custom_field]'))
BEGIN
  CREATE INDEX IX_custom_field_base_custom_field_group_id ON planka.[custom_field] (base_custom_field_group_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_custom_field_custom_field_group_id' AND object_id = OBJECT_ID(N'planka.[custom_field]'))
BEGIN
  CREATE INDEX IX_custom_field_custom_field_group_id ON planka.[custom_field] (custom_field_group_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_custom_field_position' AND object_id = OBJECT_ID(N'planka.[custom_field]'))
BEGIN
  CREATE INDEX IX_custom_field_position ON planka.[custom_field] ([position]);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_custom_field_group_base_custom_field_group_id' AND object_id = OBJECT_ID(N'planka.[custom_field_group]'))
BEGIN
  CREATE INDEX IX_custom_field_group_base_custom_field_group_id ON planka.[custom_field_group] (base_custom_field_group_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_custom_field_group_board_id' AND object_id = OBJECT_ID(N'planka.[custom_field_group]'))
BEGIN
  CREATE INDEX IX_custom_field_group_board_id ON planka.[custom_field_group] (board_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_custom_field_group_card_id' AND object_id = OBJECT_ID(N'planka.[custom_field_group]'))
BEGIN
  CREATE INDEX IX_custom_field_group_card_id ON planka.[custom_field_group] (card_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_custom_field_group_position' AND object_id = OBJECT_ID(N'planka.[custom_field_group]'))
BEGIN
  CREATE INDEX IX_custom_field_group_position ON planka.[custom_field_group] ([position]);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_custom_field_value_custom_field_group_id' AND object_id = OBJECT_ID(N'planka.[custom_field_value]'))
BEGIN
  CREATE INDEX IX_custom_field_value_custom_field_group_id ON planka.[custom_field_value] (custom_field_group_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_custom_field_value_custom_field_id' AND object_id = OBJECT_ID(N'planka.[custom_field_value]'))
BEGIN
  CREATE INDEX IX_custom_field_value_custom_field_id ON planka.[custom_field_value] (custom_field_id);
END;
GO
