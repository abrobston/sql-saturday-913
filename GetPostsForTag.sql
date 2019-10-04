SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE #GetPostsForTag
    @Tag NVARCHAR(50),
    @PageNumber INT = 0, -- Let's say it's zero-based
    @PageSize INT = 25,
    @TotalCount INT = NULL OUTPUT
AS
SET NOCOUNT ON

DROP TABLE IF EXISTS #PostInfo
CREATE TABLE #PostInfo
(
    Id INT NOT NULL PRIMARY KEY,
    Title NVARCHAR(250) NULL,
    Body NVARCHAR(MAX) NOT NULL,
    Tags NVARCHAR(150) NULL,
    PostType NVARCHAR(50) NOT NULL,
    [Owner] NVARCHAR(40) NULL,
    LastEditor NVARCHAR(40) NULL
)

INSERT #PostInfo (Id, Title, Body, Tags, PostType, [Owner], LastEditor)
SELECT p.Id, p.Title, p.Body, p.Tags, pt.[Type] AS PostType, ou.DisplayName AS [Owner], leu.DisplayName AS LastEditor
FROM   dbo.Posts p
INNER JOIN dbo.PostTags tags ON p.Id = tags.PostId
INNER JOIN dbo.PostTypes pt ON p.PostTypeId = pt.Id
LEFT JOIN dbo.Users ou ON p.OwnerUserId = ou.Id
LEFT JOIN dbo.Users leu ON p.LastEditorUserId = leu.Id
WHERE  tags.[Tag] = @Tag

SELECT @TotalCount = COUNT(*)
FROM   #PostInfo pinfo

SELECT pinfo.*
FROM   #PostInfo pinfo
ORDER BY pinfo.Id
OFFSET (@PageNumber * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY
GO

DECLARE @TotalCount INT
EXEC #GetPostsForTag @Tag = N'C#', @PageNumber = 10, @PageSize = 50, @TotalCount = @TotalCount OUTPUT
SELECT @TotalCount
GO