USE [FantasyFootball]
GO

/****** Object:  Table [dbo].[D_Events]    Script Date: 4/11/2017 10:57:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DimGameWeek](
	[GameWeekSID] [int] IDENTITY(1,1) NOT NULL,
	[GameWeekID] [int] NULL,
	[GameWeekName] [varchar](255) NULL,
	[Season] [varchar](255) NULL,
	[SeasonURLCode] [int] NULL,
	[Finished] [bit] NULL,
	[GameWeekStart] [datetime] NULL,
	[GameWeekEnd] [datetime] NULL,
	[DateLoaded] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[GameWeekSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[DimGameWeek] ADD  DEFAULT (getdate()) FOR [DateLoaded]
GO

--INSERT INTO [dbo].[DimGameWeek] ([GameWeekID], [GameWeekName],	[Season], [Finished])
--VALUES (0, 'Default', 'Default', 1)
--GO

CREATE TABLE [dbo].[DimTeams](
	[TeamsSID] [int] IDENTITY(1,1) NOT NULL,
	[TeamName] [varchar](255) NULL,
	[ShortName] [varchar](255) NULL,
	[AlternativeName] [varchar](255) NULL,
	[Stadium] [varchar](255) NULL,
	[FantasyCode] [int] NULL,
	[Valid] [bit] NOT NULL,
	[ExpiryDate] [datetime] NULL,
	[DateLoaded] [datetime] NULL,
	[DateUpdated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[TeamsSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[DimTeams] ADD  DEFAULT ((1)) FOR [Valid]
GO

ALTER TABLE [dbo].[DimTeams] ADD  DEFAULT (getdate()) FOR [DateLoaded]
GO

ALTER TABLE [dbo].[DimTeams] ADD TeamSeasonID INT NULL

CREATE TABLE [dbo].[FactLeagueLog]
(
	LogSID INT IDENTITY(1,1)  PRIMARY KEY,
	GameWeekSID INT NOT NULL,
	TeamSID INT NOT NULL, 
	Position INT NULL,
	Played INT NULL,
	Won INT NULL,
	Drawn INT NULL,
	Lost INT NULL,
	GoalsFor INT NULL,
	GoalsAgainst INT NULL,
	GoalDifference INT NULL,
	Points INT NULL,
	DateLoaded [datetime] NULL,
	CONSTRAINT FK_Log_Team FOREIGN KEY (TeamSID) REFERENCES dbo.DimTeams(TeamSID),
	CONSTRAINT FK_Log_GameWeek FOREIGN KEY (GameWeekSID) REFERENCES dbo.DimGameWeek(GameWeekSID)
);
GO

ALTER TABLE [dbo].[FactLeagueLog] ADD  DEFAULT (getdate()) FOR [DateLoaded]
GO

CREATE TABLE 
	dbo.FactLeagueMatches
(
	MatchID INT IDENTITY(1,1) PRIMARY KEY,
	GameWeekSID INT NOT NULL,
	HomeTeamSID INT NOT NULL,
	AwayTeamSID INT NOT NULL,
	HomeTeamScore INT NULL,
	AwayTeamScore INT NULL
)
	
/*
	Staging 
*/

USE [FantasyFootballStaging]
GO

CREATE TABLE [dbo].[S_FactLeagueLog]
(
	Team VARCHAR(100) NOT NULL,
	Season VARCHAR(100) NOT NULL,
	GameWeek INT NOT NULL, 
	Position INT NULL,
	Played INT NULL,
	Won INT NULL,
	Drawn INT NULL,
	Lost INT NULL,
	GoalsFor INT NULL,
	GoalsAgainst INT NULL,
	GoalDifference INT NULL,
	Points INT NULL,
	ImportedDate [DATETIME] DEFAULT CURRENT_TIMESTAMP,
	Loaded BIT NULL,
	LoadedDate [DATETIME],
);
GO

CREATE PROC 
	dbo.LoadLeagueLog 
