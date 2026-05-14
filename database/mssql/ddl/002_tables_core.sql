/*
  Initial MSSQL table starter translated from:
  database/postgres/schema/planka_schema.sql

  Notes:
  - This is a curated starting point, not a final one-to-one conversion.
  - Postgres-specific behavior such as jsonb, arrays, and the original
    Snowflake-like next_id() implementation still need follow-up decisions.
*/

IF OBJECT_ID(N'planka.[user_account]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[user_account] (
    id BIGINT NOT NULL CONSTRAINT DF_user_account_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    email NVARCHAR(320) NOT NULL,
    [password] NVARCHAR(MAX) NULL,
    [role] NVARCHAR(255) NOT NULL,
    [name] NVARCHAR(255) NOT NULL,
    username NVARCHAR(255) NULL,
    avatar NVARCHAR(MAX) NULL,
    phone NVARCHAR(255) NULL,
    organization NVARCHAR(255) NULL,
    [language] NVARCHAR(64) NULL,
    subscribe_to_own_cards BIT NOT NULL,
    subscribe_to_card_when_commenting BIT NOT NULL,
    turn_off_recent_card_highlighting BIT NOT NULL,
    enable_favorites_by_default BIT NOT NULL,
    default_editor_mode NVARCHAR(255) NOT NULL,
    default_home_view NVARCHAR(255) NOT NULL,
    default_projects_order NVARCHAR(255) NOT NULL,
    is_sso_user BIT NOT NULL,
    is_deactivated BIT NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL,
    password_changed_at DATETIME2(3) NULL,
    terms_signature NVARCHAR(MAX) NULL,
    terms_accepted_at DATETIME2(3) NULL,
    api_key_prefix NVARCHAR(255) NULL,
    api_key_hash NVARCHAR(255) NULL,
    api_key_created_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[project]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[project] (
    id BIGINT NOT NULL CONSTRAINT DF_project_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    owner_project_manager_id BIGINT NULL,
    background_image_id BIGINT NULL,
    [name] NVARCHAR(255) NOT NULL,
    [description] NVARCHAR(MAX) NULL,
    background_type NVARCHAR(255) NULL,
    background_gradient NVARCHAR(MAX) NULL,
    is_hidden BIT NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[project_manager]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[project_manager] (
    id BIGINT NOT NULL CONSTRAINT DF_project_manager_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    project_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[board]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[board] (
    id BIGINT NOT NULL CONSTRAINT DF_board_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    project_id BIGINT NOT NULL,
    [position] FLOAT(53) NOT NULL,
    [name] NVARCHAR(255) NOT NULL,
    default_view NVARCHAR(255) NOT NULL,
    default_card_type NVARCHAR(255) NOT NULL,
    limit_card_types_to_default_one BIT NOT NULL,
    always_display_card_creator BIT NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL,
    expand_task_lists_by_default BIT NOT NULL,
    display_card_ages BIT NOT NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[list]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[list] (
    id BIGINT NOT NULL CONSTRAINT DF_list_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    board_id BIGINT NOT NULL,
    [type] NVARCHAR(255) NOT NULL,
    [position] FLOAT(53) NULL,
    [name] NVARCHAR(255) NULL,
    color NVARCHAR(255) NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[label]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[label] (
    id BIGINT NOT NULL CONSTRAINT DF_label_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    board_id BIGINT NOT NULL,
    [position] FLOAT(53) NOT NULL,
    [name] NVARCHAR(255) NULL,
    color NVARCHAR(255) NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[attachment]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[attachment] (
    id BIGINT NOT NULL CONSTRAINT DF_attachment_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    card_id BIGINT NOT NULL,
    creator_user_id BIGINT NULL,
    [type] NVARCHAR(255) NOT NULL,
    [data] NVARCHAR(MAX) NOT NULL,
    [name] NVARCHAR(255) NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[card]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[card] (
    id BIGINT NOT NULL CONSTRAINT DF_card_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    board_id BIGINT NOT NULL,
    list_id BIGINT NOT NULL,
    creator_user_id BIGINT NULL,
    prev_list_id BIGINT NULL,
    cover_attachment_id BIGINT NULL,
    [type] NVARCHAR(255) NOT NULL,
    [position] FLOAT(53) NULL,
    [name] NVARCHAR(255) NOT NULL,
    [description] NVARCHAR(MAX) NULL,
    pms_id NVARCHAR(255) NULL,
    due_date DATETIME2(3) NULL,
    stopwatch NVARCHAR(MAX) NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL,
    list_changed_at DATETIME2(3) NULL,
    comments_total INT NOT NULL,
    is_closed BIT NOT NULL,
    is_due_completed BIT NULL
  );
END;
GO

IF COL_LENGTH(N'planka.card', N'pms_id') IS NULL
BEGIN
  ALTER TABLE planka.[card] ADD pms_id NVARCHAR(255) NULL;
END;
GO

IF OBJECT_ID(N'planka.[board_membership]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[board_membership] (
    id BIGINT NOT NULL CONSTRAINT DF_board_membership_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    project_id BIGINT NOT NULL,
    board_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    [role] NVARCHAR(255) NOT NULL,
    can_comment BIT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[card_membership]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[card_membership] (
    id BIGINT NOT NULL CONSTRAINT DF_card_membership_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    card_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[card_label]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[card_label] (
    id BIGINT NOT NULL CONSTRAINT DF_card_label_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    card_id BIGINT NOT NULL,
    label_id BIGINT NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[board_subscription]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[board_subscription] (
    id BIGINT NOT NULL CONSTRAINT DF_board_subscription_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    board_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[card_subscription]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[card_subscription] (
    id BIGINT NOT NULL CONSTRAINT DF_card_subscription_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    card_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    is_permanent BIT NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[comment]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[comment] (
    id BIGINT NOT NULL CONSTRAINT DF_comment_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    card_id BIGINT NOT NULL,
    user_id BIGINT NULL,
    [text] NVARCHAR(MAX) NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[background_image]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[background_image] (
    id BIGINT NOT NULL CONSTRAINT DF_background_image_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    project_id BIGINT NOT NULL,
    uploaded_file_id NVARCHAR(255) NOT NULL,
    extension NVARCHAR(50) NOT NULL,
    size BIGINT NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[project_favorite]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[project_favorite] (
    id BIGINT NOT NULL CONSTRAINT DF_project_favorite_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    project_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[session]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[session] (
    id BIGINT NOT NULL CONSTRAINT DF_session_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    user_id BIGINT NOT NULL,
    access_token NVARCHAR(MAX) NULL,
    http_only_token NVARCHAR(MAX) NULL,
    remote_address NVARCHAR(255) NOT NULL,
    user_agent NVARCHAR(MAX) NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL,
    deleted_at DATETIME2(3) NULL,
    pending_token NVARCHAR(MAX) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[task_list]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[task_list] (
    id BIGINT NOT NULL CONSTRAINT DF_task_list_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    card_id BIGINT NOT NULL,
    [position] FLOAT(53) NOT NULL,
    [name] NVARCHAR(255) NOT NULL,
    show_on_front_of_card BIT NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL,
    hide_completed_tasks BIT NOT NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[task]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[task] (
    id BIGINT NOT NULL CONSTRAINT DF_task_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    task_list_id BIGINT NOT NULL,
    assignee_user_id BIGINT NULL,
    [position] FLOAT(53) NOT NULL,
    [name] NVARCHAR(255) NOT NULL,
    is_completed BIT NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL,
    linked_card_id BIGINT NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[uploaded_file]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[uploaded_file] (
    id NVARCHAR(255) NOT NULL CONSTRAINT DF_uploaded_file_id DEFAULT (CONVERT(NVARCHAR(255), NEXT VALUE FOR planka.next_id_seq)),
    references_total INT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL,
    [type] NVARCHAR(255) NOT NULL,
    mime_type NVARCHAR(255) NULL,
    size BIGINT NOT NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[identity_provider_user]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[identity_provider_user] (
    id BIGINT NOT NULL CONSTRAINT DF_identity_provider_user_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    user_id BIGINT NOT NULL,
    issuer NVARCHAR(255) NOT NULL,
    sub NVARCHAR(255) NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[notification]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[notification] (
    id BIGINT NOT NULL CONSTRAINT DF_notification_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    user_id BIGINT NOT NULL,
    creator_user_id BIGINT NULL,
    board_id BIGINT NOT NULL,
    card_id BIGINT NOT NULL,
    comment_id BIGINT NULL,
    action_id BIGINT NULL,
    [type] NVARCHAR(255) NOT NULL,
    [data] NVARCHAR(MAX) NOT NULL,
    is_read BIT NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[notification_service]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[notification_service] (
    id BIGINT NOT NULL CONSTRAINT DF_notification_service_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    user_id BIGINT NULL,
    board_id BIGINT NULL,
    [url] NVARCHAR(MAX) NOT NULL,
    [format] NVARCHAR(255) NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[config]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[config] (
    id BIGINT NOT NULL CONSTRAINT DF_config_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL,
    smtp_host NVARCHAR(255) NULL,
    smtp_port INT NULL,
    smtp_name NVARCHAR(255) NULL,
    smtp_secure BIT NOT NULL,
    smtp_tls_reject_unauthorized BIT NOT NULL,
    smtp_user NVARCHAR(255) NULL,
    smtp_password NVARCHAR(MAX) NULL,
    smtp_from NVARCHAR(MAX) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[internal_config]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[internal_config] (
    id BIGINT NOT NULL CONSTRAINT DF_internal_config_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    storage_limit NVARCHAR(255) NULL,
    active_users_limit INT NULL,
    is_initialized BIT NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[storage_usage]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[storage_usage] (
    id BIGINT NOT NULL CONSTRAINT DF_storage_usage_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    total BIGINT NOT NULL,
    user_avatars BIGINT NOT NULL,
    background_images BIGINT NOT NULL,
    attachments BIGINT NOT NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO

IF OBJECT_ID(N'planka.[webhook]', N'U') IS NULL
BEGIN
  CREATE TABLE planka.[webhook] (
    id BIGINT NOT NULL CONSTRAINT DF_webhook_id DEFAULT (NEXT VALUE FOR planka.next_id_seq),
    board_id BIGINT NULL,
    [name] NVARCHAR(255) NOT NULL,
    [url] NVARCHAR(MAX) NOT NULL,
    access_token NVARCHAR(MAX) NULL,
    events NVARCHAR(MAX) NULL,
    excluded_events NVARCHAR(MAX) NULL,
    created_at DATETIME2(3) NULL,
    updated_at DATETIME2(3) NULL
  );
END;
GO
