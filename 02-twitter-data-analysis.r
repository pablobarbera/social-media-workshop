################################################################
## Workshop: Collecting and Analyzing Social Media Data with R
## February 2nd, 2015
## Script 2: Analyzing Twitter data
## Author: Pablo Barbera, NYU, @p_barbera
################################################################

setwd("~/Dropbox/git/social-media-workshop")

# Loading libraries we will use
library(streamR)
library(ggplot2)
library(grid)
library(maps)

###############################################
### WORKING WITH GEOLOCATED TWEETS			###
###############################################

# read in memory the geolocated tweets we collected before
tweets <- parseTweets("tweets_geo.json")

# keeping only geolocated tweets with precise long/lat information
tweets <- tweets[!is.na(tweets$lon),]

## Now we create a data frame with the map data 
map.data <- map_data("state")

# And finally we use ggplot2 to draw the map:
# 1) map base
ggplot(map.data) + geom_map(aes(map_id = region), map = map.data, fill = "grey90", 
    color = "grey50", size = 0.25) + expand_limits(x = map.data$long, y = map.data$lat) + 
    # 2) limits for x and y axis
    scale_x_continuous(limits=c(-125,-66)) + scale_y_continuous(limits=c(25,50)) +
    # 3) adding the dot for each tweet
    geom_point(data = tweets, 
    aes(x = lon, y = lat), size = 1, alpha = 1/5, color = "darkblue") +
    # 4) removing unnecessary graph elements
    theme(axis.line = element_blank(), 
    	axis.text = element_blank(), 
    	axis.ticks = element_blank(), 
        axis.title = element_blank(), 
        panel.background = element_blank(), 
        panel.border = element_blank(), 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        plot.background = element_blank()) 

# How many tweets are coming from each state?
states <- map.where(database="state", x=tweets$lon, y=tweets$lat)
head(sort(table(states), decreasing=TRUE))

###############################################
### SENTIMENT ANALYSIS						###
###############################################

# Loading tweets we will use
tweets <- parseTweets("obama_tweets.json")

# loading lexicon of positive and negative words (from Neal Caren)
lexicon <- read.csv("lexicon.csv", stringsAsFactors=F)
pos.words <- lexicon$word[lexicon$polarity=="positive"]
neg.words <- lexicon$word[lexicon$polarity=="negative"]

# a look at a random sample of positive and negative words
sample(pos.words, 10)
sample(neg.words, 10)

# function to clean the text
clean_tweets <- function(text){
    # loading required packages
    lapply(c("tm", "Rstem", "stringr"), require, c=T, q=T)
    # avoid encoding issues by dropping non-unicode characters
    utf8text <- iconv(text, to='UTF-8-MAC', sub = "byte")
    # remove punctuation and convert to lower case
    words <- removePunctuation(utf8text)
    words <- tolower(words)
    # spliting in words
    words <- str_split(words, " ")
    return(words)
}

# now we clean the text
tweets$text[1]
tweets$text[2]

text <- clean_tweets(tweets$text)
text[[1]]
text[[2]]

# a function to classify individual tweets
classify <- function(words, pos.words, neg.words){
    # count number of positive and negative word matches
    pos.matches <- sum(words %in% pos.words)
    neg.matches <- sum(words %in% neg.words)
    return(pos.matches - neg.matches)
}

# this is how we would apply it
classify(text[[1]], pos.words, neg.words)
classify(text[[2]], pos.words, neg.words)

# but we want to aggregate over many tweets...
classifier <- function(text, pos.words, neg.words){
    # classifier
    scores <- unlist(lapply(text, classify, pos.words, neg.words))
    n <- length(scores)
    positive <- as.integer(length(which(scores>0))/n*100)
    negative <- as.integer(length(which(scores<0))/n*100)
    neutral <- 100 - positive - negative
    cat(n, "tweets:", positive, "% positive,",
        negative, "% negative,", neutral, "% neutral")
}

# applying classifier function
classifier(text, pos.words, neg.words)