AS
BEGIN

	SET NOCOUNT ON

	SELECT 
	  dt.TeamSID
	  ,fll.Team
      ,gw.GameWeekSID
	  ,fll.Season
	  ,fll.GameWeek
      ,[Position]
      ,[Played]
      ,[Won]
      ,[Drawn]
      ,[Lost]
      ,[GoalsFor]
      ,[GoalsAgainst]
      ,[GoalDifference]
      ,[Points]
	INTO #TempLog
	FROM [dbo].[S_FactLeagueLog] fll
	INNER JOIN [FantasyFootball].[dbo].[DimTeams] dt ON (fll.Team = dt.TeamName OR fll.Team = dt.AlternativeName)
	INNER JOIN [FantasyFootball].[dbo].[DimGameWeek] gw ON fll.Season = gw.SeasonURLCode  AND fll.GameWeek = gw.GameWeekID
	WHERE Loaded IS NULL

	INSERT INTO [FantasyFootball].[dbo].[FactLeagueLog]
	([GameWeekSID],[TeamSID],[Position],[Played],[Won],[Drawn],[Lost],[GoalsFor],[GoalsAgainst],[GoalDifference],[Points])
	SELECT 
		GameWeekSID 
		,[TeamSID]
		,[Position]
		,[Played]
		,[Won]
		,[Drawn]
		,[Lost]
		,[GoalsFor]
		,[GoalsAgainst]
		,[GoalDifference]
		,[Points] 
	FROM #TempLog

	UPDATE [dbo].[S_FactLeagueLog] 
	SET 
		Loaded=1,  
		LoadedDate= CURRENT_TIMESTAMP 
	WHERE CONCAT(Team, Season, GameWeek) IN (SELECT CONCAT(Team, Season, GameWeek) AS KeyC FROM #TempLog)

	DROP TABLE #TempLog
END
GO

CREATE TABLE [dbo].[S_FactTeamForm](
	[name] [varchar](255) NULL,
	[code] [int] NULL,
	[strength_overall_home] [int] NULL,
	[strength_overall_away] [int] NULL,
	[strength_attack_home] [int] NULL,
	[strength_attack_away] [int] NULL,
	[strength_defence_home] [int] NULL,
	[strength_defence_away] [int] NULL,
	[Loaded] BIT, 
	[DateLoaded] [datetime] NULL DEFAULT CURRENT_TIMESTAMP
) ON [PRIMARY]
GO


CREATE PROC 
	[dbo].[LoadPlayersDimension]
/*
	Pull from staging and create a SCD2 player dimension

	Notes:
	Need to confirm the sc2 fields
*/
AS

	SET NOCOUNT ON

	SELECT
		[id]
      ,[photo]
      ,[web_name]
	  ,team_code
      ,t.TeamSID
      ,[status]
      ,[first_name]
      ,[second_name]
      ,[squad_number]
      ,[singular_name]
      ,[singular_name_short]
      ,[plural_name]
      ,[plural_name_short]
      ,[name]
      ,[short_name]
	INTO
		#TempPlayers
	FROM
		FantasyFootballStaging.dbo.S_Players p
	LEFT JOIN 
		FantasyFootball.dbo.DimTeams t ON t.FantasyCode = p.team_code

	MERGE FantasyFootball.dbo.DimPlayers dt
	USING #TempPlayers st
		ON dt.PlayerID = st.id
	WHEN NOT MATCHED THEN 
		INSERT([PlayerID],[Photo],[WebName],[TeamSID],[Status],[FirstName],[SecondName],[SquadNumber],[PositionSingularName],[PositionSingularNameShort],[PositionPluralName],[PositionPluralNameShort])
		VALUES([id],[photo],[web_name],[TeamSID],[status],[first_name],[second_name],[squad_number],[singular_name],[singular_name_short],[plural_name],[plural_name_short])
	WHEN MATCHED AND (dt.[TeamSID] <> st.[TeamSID] OR dt.[PositionSingularName] <> st.[singular_name]) AND dt.Valid = 1 THEN
		UPDATE SET
			dt.Valid = 0 ,
			dt.ExpiryDate = CURRENT_TIMESTAMP,
			dt.[DateUpdated] = CURRENT_TIMESTAMP
	;

	MERGE FantasyFootball.dbo.DimPlayers dt
	USING #TempPlayers st
		ON dt.PlayerID = st.id AND
			dt.[TeamSID] = st.[TeamSID] AND 
			dt.[PositionSingularName] = st.[singular_name]
	WHEN NOT MATCHED THEN 
		INSERT([PlayerID],[Photo],[WebName],[TeamSID],[Status],[FirstName],[SecondName],[SquadNumber],[PositionSingularName],[PositionSingularNameShort],[PositionPluralName],[PositionPluralNameShort])
		VALUES([id],[photo],[web_name],[TeamSID],[status],[first_name],[second_name],[squad_number],[singular_name],[singular_name_short],[plural_name],[plural_name_short])
	;
		
    DROP TABLE #TempPlayers
GO


CREATE PROC 
	dbo.LoadLeagueMatches
AS
BEGIN
	SET NOCOUNT ON 

	--Cant truncate once got history. need to think of a way to load new fixtures. merge on gameweekid
	TRUNCATE TABLE [FantasyFootball].[dbo].[FactLeagueMatches]
	
	SELECT
	   [rownames]
      ,[GameWeek]
	  ,gw.GameWeekSID
      ,[kickoff_time_formatted]
      ,[kickoff_time]
	  ,ht.TeamSID as HomeTeamSID
	  ,awt.TeamSID as AwayTeamSID
	  ,ht.TeamName as HomeTeamName
	  ,awt.TeamName as AwayTeamName
      ,[team_h]
	  ,[team_a]
      ,[code]
      ,[team_a_score]
      ,[team_h_score]
      ,[event]
	INTO #Fixtures
	FROM [FantasyFootballStaging].[dbo].[S_FactLeagueMatches] flm
	LEFT JOIN [FantasyFootball].dbo.DimGameWeek gw ON gw.GameWeekID=flm.GameWeek and gw.Season='2016/17'
	LEFT JOIN  [FantasyFootball].dbo.DimTeams ht ON ht.TeamSeasonID=flm.team_h
	LEFT JOIN  [FantasyFootball].dbo.DimTeams awt ON awt.TeamSeasonID=flm.team_a

	INSERT INTO [FantasyFootball].[dbo].[FactLeagueMatches]
	([GameWeekSID],[HomeTeamSID],[AwayTeamSID],[HomeTeamScore],[AwayTeamScore])
	SELECT
		 [GameWeekSID],[HomeTeamSID],[AwayTeamSID],[team_h_score],[team_a_score]
	FROM
		#Fixtures
		
END