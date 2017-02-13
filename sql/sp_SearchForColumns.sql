IF OBJECT_ID('SP_SearchForColumn','P') IS NOT NULL 
    DROP PROCEDURE SP_SearchForColumn
GO 
CREATE PROCEDURE SP_SearchForColumn 
@Sarake NVARCHAR(500)
AS 

SET NOCOUNT ON 

-- table data
DECLARE @Tables TABLE (
	db VARCHAR(MAX),
	tableowner VARCHAR(MAX),
	tablename VARCHAR(MAX),
	tabletype VARCHAR(MAX),
	info VARCHAR(MAX)
)

BEGIN
	-- tables where column is searched
	INSERT @Tables
	EXEC sp_TABLEs @TABLE_owner = 'dbo', @TABLE_type = "'TABLE'"; 
END

DECLARE @tmptablename VARCHAR(MAX)

WHILE EXISTS (SELECT 1 FROM @Tables WHERE ISNULL(info, 0) = 0)
BEGIN
	SELECT TOP 1 @tmptablename = tablename  
	  FROM @Tables  
		WHERE ISNULL(info ,0) = 0 		
	IF EXISTS(
		SELECT *
		FROM sys.columns 
		WHERE Name      = @Sarake
		  AND Object_ID = Object_ID(@tmptablename))
	BEGIN	
		BEGIN 				
			PRINT @tmptablename + ' table has a column ' + @Sarake
		END			
	END
	UPDATE @Tables 
		SET info = '1' 
		WHERE tablename = @tmptablename	
END
SET NOCOUNT OFF
