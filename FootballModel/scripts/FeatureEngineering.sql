
SELECT 
	gw.Season
	,gw.[GameWeekID]
	,tr.TeamSID
	,SUM(Count([MatchID])) OVER(PARTITION BY gw.Season, tr.TeamSID  ORDER BY gw.[GameWeekID] ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS FixtureCount
	,SUM(tr.GoalsFor) AS GoalsFor
	,SUM(SUM(tr.GoalsFor)) OVER(PARTITION BY gw.Season, tr.TeamSID  ORDER BY gw.[GameWeekID] ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS SeasonGoalsForRolling
	,SUM(SUM(tr.GoalsFor)) OVER(PARTITION BY gw.Season, tr.TeamSID  ORDER BY gw.[GameWeekID] ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING) AS WeekGoalsFor2
	,SUM(SUM(tr.GoalsFor)) OVER(PARTITION BY gw.Season, tr.TeamSID  ORDER BY gw.[GameWeekID] ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) AS WeekGoalsFor3
	,SUM(SUM(tr.GoalsFor)) OVER(PARTITION BY gw.Season, tr.TeamSID  ORDER BY gw.[GameWeekID] ROWS BETWEEN 6 PRECEDING AND 1 PRECEDING) AS WeekGoalsFor6
	,SUM(tr.GoalsAgainst) AS GoalsAgainst
	,SUM(SUM(tr.GoalsAgainst)) OVER(PARTITION BY gw.Season, tr.TeamSID  ORDER BY gw.[GameWeekID] ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS SeasonGoalsAgainstRolling
	,SUM(SUM(tr.GoalsAgainst)) OVER(PARTITION BY gw.Season, tr.TeamSID  ORDER BY gw.[GameWeekID] ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING) AS WeekGoalsAgainst2
	,SUM(SUM(tr.GoalsAgainst)) OVER(PARTITION BY gw.Season, tr.TeamSID  ORDER BY gw.[GameWeekID] ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) AS WeekGoalsAgainst3
	,SUM(SUM(tr.GoalsAgainst)) OVER(PARTITION BY gw.Season, tr.TeamSID  ORDER BY gw.[GameWeekID] ROWS BETWEEN 6 PRECEDING AND 1 PRECEDING) AS WeekGoalsAgainst6
	,MAX(Position) AS Position
	,MIN(MAX(Position)) OVER(PARTITION BY gw.Season, tr.TeamSID  ORDER BY gw.[GameWeekID] ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS BestPositionRolling
	,MAX(FullTimePoints) AS Points
	,SUM(MAX(FullTimePoints)) OVER(PARTITION BY gw.Season, tr.TeamSID  ORDER BY gw.[GameWeekID] ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS SeasonPointsRolling
	,SUM(MAX(FullTimePoints)) OVER(PARTITION BY gw.Season, tr.TeamSID  ORDER BY gw.[GameWeekID] ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING) AS WeekPoints2
	,SUM(MAX(FullTimePoints)) OVER(PARTITION BY gw.Season, tr.TeamSID  ORDER BY gw.[GameWeekID] ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) AS WeekPoints3
	,SUM(MAX(FullTimePoints)) OVER(PARTITION BY gw.Season, tr.TeamSID  ORDER BY gw.[GameWeekID] ROWS BETWEEN 6 PRECEDING AND 1 PRECEDING) AS WeekPoints6
	--,SUM(CASE WHEN HomeMatch=1 THEN FullTimeHomeTeamGoals ELSE 0 END) OVER(ORDER BY gw.Season, TeamSID, gw.[GameWeekID] ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS TEST
	/*
	,HomeMatch 
	,[FullTimeHomeTeamGoals]
	,[FullTimeAwayTeamGoals]
	,[FullTimeResult]
	,[HalfTimeHomeTeamGoals]
	,[HalfTimeAwayTeamGoals]
	,[HalfTimeResult]
	,[MatchRefereeSID]
	,[HomeTeamShots]
	,[AwayTeamShots]
	,[HomeTeamShotsOnTarget]
	,[AwayTeamShotsOnTarget]
	,[HomeTeamFoulsCommitted]
	,[AwayTeamFoulsCommitted]
	,[HomeTeamCorners]
	,[AwayTeamCorners]
	,[HomeTeamYellowCards]
	,[AwayTeamYellowCards]
	,[HomeTeamRedCards]
	,[AwayTeamRedCards]*/
INTO TEMP_FEATURES
FROM 
	[FantasyFootball].[dbo].[FactLeagueTeamResults]	tr
INNER JOIN [FantasyFootball].[dbo].DimGameWeek gw ON tr.GameWeekSID=gw.[GameWeekSID]
LEFT JOIN [FantasyFootball].[dbo].[FactLeagueLog] ll ON ll.TeamSID=tr.TeamSID AND ll.GameWeekSID=tr.GameWeekSID
GROUP BY tr.TeamSID, gw.Season,gw.[GameWeekID]
ORDER BY tr.TeamSID, gw.Season,gw.[GameWeekID]