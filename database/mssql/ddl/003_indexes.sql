/*
  Initial MSSQL index starter translated from:
  database/postgres/schema/planka_schema.sql

  Notes:
  - Postgres trigram GIN indexes still need a separate MSSQL search strategy.
*/

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_user_account_role'
    AND object_id = OBJECT_ID(N'planka.[user_account]')
)
BEGIN
  CREATE INDEX IX_user_account_role ON planka.[user_account] ([role]);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_user_account_username'
    AND object_id = OBJECT_ID(N'planka.[user_account]')
)
BEGIN
  CREATE INDEX IX_user_account_username ON planka.[user_account] (username);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_user_account_is_deactivated'
    AND object_id = OBJECT_ID(N'planka.[user_account]')
)
BEGIN
  CREATE INDEX IX_user_account_is_deactivated ON planka.[user_account] (is_deactivated);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_project_owner_project_manager_id'
    AND object_id = OBJECT_ID(N'planka.[project]')
)
BEGIN
  CREATE INDEX IX_project_owner_project_manager_id ON planka.[project] (owner_project_manager_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_project_manager_user_id'
    AND object_id = OBJECT_ID(N'planka.[project_manager]')
)
BEGIN
  CREATE INDEX IX_project_manager_user_id ON planka.[project_manager] (user_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_board_project_id'
    AND object_id = OBJECT_ID(N'planka.[board]')
)
BEGIN
  CREATE INDEX IX_board_project_id ON planka.[board] (project_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_board_position'
    AND object_id = OBJECT_ID(N'planka.[board]')
)
BEGIN
  CREATE INDEX IX_board_position ON planka.[board] ([position]);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_list_board_id'
    AND object_id = OBJECT_ID(N'planka.[list]')
)
BEGIN
  CREATE INDEX IX_list_board_id ON planka.[list] (board_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_list_position'
    AND object_id = OBJECT_ID(N'planka.[list]')
)
BEGIN
  CREATE INDEX IX_list_position ON planka.[list] ([position]);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_list_type'
    AND object_id = OBJECT_ID(N'planka.[list]')
)
BEGIN
  CREATE INDEX IX_list_type ON planka.[list] ([type]);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_label_board_id'
    AND object_id = OBJECT_ID(N'planka.[label]')
)
BEGIN
  CREATE INDEX IX_label_board_id ON planka.[label] (board_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_label_position'
    AND object_id = OBJECT_ID(N'planka.[label]')
)
BEGIN
  CREATE INDEX IX_label_position ON planka.[label] ([position]);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_attachment_card_id'
    AND object_id = OBJECT_ID(N'planka.[attachment]')
)
BEGIN
  CREATE INDEX IX_attachment_card_id ON planka.[attachment] (card_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_attachment_creator_user_id'
    AND object_id = OBJECT_ID(N'planka.[attachment]')
)
BEGIN
  CREATE INDEX IX_attachment_creator_user_id ON planka.[attachment] (creator_user_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_card_board_id'
    AND object_id = OBJECT_ID(N'planka.[card]')
)
BEGIN
  CREATE INDEX IX_card_board_id ON planka.[card] (board_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_card_list_id'
    AND object_id = OBJECT_ID(N'planka.[card]')
)
BEGIN
  CREATE INDEX IX_card_list_id ON planka.[card] (list_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_card_creator_user_id'
    AND object_id = OBJECT_ID(N'planka.[card]')
)
BEGIN
  CREATE INDEX IX_card_creator_user_id ON planka.[card] (creator_user_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_card_position'
    AND object_id = OBJECT_ID(N'planka.[card]')
)
BEGIN
  CREATE INDEX IX_card_position ON planka.[card] ([position]);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_card_list_changed_at'
    AND object_id = OBJECT_ID(N'planka.[card]')
)
BEGIN
  CREATE INDEX IX_card_list_changed_at ON planka.[card] (list_changed_at);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_board_membership_project_id'
    AND object_id = OBJECT_ID(N'planka.[board_membership]')
)
BEGIN
  CREATE INDEX IX_board_membership_project_id ON planka.[board_membership] (project_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_board_membership_user_id'
    AND object_id = OBJECT_ID(N'planka.[board_membership]')
)
BEGIN
  CREATE INDEX IX_board_membership_user_id ON planka.[board_membership] (user_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_card_membership_user_id'
    AND object_id = OBJECT_ID(N'planka.[card_membership]')
)
BEGIN
  CREATE INDEX IX_card_membership_user_id ON planka.[card_membership] (user_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_card_label_label_id'
    AND object_id = OBJECT_ID(N'planka.[card_label]')
)
BEGIN
  CREATE INDEX IX_card_label_label_id ON planka.[card_label] (label_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_board_subscription_user_id'
    AND object_id = OBJECT_ID(N'planka.[board_subscription]')
)
BEGIN
  CREATE INDEX IX_board_subscription_user_id ON planka.[board_subscription] (user_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_card_subscription_user_id'
    AND object_id = OBJECT_ID(N'planka.[card_subscription]')
)
BEGIN
  CREATE INDEX IX_card_subscription_user_id ON planka.[card_subscription] (user_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_comment_card_id'
    AND object_id = OBJECT_ID(N'planka.[comment]')
)
BEGIN
  CREATE INDEX IX_comment_card_id ON planka.[comment] (card_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_comment_user_id'
    AND object_id = OBJECT_ID(N'planka.[comment]')
)
BEGIN
  CREATE INDEX IX_comment_user_id ON planka.[comment] (user_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_background_image_project_id'
    AND object_id = OBJECT_ID(N'planka.[background_image]')
)
BEGIN
  CREATE INDEX IX_background_image_project_id ON planka.[background_image] (project_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_project_favorite_user_id'
    AND object_id = OBJECT_ID(N'planka.[project_favorite]')
)
BEGIN
  CREATE INDEX IX_project_favorite_user_id ON planka.[project_favorite] (user_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_session_user_id'
    AND object_id = OBJECT_ID(N'planka.[session]')
)
BEGIN
  CREATE INDEX IX_session_user_id ON planka.[session] (user_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_session_remote_address'
    AND object_id = OBJECT_ID(N'planka.[session]')
)
BEGIN
  CREATE INDEX IX_session_remote_address ON planka.[session] (remote_address);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_task_list_card_id'
    AND object_id = OBJECT_ID(N'planka.[task_list]')
)
BEGIN
  CREATE INDEX IX_task_list_card_id ON planka.[task_list] (card_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_task_list_position'
    AND object_id = OBJECT_ID(N'planka.[task_list]')
)
BEGIN
  CREATE INDEX IX_task_list_position ON planka.[task_list] ([position]);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_task_task_list_id'
    AND object_id = OBJECT_ID(N'planka.[task]')
)
BEGIN
  CREATE INDEX IX_task_task_list_id ON planka.[task] (task_list_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_task_assignee_user_id'
    AND object_id = OBJECT_ID(N'planka.[task]')
)
BEGIN
  CREATE INDEX IX_task_assignee_user_id ON planka.[task] (assignee_user_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_task_linked_card_id'
    AND object_id = OBJECT_ID(N'planka.[task]')
)
BEGIN
  CREATE INDEX IX_task_linked_card_id ON planka.[task] (linked_card_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_task_position'
    AND object_id = OBJECT_ID(N'planka.[task]')
)
BEGIN
  CREATE INDEX IX_task_position ON planka.[task] ([position]);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_uploaded_file_references_total'
    AND object_id = OBJECT_ID(N'planka.[uploaded_file]')
)
BEGIN
  CREATE INDEX IX_uploaded_file_references_total ON planka.[uploaded_file] (references_total);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_uploaded_file_type'
    AND object_id = OBJECT_ID(N'planka.[uploaded_file]')
)
BEGIN
  CREATE INDEX IX_uploaded_file_type ON planka.[uploaded_file] ([type]);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_identity_provider_user_user_id'
    AND object_id = OBJECT_ID(N'planka.[identity_provider_user]')
)
BEGIN
  CREATE INDEX IX_identity_provider_user_user_id ON planka.[identity_provider_user] (user_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_notification_user_id'
    AND object_id = OBJECT_ID(N'planka.[notification]')
)
BEGIN
  CREATE INDEX IX_notification_user_id ON planka.[notification] (user_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_notification_creator_user_id'
    AND object_id = OBJECT_ID(N'planka.[notification]')
)
BEGIN
  CREATE INDEX IX_notification_creator_user_id ON planka.[notification] (creator_user_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_notification_card_id'
    AND object_id = OBJECT_ID(N'planka.[notification]')
)
BEGIN
  CREATE INDEX IX_notification_card_id ON planka.[notification] (card_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_notification_comment_id'
    AND object_id = OBJECT_ID(N'planka.[notification]')
)
BEGIN
  CREATE INDEX IX_notification_comment_id ON planka.[notification] (comment_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_notification_action_id'
    AND object_id = OBJECT_ID(N'planka.[notification]')
)
BEGIN
  CREATE INDEX IX_notification_action_id ON planka.[notification] (action_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_notification_is_read'
    AND object_id = OBJECT_ID(N'planka.[notification]')
)
BEGIN
  CREATE INDEX IX_notification_is_read ON planka.[notification] (is_read);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_notification_service_user_id'
    AND object_id = OBJECT_ID(N'planka.[notification_service]')
)
BEGIN
  CREATE INDEX IX_notification_service_user_id ON planka.[notification_service] (user_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_notification_service_board_id'
    AND object_id = OBJECT_ID(N'planka.[notification_service]')
)
BEGIN
  CREATE INDEX IX_notification_service_board_id ON planka.[notification_service] (board_id);
END;
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = 'IX_webhook_board_id'
    AND object_id = OBJECT_ID(N'planka.[webhook]')
)
BEGIN
  CREATE INDEX IX_webhook_board_id ON planka.[webhook] (board_id);
END;
GO

/*
  Postgres trigram GIN indexes need a separate MSSQL search strategy.
  Keep these as TODO items until full-text search vs simpler LIKE-based search
  is decided for the MSSQL runtime path.
  - card_name_gin_index
  - card_description_gin_index
*/
