USE [GVLHR]
GO

/****** Object:  View [dbo].[vwColumnInfo]    Script Date: 13/04/2021 16:42:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vwColumnInfo]
AS
SELECT *, 'public ' + DATA_TYPE_CODE + ' ' + COLUMN_NAME +  ' { get; set; }' MODEL_PROPERTY FROM
(
	SELECT
		TABLE_NAME, COLUMN_NAME, DATA_TYPE, 
		' m.'+ COLUMN_NAME +' = entity.'+ COLUMN_NAME +';' EntityToModel,
		' entity.'+ COLUMN_NAME +' = m.'+ COLUMN_NAME +';' ModelToEntity,
		'{ "data": "'+ COLUMN_NAME +'" },' DataTable,
		'<th style="font-size:14px">'+ COLUMN_NAME +'</th>' HTMLHeader,
		CAST((CASE IS_NULLABLE WHEN 'YES' THEN 1 ELSE 0 END) AS bit) AS ISNULLABLE, CHARACTER_MAXIMUM_LENGTH,
		CASE DATA_TYPE 
			WHEN 'int' THEN 'int'
			WHEN 'bigint' THEN 'long'
			WHEN 'float' THEN 'float'
			WHEN 'decimal' THEN 'decimal'
			WHEN 'varchar' THEN 'string'
			WHEN 'nvarchar' THEN 'string'
			WHEN 'text' THEN 'string'
			WHEN 'char' THEN 'string'
			WHEN 'bit' THEN 'bool'
			WHEN 'smalldatetime' THEN 'DateTime'
			WHEN 'datetime' THEN 'DateTime'
			WHEN 'uniqueidentifier' THEN 'Guid'
			ELSE ''
		END DATA_TYPE_CODE,
		'this.' + COLUMN_NAME + ' = dr.GetString();' DataReader,
		'cm.Parameters.AddWithValue("@' + COLUMN_NAME + '", model.' + COLUMN_NAME + ');' ExecuteCommand,
		COLUMN_NAME + ' = @' + COLUMN_NAME + ','  UpdateCommand,
		CASE
           WHEN CHARACTER_MAXIMUM_LENGTH IS NULL
           THEN COLUMN_NAME + ' ' + DATA_TYPE +','
           ELSE COLUMN_NAME + ' ' + DATA_TYPE + '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR(100)) + ')' +','
       END CreateTable
	FROM    
		INFORMATION_SCHEMA.COLUMNS
) A  
GO


