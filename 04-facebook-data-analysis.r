################################################################
## Workshop: Collecting and Analyzing Social Media Data with R
## February 2nd, 2015
## Script 4: Analyzing Facebook data
## Author: Pablo Barbera, NYU, @p_barbera
################################################################

setwd("~/Dropbox/git/social-media-workshop")

###############################################
### SCRAPING LIST OF MEMBERS OF CONGRESS  	###
###############################################

# reading additional functions and API keys
source("functions.r")
source("priv/api-keys.r")

# scraping NYT API 
house <- scrape_nytimes_congress_api(api_key, chamber="house")
senate <- scrape_nytimes_congress_api(api_key, chamber="senate")
congress <- rbind(house, senate)

table(congress$facebook_account=="")

# keeping only members of congress with FB accounts
congress <- congress[congress$facebook_account!="",]
write.csv(congress, file="data/congress.csv", row.names=FALSE)


###########################################################
### COLLECTING FB PAGE DATA FOR MEMBERS OF CONGRESS  	###
###########################################################

library(Rfacebook)

# list of accounts
accounts <- congress$facebook_account

# removing those already downloaded
accounts.done <- list.files("data/facebook")
accounts.left <- accounts[tolower(accounts) %in% tolower(gsub(".csv", "", accounts.done)) == FALSE]

# loop over accounts
for (account in accounts.left){
    cat(account, "\n")

    # download page data (with error handling)
    error <- tryCatch(df <- getPage(account, token=fb_oauth, n=5000, since='2013/01/01'),
    	error=function(e) e)
    if (inherits(error, 'error')){ next }
    
    ## cleaning text from \n
    df$message <- gsub("\n", " ", df$message)

    ## save page data in R and csv format
    save(df, file=paste0("data/raw_fb/", account, ".Rdata"))
    write.csv(df, file=paste0("data/facebook/", account, ".csv"),
        row.names=F)
}

###########################################################
### MERGING AND CLEANING TEXT FROM FACEBOOK PAGES  		###
###########################################################

# list of files (one per MC)
accounts <- list.files("data/facebook", full.names=TRUE)

# function to read the file and clean the text
clean_fb_text <- function(f){
    require(tm); require(stringr)
    # read file
    d <- read.csv(f, stringsAsFactors=F)
    # remove posts with no message
    d <- d[!is.na(d$message) & d$message!="",]
    # avoid encoding issues by dropping non-unicode characters
    utf8text <- iconv(d$message, to='UTF-8-MAC', sub = "byte")
    # cleaning text
    text <- removePunctuation(removeNumbers(tolower(utf8text)))
    removeURL <- function(x) gsub('"(http.*) |(http.*)$|\n', "", x)
    text <- removeURL(text)
    # putting it all together
    text <- paste0(text, collapse=" ")
    return(text)
}

# and now we apply it to all files 
# (note that this can take a few minutes)
txt <- lapply(accounts, clean_fb_text)
# and convert it to a vector
txt <- unlist(txt)

save(txt, file="backup/congress-fb-data.rdata")


###########################################################
### RUNNING TOPIC MODEL                                ###
###########################################################

load("backup/congress-fb-data.rdata")

# loading library to convert text into matrix
library(tm); library(stringr)

# reading text into Corpus object
txt <- Corpus(VectorSource(txt))
txt

# and now converting to matrix (sparse representation)
dtm <- DocumentTermMatrix(txt, 
    control=list(minWordLength=3, 
        stopwords = c(stopwords("en"), "can", "will", "get",
            "make", "must", "new", "one", "said",
            "like", "think", "great", "american",
            "american", "americans", "congress",
            "today", "sen", "house", "senate",
            unlist(str_split(tolower(state.name), " ")))))
dtm

# remove sparse terms (infrequent words)
dtm <- removeSparseTerms(dtm, 0.90) 
dtm
# keep words that appear in more than 10% of pages

# loading library to run the topic model
library(topicmodels)

