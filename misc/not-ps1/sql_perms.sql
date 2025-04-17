DECLARE @user NVARCHAR(50)
SET @user = N'USER ID GOES HERE'

-- Check if user exists
IF NOT EXISTS (SELECT  FROM sys.database_principals WHERE name = @user)
BEGIN
    DECLARE @sql NVARCHAR(MAX)
    SET @sql = N'CREATE USER [' + @user + '] FROM EXTERNAL PROVIDER;'
    EXEC sp_executesql @sql
    SELECT @user + ' was successfully created.' AS Result
END

-- Wait for a short time to ensure the user is created before proceeding
WAITFOR DELAY '000005'

-- Try to add the user to the roles - remove roles as appropriate
BEGIN TRY
    EXEC ('ALTER ROLE db_datareader ADD MEMBER [' + @user + ']')
    EXEC ('ALTER ROLE db_datawriter ADD MEMBER [' + @user + ']')
    EXEC ('ALTER ROLE db_ddladmin ADD MEMBER [' + @user + ']')
    EXEC ('ALTER ROLE db_executor ADD MEMBER [' + @user + ']')
    SELECT @user + ' was successfully added to the roles.' AS Result
END TRY
BEGIN CATCH
    SELECT 'Error adding ' + @user + ' to the roles ' + ERROR_MESSAGE() AS Result
END CATCH
