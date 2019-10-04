SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE #GetBadgesForDateRange
    @StartDate DATETIME,
    @EndDate DATETIME
AS
SET NOCOUNT ON

SELECT b.[Date] AS DateAwarded, u.DisplayName, b.[Name] AS BadgeName
FROM   dbo.Badges b
INNER JOIN dbo.Users u ON b.UserId = u.Id
WHERE  b.[Date] >= ISNULL(@StartDate, '1900-01-01 00:00:00')
AND    b.[Date] <= ISNULL(@EndDate, GETUTCDATE())
ORDER BY b.[Date], b.Id
GO

EXEC #GetBadgesForDateRange @StartDate = '2018-01-01 00:00:00', @EndDate = '2018-03-31 00:00:00'
GO