# running LDA
lda <- LDA(dtm, k=50, method="Gibbs",
        control=list(verbose=1L, iter=50))

save(lda, file="backup/lda-output.Rdata")

###########################################################
### INTERPRETING RESULTS OF TOPIC MODEL                 ###
###########################################################

load("backup/lda-output.Rdata")

# top word associated to each topic
terms(lda)

# top 10 words associated to each topic
trms <- t(terms(lda, k=10))

# some topics are easy to identify
trms[4,] # TV appearances
trms[7,] # economic prosperity
trms[8,] # bipartisan issues
trms[9,] # natural resources
trms[15,] # civil rights
trms[17,] # spending cuts
trms[31,] # foreign policy
trms[40,] # community events
trms[42,] # "spread the word"
trms[43,] # small business
trms[45,] # military
trms[49,] # Health care (ACA)

# some of these are pretty interesting
trms[35,] # immigration reform
trms[22,] # "illegal" immigration

# merging with Congress data:
# 1) reading congress data
congress <- read.csv("data/congress.csv", stringsAsFactors=F)
# 2) reading list of files
accounts <- tolower(gsub(".csv", "", list.files("data/facebook")))
# 3) keeping members of congress with data
congress <- congress[tolower(congress$facebook_account) %in% tolower(accounts),]
# 4) putting in same order as our dataset
congress <- congress[order(congress$facebook_account),]

# matrix with topic distributions
mat <- lda@gamma
dim(mat)
mat[1:5, 1:5]
# i.e.: Member of Congress 1 is talking 3.4% of the time about Topic 1


# who is the Member of Congress that talks more about...
# immigration?
congress[which.max(mat[,35]),] # immigration reform
congress[which.max(mat[,22]),] # "illegal" immigration
# agriculture?
congress[which.max(mat[,23]),]
# spending cuts?
congress[which.max(mat[,17]),]

# looking at differences across parties
republicans <- which(congress$party=="R")
democrats <- which(congress$party=="D")
rep.props <- apply(lda@gamma[republicans,], 2, mean)
dem.props <- apply(lda@gamma[democrats,], 2, mean)
ratio <- rep.props / (dem.props + rep.props)

# % of topic usage by party
ratio[35] # immigration reform
ratio[22] # "illegal" immigration
ratio[8] # bipartisan
ratio[15] # civil rights
ratio[45] # military
ratio[31] # foreign policy

# bar plots for a selection of topics
sbs <- c(4, 8, 9, 15, 49, 7, 31, 40, 43, 45, 35, 22)

df <- data.frame(
    prop = c(ratio[sbs], 1-ratio[sbs]),
    party = rep(c("Republicans", "Democrats"), each=12),
    label = rep(c(
        "TV appearances", "Bipartisan issues", "Natural resources",
        "Civil rights", "Health care", "Economic prosperity", 
        "Foreign policy", "Community events", "Small business",
        "Military", "Immigration reform", "Illegal immigration"), 2),
    stringsAsFactors=F)

# sorting by % use by republicans
df <- df[c(order(ratio[sbs]), order(ratio[sbs])+12),]
df$label <- factor(df$label, levels=rev(df$label[1:12]))

library(ggplot2)
library(scales)

# plot code, modified from code in:
# https://solomonmessing.wordpress.com/2014/10/11/when-to-use-stacked-barcharts/

pq <- ggplot(df, aes(x=label, y=prop, fill=party)) +
    scale_y_continuous(labels = percent_format(), expand=c(0,0)) +
    geom_bar(stat='identity') +
    geom_hline(yintercept=.5, linetype = 'dashed') +
    coord_flip() +
    theme_bw() +
    ylab('Democrat/Republican share of page posts') +
    xlab('') +
    scale_fill_manual(values=c('blue', 'red')) +
    theme(legend.position='none',
        panel.border = element_blank(),
        axis.ticks.y=element_blank(),
        panel.grid = element_blank()) +
    ggtitle('Political Issues Discussed by Party\n')

pq

ggsave(pq, file="img/congress-lda.png", width=6, height=4)



