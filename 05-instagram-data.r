################################################################
## Workshop: Collecting and Analyzing Social Media Data with R
## February 2nd, 2015
## Script 5: Collecting Instagram data
## Author: Pablo Barbera, NYU, @p_barbera
################################################################

setwd("~/Dropbox/git/social-media-workshop")

# Installing the package to work with Instagram data
library(devtools)
install_github("pablobarbera/instaR/instaR")

## Loading the package
library(instaR)

## Creating an OAuth token
instagram_app_id = "XXXXXXXXXXXX"
instagram_app_secret = "XXXXXXXXXXXX"
token <- instaOAuth(app_id=instagram_app_id,
                    app_secret=instagram_app_secret)

## for instructions on how to create yours
?instaOAuth

## save oauth token
save(token, file="backup/instagram-token.Rdata")

## Loading backup token for presentation
load("backup/instagram-token.Rdata")

############################################
### DOWNLOADING PICTURES USING A HASHTAG ###
############################################

euromaidan <- searchInstagram("euromaidan", token, 
	n=100, folder="euromaidan")

# descriptive statistics
table(euromaidan$filter) ## filter used in pictures
table(euromaidan$type) ## picture or video
table(!is.na(euromaidan$longitude)) ## how many are geolocated

# finding most popular pictures
euromaidan[which.max(euromaidan$likes_count),]
euromaidan[which.max(euromaidan$comments_count),]

######################################################
### SEARCH FOR PICTURES FROM A GIVEN LOCATION      ###
######################################################

# pictures around the Georgetown area
gtown <- searchInstagram(lat=38.907609, lng=-77.072258, distance=500, 
    token=token, n=100, folder="gtown")


getCommonHashtags(madrid$caption)

######################################################
### DOWNLOAD PICTURES FROM A GIVEN USER		      ###
######################################################

wh <- getUserMedia("whitehouse", token, n=200)

# finding most popular pictures
wh[which.max(wh$likes_count),]
wh[which.max(wh$comments_count),]

######################################################
### COUNTING PICTURES MENTIONING A HASHTAG	      ###
######################################################

getTagCount("euromaidan", token)
getTagCount("occupygezi", token)
getTagCount("selfie", token)



