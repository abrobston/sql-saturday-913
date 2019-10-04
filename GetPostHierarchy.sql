SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE #GetPostHierarchy
	@PostId INT
AS
SET NOCOUNT ON

;WITH Ancestors AS
(
	SELECT p.Id, p.Title, p.Body, p.AnswerCount, p.CommentCount, p.CreationDate, p.OwnerUserId, p.ParentId, pt.[Type] AS PostType
	FROM   dbo.Posts p
	INNER JOIN dbo.PostTypes pt ON p.PostTypeId = pt.Id
	WHERE  p.Id = @PostId
	UNION ALL
	SELECT p.Id, p.Title, p.Body, p.AnswerCount, p.CommentCount, p.CreationDate, p.OwnerUserId, p.ParentId, pt.[Type] AS PostType
	FROM   dbo.Posts p
	INNER JOIN dbo.PostTypes pt ON p.PostTypeId = pt.Id
	INNER JOIN Ancestors a ON p.Id = a.ParentId
),
Descendants AS
(
	SELECT p.Id, p.Title, p.Body, p.AnswerCount, p.CommentCount, p.CreationDate, p.OwnerUserId, p.ParentId, pt.[Type] AS PostType
	FROM   dbo.Posts p
	INNER JOIN dbo.PostTypes pt ON p.PostTypeId = pt.Id
	WHERE  p.ParentId = @PostId
	UNION ALL
	SELECT p.Id, p.Title, p.Body, p.AnswerCount, p.CommentCount, p.CreationDate, p.OwnerUserId, p.ParentId, pt.[Type] AS PostTyppe
	FROM   dbo.Posts p
	INNER JOIN dbo.PostTypes pt ON p.PostTypeId = pt.Id
	INNER JOIN Descendants d ON p.ParentId = d.Id
)
SELECT a.*
FROM   Ancestors a
UNION
SELECT d.*
FROM   Descendants d
GO

EXEC #GetPostHierarchy @PostId = 17
GO