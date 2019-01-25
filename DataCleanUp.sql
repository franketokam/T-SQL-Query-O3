 use [User_FT]
 go
  
 
 ---- USE THE LATEST PUBLISHED VERSION on plateform AND DOWNLOAD DECISION DETAIL AND RULE DETAIL REPORTS 
 
 ---- RUN QUERY BELOW TO CONVERT [END DATE], [START DATE] AND [DATE CHANGED] FROM EU DATE FORMAT TO US DATE FORMAT

 UPDATE RDR
 SET 
[End Date]=
	CASE WHEN [End Date] NOT LIKE '%N/A%' THEN SUBSTRING([End Date],4,2) + '/' + LEFT([End Date],2) + '/' +  RIGHT([End Date],4) ELSE NULL END,
[Start Date]=
	CASE WHEN [Start Date] NOT LIKE '%N/A%' THEN SUBSTRING([Start Date],4,2) + '/' + LEFT([Start Date],2) + '/' +  RIGHT([Start Date],4) ELSE NULL END,
[Date Changed]=
	CASE WHEN [Date Changed] NOT LIKE '%N/A%' THEN SUBSTRING([Date Changed],4,2) + '/' + LEFT([Date Changed],2) + '/' +  RIGHT([Date Changed],4) ELSE NULL END
--- SELECT *
FROM [dbo].[Rule Details Report] RDR
 
 ---- RUN QUERY BELOW TO CONVERT [DATE CHANGED] FROM EU DATE FORMAT TO US DATE FORMAT AND PARSE [DECISION EXPRESSION] TO GET LEADLIST NAME

UPDATE DDR
 SET 
 [Date Changed]=
	CASE WHEN [Date Changed] NOT LIKE '%N/A%' THEN SUBSTRING([Date Changed],4,2) + '/' + LEFT([Date Changed],2) + '/' +  RIGHT([Date Changed],4) ELSE NULL END
,[Decision Expression] =
   CASE WHEN [Decision Expression] LIKE '%"FACT.LEADLIST.SPA_NUMBER\"%' THEN ltrim(substring ([Decision Expression], charindex('.txt', [Decision Expression]) - 19, 23)) ELSE NULL END
--- SELECT *
FROM  [dbo].[Decision Details Report] DDR

 ---- RUN QUERY BELOW TO DELETE EXTRA CHARACTERS IN THE [DECISION EXPRESSION]

UPDATE DDR
SET [Decision Expression] = REPLACE(REPLACE(REPLACE(REPLACE([Decision Expression], '\', ''), '"', ''), ':', ''), 'e\', '')  
--- SELECT *
FROM  [dbo].[Decision Details Report] DDR
WHERE [Decision Expression] IS NOT NULL

 ---- RUN QUERY BELOW TO GET DATA THAT NEEDS TO BE DELETED on platform

 SELECT [Rule Folder] as [View]
		,[Live Area]
		,RDR.[Decision Name]
		,[Content Name] as [Message]
		,[End Date]
		,[Decision Expression] as [LeadList] 
  FROM [dbo].[Rule Details Report] RDR
  inner join [dbo].[Decision Details Report] DDR
  on RDR.[Decision Name] = DDR.[Decision Name]
  where RDR.[End Date] is not null and RDR.[End Date] <> '02/28/2019'
  order by [End Date] asc



/*
  DELETE FROM [dbo].[Rule Details Report]

  DELETE FROM [dbo].[Decision Details Report]

   SELECT *
   From [dbo].[Rule Details Report]

   SELECT *
   From [dbo].[Decision Details Report]
*/



  
