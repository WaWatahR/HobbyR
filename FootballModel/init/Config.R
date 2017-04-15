library("lme4")
library("nnet")
library("httr")
library("jsonlite")
library("RODBC")
library("scales")
library("rvest")
library("RSelenium")

# Load Utility functions
source("./utilities/SaveData.R")

# Parameters
dblive = odbcDriverConnect('driver={SQL Server};server=localhost;database=FantasyFootball', case="nochange")
dbstg = odbcDriverConnect('driver={SQL Server};server=localhost;database=FantasyFootballStaging', case="nochange")

rD = rsDriver(port = 4569L, browser='phantomjs')
htmlsession <- rD[["client"]]

rD[["server"]]$stop() 