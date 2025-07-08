CREATE OR ALTER PROCEDURE SP_LoginUser
    @Username VARCHAR(30),
    @Password VARCHAR(255),
    @Role VARCHAR(30) = NULL
AS
BEGIN
    DECLARE @UserID INT;

    SELECT @UserID = U.UserID
    FROM Users U
    WHERE U.Username = @Username
      AND U.PasswordHash = @Password;

    IF @UserID IS NULL
    BEGIN
        SELECT 'InvalidUsernameOrPassword' AS ErrorMessage;
        RETURN;
    END

    IF @Role IS NULL
    BEGIN
        SELECT UR.Role
        FROM UserRoles UR
        WHERE UR.UserID = @UserID;
        RETURN;
    END

    IF EXISTS (
        SELECT 1
        FROM UserRoles
        WHERE UserID = @UserID AND Role = @Role
    )
    BEGIN
        SELECT U.UserID, U.Username, UR.Role
        FROM Users U
        JOIN UserRoles UR ON U.UserID = UR.UserID
        WHERE U.UserID = @UserID AND UR.Role = @Role;
        RETURN;
    END
    ELSE
    BEGIN
        SELECT 'InvalidRoleForUser' AS ErrorMessage;
        RETURN;
    END
END
