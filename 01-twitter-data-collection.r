################################################################
## Workshop: Collecting and Analyzing Social Media Data with R
## February 2nd, 2015
## Script 1: Collecting Twitter data
## Author: Pablo Barbera, NYU, @p_barbera
################################################################

setwd("~/Dropbox/git/social-media-workshop")

## INSTALLING PACKAGES THAT WE WILL USE TODAY
doInstall <- TRUE  # Change to FALSE if you don't want packages installed.
toInstall <- c("ROAuth", "twitteR", "streamR", "ggplot2", "stringr",
	"tm", "RCurl", "maps", "Rfacebook", "topicmodels", "devtools")
if(doInstall){install.packages(toInstall, repos = "http://cran.r-project.org")}


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

## this is how we would load it in memory
load("backup/oauth_token.Rdata")

#####################################
### COLLECTING USER INFORMATION   ###
#####################################

library(twitteR)

# profile information
user <- getUser('barackobama')
user$toDataFrame()

# followers
user$getFollowers(n=10)
# (10 most recent followers)

# friends (who they follow)
user$getFriends(n=10)

# see also smappR package (https://github.com/SMAPPNYU/smappR) for additional
# functions to download users' data for a large number of users

#####################################
### SEARCH RECENT TWEETS		  ###
#####################################

# basic searches by keywords
tweets <- searchTwitter("obama", n=20)
# convert to data frame
tweets <- twListToDF(tweets)

# but NOTE: limited to most recent ~3000 tweets in the past few days!
tweets <- searchTwitter("#APSA2014")
tweets <- searchTwitter("#PoliSciNSF")
tweets <- twListToDF(tweets)
tweets$created

#############################################
### DOWNLOADING RECENT TWEETS FROM A USER ###
#############################################

## Here's how you can capture the most recent tweets (up to 3,200)
## of any given user (in this case, @nytimes)

## you can do this with twitteR
timeline <- userTimeline('nytimes', n=20)
timeline <- twListToDF(timeline)

## but I have written my own function so that I can store the raw JSON data
source("functions.r")

getTimeline(filename="tweets_nytimes.json", screen_name="nytimes", 
    n=1000, oauth=my_oauth, trim_user="false")

# it's stored in disk and I can read it with the 'parseTweets' function in
# the streamR package
library(streamR)
tweets <- parseTweets("tweets_nytimes.json")

# see again smappR package (https://github.com/SMAPPNYU/smappR) for more

###############################################
### COLLECTING TWEETS FILTERING BY KEYWORDS ###
###############################################

library(streamR)

filterStream(file.name="obama_tweets.json", track="obama", 
    timeout=60, oauth=my_oauth)

## Note the options:
## FILE.NAME indicates the file in your disk where the tweets will be downloaded
## TRACK is the keyword(s) mentioned in the tweets we want to capture.
## TIMEOUT is the number of seconds that the connection will remain open
## OAUTH is the OAuth token we are using

## Once it has finished, we can open it in R as a data frame with the
## "parseTweets" function
tweets <- parseTweets("obama_tweets.json")

## This is how we would capture tweets mentioning multiple keywords:
filterStream(file.name="political_tweets.json", 
	track=c("obama", "bush", "clinton"),
    tweets=100, oauth=my_oauth)

###############################################
### COLLECTING TWEETS FILTERING BY LOCATION ###
###############################################

## This second example shows how to collect tweets filtering by location
## instead. In other words, we can set a geographical box and collect
## only the tweets that are coming from that area.

## For example, imagine we want to collect tweets from the Arabian Peninsula.
## The way to do it is to find two pairs of coordinates (longitude and latitude)
## that indicate the southwest corner AND the northeast corner.
## (NOTE THE REVERSE ORDER, IT'S NOT LAT, LONG BUT LONG, LAT)
## In the case of the US, it would be approx. (-125,25) and (-66,50)
## How to find the coordinates? I use: http://itouchmap.com/latlong.html

filterStream(file.name="tweets_geo.json", locations=c(-125, 25, -66, 50), 
    timeout=60, oauth=my_oauth)

## Note that now we choose a different option, "TIMEOUT", which indicates for
## how many seconds we're going to keep open the connection to Twitter.

## But we could have chosen also tweets=100 instead

## We can do as before and open the tweets in R
tweets <- parseTweets("tweets_geo.json")

############################################
### COLLECTING A RANDOM SAMPLE OF TWEETS ###
############################################

## It's also possible to collect a random sample of tweets. That's what
## the "sampleStream" function does:

sampleStream(file.name="tweets_random.json", timeout=30, oauth=my_oauth)

## Here I'm collecting 30 seconds of tweets
## And once again, to open the tweets in R...
tweets <- parseTweets("tweets_random.json")

## What are the most common hashtags right now?
getCommonHashtags(tweets$text)

## What is the most retweeted tweet?
tweets[which.max(tweets$retweet_count),]





