/*
  Initial MSSQL constraint starter translated from:
  database/postgres/schema/planka_schema.sql

  Notes:
  - Primary and unique constraints are included here.
  - Foreign keys are intentionally deferred while the runtime path and final
    type/ID strategy are still evolving.
*/

IF NOT EXISTS (
  SELECT 1 FROM sys.key_constraints
  WHERE name = 'PK_user_account'
    AND parent_object_id = OBJECT_ID(N'planka.[user_account]')
)
BEGIN
  ALTER TABLE planka.[user_account] ADD CONSTRAINT PK_user_account PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.key_constraints
  WHERE name = 'UQ_user_account_email'
    AND parent_object_id = OBJECT_ID(N'planka.[user_account]')
)
BEGIN
  ALTER TABLE planka.[user_account] ADD CONSTRAINT UQ_user_account_email UNIQUE (email);
END;
GO

/*
  API keys are optional. In MSSQL, a plain UNIQUE constraint only allows a
  single NULL value, so use a filtered unique index instead.
*/
IF NOT EXISTS (
  SELECT 1
  FROM sys.indexes
  WHERE name = 'UQ_user_account_api_key_hash'
    AND object_id = OBJECT_ID(N'planka.[user_account]')
)
BEGIN
  CREATE UNIQUE INDEX UQ_user_account_api_key_hash
    ON planka.[user_account] (api_key_hash)
    WHERE api_key_hash IS NOT NULL;
END;
GO

/*
  Postgres uses an exclusion constraint for nullable unique usernames.
  In MSSQL, a filtered unique index is the closest equivalent.
*/
IF NOT EXISTS (
  SELECT 1
  FROM sys.indexes
  WHERE name = 'UQ_user_account_username_not_null'
    AND object_id = OBJECT_ID(N'planka.[user_account]')
)
BEGIN
  CREATE UNIQUE INDEX UQ_user_account_username_not_null
    ON planka.[user_account] (username)
    WHERE username IS NOT NULL;
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_project' AND parent_object_id = OBJECT_ID(N'planka.[project]'))
BEGIN
  ALTER TABLE planka.[project] ADD CONSTRAINT PK_project PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_project_manager' AND parent_object_id = OBJECT_ID(N'planka.[project_manager]'))
BEGIN
  ALTER TABLE planka.[project_manager] ADD CONSTRAINT PK_project_manager PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UQ_project_manager_project_user' AND parent_object_id = OBJECT_ID(N'planka.[project_manager]'))
