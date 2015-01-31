################################################################
## Workshop: Collecting and Analyzing Social Media Data with R
## February 2nd, 2015
## Script 1: Collecting Twitter data
## Author: Pablo Barbera, NYU, @p_barbera
################################################################

setwd("~/Dropbox/git/social-media-workshop")

## INSTALLING PACKAGES THAT WE WILL USE TODAY
doInstall <- TRUE  # Change to FALSE if you don't want packages installed.
toInstall <- c("ROAuth", "twitteR", "streamR", "ggplot2", 
	"tm", "RCurl", "maps", "Snowball")
if(doInstall){install.packages(toInstall, repos = "http://cran.r-project.org")}
if(doInstall){install.packages("Rstem", 
	repos = "http://www.omegahat.org/R", type="source")}


#####################################
### CREATING YOUR OWN OAUTH TOKEN ###
#####################################

## Step 1: go to apps.twitter.com and sign in
## Step 2: click on "Create New App"
## Step 3: fill name, description, and website (it can be anything, even google.com)
##			(make sure you leave 'Callback URL' empty)
## Step 4: Agree to user conditions
## Step 5: copy consumer key and consumer secret and paste below

library(ROAuth)
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "XXXXXXXXXXXX"
consumerSecret <- "YYYYYYYYYYYYYYYYYYY"

# loading my API keys
source("priv/api-keys.r")

my_oauth <- OAuthFactory$new(consumerKey=consumerKey,
  consumerSecret=consumerSecret, requestURL=requestURL,
  accessURL=accessURL, authURL=authURL)

## run this line and go to the URL that appears on screen
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))

## testing that it works
library(twitteR)
registerTwitterOAuth(my_oauth)
searchTwitter('obama', n=1)

## now you can save oauth token for use in future sessions with twitteR or streamR
save(my_oauth, file="backup/oauth_token.Rdata")





