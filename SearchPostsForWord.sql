SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE #SearchPostsForWord
    @Word NVARCHAR(50),
    @Top INT = 50
AS
SET NOCOUNT ON

IF @Top IS NULL OR @Top <= 0
BEGIN
    SELECT @Top = COUNT(*)
    FROM   dbo.Posts p
END

DECLARE @EscapedWord NVARCHAR(100) =
    REPLACE(REPLACE(REPLACE(REPLACE(@Word, N'\', N'\\'), N'_', N'\_'), N'%', N'\%'), N'[', N'\[')

SELECT TOP (@Top) WITH TIES p.Id, p.Score, pt.[Type] AS PostType, p.Title, p.Body, u.DisplayName
FROM   dbo.Posts p
INNER JOIN dbo.PostTypes pt ON p.PostTypeId = pt.Id
LEFT JOIN dbo.Users u ON p.OwnerUserId = u.Id
WHERE  p.Title = @Word
OR     p.Title LIKE  @EscapedWord + N' %' ESCAPE N'\'
OR     p.Title LIKE N'% ' + @EscapedWord ESCAPE N'\'
OR     p.Title LIKE N'% ' + @EscapedWord + N' %' ESCAPE N'\'
OR     p.Body = @Word
OR     p.Body LIKE  @EscapedWord + N' %' ESCAPE N'\'
OR     p.Body LIKE N'% ' + @EscapedWord ESCAPE N'\'
OR     p.Body LIKE N'% ' + @EscapedWord + N' %' ESCAPE N'\'
ORDER BY p.Score DESC
GO

EXEC #SearchPostsForWord N'Stack', 20
GO