BEGIN
  ALTER TABLE planka.[project_manager] ADD CONSTRAINT UQ_project_manager_project_user UNIQUE (project_id, user_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_board' AND parent_object_id = OBJECT_ID(N'planka.[board]'))
BEGIN
  ALTER TABLE planka.[board] ADD CONSTRAINT PK_board PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_list' AND parent_object_id = OBJECT_ID(N'planka.[list]'))
BEGIN
  ALTER TABLE planka.[list] ADD CONSTRAINT PK_list PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_label' AND parent_object_id = OBJECT_ID(N'planka.[label]'))
BEGIN
  ALTER TABLE planka.[label] ADD CONSTRAINT PK_label PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_attachment' AND parent_object_id = OBJECT_ID(N'planka.[attachment]'))
BEGIN
  ALTER TABLE planka.[attachment] ADD CONSTRAINT PK_attachment PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_card' AND parent_object_id = OBJECT_ID(N'planka.[card]'))
BEGIN
  ALTER TABLE planka.[card] ADD CONSTRAINT PK_card PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_board_membership' AND parent_object_id = OBJECT_ID(N'planka.[board_membership]'))
BEGIN
  ALTER TABLE planka.[board_membership] ADD CONSTRAINT PK_board_membership PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UQ_board_membership_board_user' AND parent_object_id = OBJECT_ID(N'planka.[board_membership]'))
BEGIN
  ALTER TABLE planka.[board_membership] ADD CONSTRAINT UQ_board_membership_board_user UNIQUE (board_id, user_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_card_membership' AND parent_object_id = OBJECT_ID(N'planka.[card_membership]'))
BEGIN
  ALTER TABLE planka.[card_membership] ADD CONSTRAINT PK_card_membership PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UQ_card_membership_card_user' AND parent_object_id = OBJECT_ID(N'planka.[card_membership]'))
BEGIN
  ALTER TABLE planka.[card_membership] ADD CONSTRAINT UQ_card_membership_card_user UNIQUE (card_id, user_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_card_label' AND parent_object_id = OBJECT_ID(N'planka.[card_label]'))
BEGIN
  ALTER TABLE planka.[card_label] ADD CONSTRAINT PK_card_label PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UQ_card_label_card_label' AND parent_object_id = OBJECT_ID(N'planka.[card_label]'))
BEGIN
  ALTER TABLE planka.[card_label] ADD CONSTRAINT UQ_card_label_card_label UNIQUE (card_id, label_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_board_subscription' AND parent_object_id = OBJECT_ID(N'planka.[board_subscription]'))
BEGIN
  ALTER TABLE planka.[board_subscription] ADD CONSTRAINT PK_board_subscription PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UQ_board_subscription_board_user' AND parent_object_id = OBJECT_ID(N'planka.[board_subscription]'))
BEGIN
  ALTER TABLE planka.[board_subscription] ADD CONSTRAINT UQ_board_subscription_board_user UNIQUE (board_id, user_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_card_subscription' AND parent_object_id = OBJECT_ID(N'planka.[card_subscription]'))
BEGIN
  ALTER TABLE planka.[card_subscription] ADD CONSTRAINT PK_card_subscription PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UQ_card_subscription_card_user' AND parent_object_id = OBJECT_ID(N'planka.[card_subscription]'))
BEGIN
  ALTER TABLE planka.[card_subscription] ADD CONSTRAINT UQ_card_subscription_card_user UNIQUE (card_id, user_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_comment' AND parent_object_id = OBJECT_ID(N'planka.[comment]'))
BEGIN
  ALTER TABLE planka.[comment] ADD CONSTRAINT PK_comment PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_background_image' AND parent_object_id = OBJECT_ID(N'planka.[background_image]'))
BEGIN
  ALTER TABLE planka.[background_image] ADD CONSTRAINT PK_background_image PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_project_favorite' AND parent_object_id = OBJECT_ID(N'planka.[project_favorite]'))
BEGIN
  ALTER TABLE planka.[project_favorite] ADD CONSTRAINT PK_project_favorite PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UQ_project_favorite_project_user' AND parent_object_id = OBJECT_ID(N'planka.[project_favorite]'))
BEGIN
  ALTER TABLE planka.[project_favorite] ADD CONSTRAINT UQ_project_favorite_project_user UNIQUE (project_id, user_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_session' AND parent_object_id = OBJECT_ID(N'planka.[session]'))
BEGIN
  ALTER TABLE planka.[session] ADD CONSTRAINT PK_session PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UQ_session_access_token' AND parent_object_id = OBJECT_ID(N'planka.[session]'))
BEGIN
  ALTER TABLE planka.[session] ADD CONSTRAINT UQ_session_access_token UNIQUE (access_token);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UQ_session_pending_token' AND parent_object_id = OBJECT_ID(N'planka.[session]'))
BEGIN
  ALTER TABLE planka.[session] ADD CONSTRAINT UQ_session_pending_token UNIQUE (pending_token);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_task_list' AND parent_object_id = OBJECT_ID(N'planka.[task_list]'))
BEGIN
  ALTER TABLE planka.[task_list] ADD CONSTRAINT PK_task_list PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_task' AND parent_object_id = OBJECT_ID(N'planka.[task]'))
BEGIN
  ALTER TABLE planka.[task] ADD CONSTRAINT PK_task PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_uploaded_file' AND parent_object_id = OBJECT_ID(N'planka.[uploaded_file]'))
BEGIN
  ALTER TABLE planka.[uploaded_file] ADD CONSTRAINT PK_uploaded_file PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_identity_provider_user' AND parent_object_id = OBJECT_ID(N'planka.[identity_provider_user]'))
BEGIN
  ALTER TABLE planka.[identity_provider_user] ADD CONSTRAINT PK_identity_provider_user PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UQ_identity_provider_user_issuer_sub' AND parent_object_id = OBJECT_ID(N'planka.[identity_provider_user]'))
BEGIN
  ALTER TABLE planka.[identity_provider_user] ADD CONSTRAINT UQ_identity_provider_user_issuer_sub UNIQUE (issuer, sub);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_notification' AND parent_object_id = OBJECT_ID(N'planka.[notification]'))
BEGIN
  ALTER TABLE planka.[notification] ADD CONSTRAINT PK_notification PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_notification_service' AND parent_object_id = OBJECT_ID(N'planka.[notification_service]'))
BEGIN
  ALTER TABLE planka.[notification_service] ADD CONSTRAINT PK_notification_service PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_config' AND parent_object_id = OBJECT_ID(N'planka.[config]'))
BEGIN
  ALTER TABLE planka.[config] ADD CONSTRAINT PK_config PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_internal_config' AND parent_object_id = OBJECT_ID(N'planka.[internal_config]'))
BEGIN
  ALTER TABLE planka.[internal_config] ADD CONSTRAINT PK_internal_config PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_storage_usage' AND parent_object_id = OBJECT_ID(N'planka.[storage_usage]'))
BEGIN
  ALTER TABLE planka.[storage_usage] ADD CONSTRAINT PK_storage_usage PRIMARY KEY (id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_webhook' AND parent_object_id = OBJECT_ID(N'planka.[webhook]'))
BEGIN
  ALTER TABLE planka.[webhook] ADD CONSTRAINT PK_webhook PRIMARY KEY (id);
END;
GO

/*
  Foreign keys are intentionally deferred.
  Once the runtime path is stable, add FK constraints in dependency order to:
  - verify the final ID strategy
  - avoid rework while table/column mappings are still changing
*/
