/*
  Bootstrap rows required by the application runtime.

  Notes:
  - This file contains data inserts even though it sits in the DDL execution
    order, because the app expects these singleton records and the default
    admin user to exist on first boot.
  - Default admin credentials created here:
      email: admin@local.test
      username: admin
      password: admin1234
*/

IF NOT EXISTS (SELECT 1 FROM planka.[config] WHERE id = 1)
BEGIN
  INSERT INTO planka.[config] (
    id,
    created_at,
    updated_at,
    smtp_host,
    smtp_port,
    smtp_name,
    smtp_secure,
    smtp_tls_reject_unauthorized,
    smtp_user,
    smtp_password,
    smtp_from
  )
  VALUES (
    1,
    SYSUTCDATETIME(),
    SYSUTCDATETIME(),
    NULL,
    NULL,
    NULL,
    0,
    1,
    NULL,
    NULL,
    NULL
  );
END;
GO

IF NOT EXISTS (SELECT 1 FROM planka.[internal_config] WHERE id = 1)
BEGIN
  INSERT INTO planka.[internal_config] (
    id,
    storage_limit,
    active_users_limit,
    is_initialized,
    created_at,
    updated_at
  )
  VALUES (
    1,
    NULL,
    NULL,
    0,
    SYSUTCDATETIME(),
    SYSUTCDATETIME()
  );
END;
GO

IF NOT EXISTS (SELECT 1 FROM planka.[storage_usage] WHERE id = 1)
BEGIN
  INSERT INTO planka.[storage_usage] (
    id,
    total,
    user_avatars,
    background_images,
    attachments,
    created_at,
    updated_at
  )
  VALUES (
    1,
    0,
    0,
    0,
    0,
    SYSUTCDATETIME(),
    SYSUTCDATETIME()
  );
END;
GO

IF NOT EXISTS (
  SELECT 1
  FROM planka.[user_account]
  WHERE email = N'admin@local.test' OR username = N'admin'
)
BEGIN
  INSERT INTO planka.[user_account] (
    email,
    [password],
    [role],
    [name],
    username,
    avatar,
    phone,
    organization,
    [language],
    subscribe_to_own_cards,
    subscribe_to_card_when_commenting,
    turn_off_recent_card_highlighting,
    enable_favorites_by_default,
    default_editor_mode,
    default_home_view,
    default_projects_order,
    is_sso_user,
    is_deactivated,
    created_at,
    updated_at,
    password_changed_at,
    terms_signature,
    terms_accepted_at,
    api_key_prefix,
    api_key_hash,
    api_key_created_at
  )
  VALUES (
    N'admin@local.test',
    N'$2b$10$7RXO/iw.VDW8wLMLAmo4AuPE5TPLnP2JgAn2cnwzqOnQS3kEraGgS',
    N'admin',
    N'Local Admin',
    N'admin',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    1,
    0,
    1,
    N'wysiwyg',
    N'groupedProjects',
    N'byDefault',
    0,
    0,
    SYSUTCDATETIME(),
    SYSUTCDATETIME(),
    SYSUTCDATETIME(),
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
  );
END;
GO
