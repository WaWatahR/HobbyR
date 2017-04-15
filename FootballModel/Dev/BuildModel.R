BuildModel = function(data){
    m = multinom(FullTimeResult ~ `Bet365HomeWinOdds` 
                 + `Bet365DrawOdds` 
                 + `Bet365AwayWinOdds` 
                 + `Bet&WinHomeWinOdds` 
                 + `Bet&WinDrawOdds` 
                 + `Bet&WinAwayWinOdds` 
                 + `InterwettenHomeWinOdds`,
        data = data,
        family = binomial)
    return(m)
}

model = BuildModel(data)