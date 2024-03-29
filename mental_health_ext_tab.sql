---------------------------------Depression and Mental Health Data Analysis----------------------------------------

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 FIRST_ROW = 2,
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'container04_dls01project_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [container04_dls01project_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://container04@dls01project.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE dbo.mental_health_ext_tab (
	[Age] nvarchar(40),
	[Gender] nvarchar(400),
	[Occupation] nvarchar(400),
	[Days_Indoors] nvarchar(400),
	[Growing_Stress] nvarchar(400),
	[Quarantine_Frustrations] nvarchar(400),
	[Changes_Habits] nvarchar(400),
	[Mental_Health_History] nvarchar(400),
	[Weight_Change] nvarchar(400),
	[Mood_Swings] nvarchar(400),
	[Coping_Struggles] nvarchar(400),
	[Work_Interest] nvarchar(400),
	[Social_Weakness] nvarchar(400)
	)
	WITH (
	LOCATION = 'mental_health_data/mental_health.csv',
	DATA_SOURCE = [container04_dls01project_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.mental_health_ext_tab
GO;


--Age distribution
select 
	Age,
	Count(age) as total
from mental_health_ext_tab
group by [Age]
order by total desc;

--Gender and Age Distribution
select
	Gender,
	Age,
	COUNT(*) as total
from mental_health_ext_tab
GROUP by gender, [Age] 
order by total desc;

-- Most common occupation
select 
	[Occupation],
	COUNT([Occupation]) as Total
FROM mental_health_ext_tab
GROUP by [Occupation]
ORDER by total DESC;

--Mental Health History 
SELECT
	[Mental_Health_History],
	COUNT([Mental_Health_History]) as Total
From mental_health_ext_tab
GROUP by [Mental_Health_History]
ORDER by Total DESC;


--Distribution of Work Interest
SELECT
	[Work_Interest],
	COUNT([Work_Interest]) as Total
From mental_health_ext_tab
GROUP by [Work_Interest]
ORDER by Total DESC;

--Distribution of Coping Struggles
SELECT
	[Coping_Struggles],
	COUNT([Coping_Struggles]) as Total
From mental_health_ext_tab
GROUP by [Coping_Struggles]
ORDER by Total DESC;

--Distribution of Quarantine Frustrations by Mood Swings
SELECT
	[Mood_Swings],
	[Quarantine_Frustrations],
	COUNT(*) as Total
FROM mental_health_ext_tab
GROUP by [Mood_Swings],[Quarantine_Frustrations]
ORDER by Total DESC;

--Distribution of Weight Change
SELECT
	[Weight_Change],
	COUNT([Weight_Change]) as Total
From mental_health_ext_tab
GROUP by [Weight_Change]
ORDER by Total DESC;

--Distribution of Quarantine Frustrations
SELECT
	[Quarantine_Frustrations],
	COUNT([Quarantine_Frustrations]) as Total
From mental_health_ext_tab
GROUP by [Quarantine_Frustrations]
ORDER by Total DESC;

--Relationships between Work Interest, Mood Swings, and Social Weakness
SELECT
	[Work_Interest],
	[Mood_Swings],
	[Social_Weakness],
	COUNT(*) as Total
From mental_health_ext_tab
GROUP by [Work_Interest], [Mood_Swings], [Social_Weakness] 
ORDER by Total DESC;
