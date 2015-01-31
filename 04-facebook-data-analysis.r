################################################################
## Workshop: Collecting and Analyzing Social Media Data with R
## February 2nd, 2015
## Script 4: Analyzing Facebook data
## Author: Pablo Barbera, NYU, @p_barbera
################################################################

setwd("~/Dropbox/git/social-media-workshop")

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

# downloading Facebook data
library(Rfacebook)
accounts <- congress$facebook_account

accounts.done <- list.files("data/facebook")
accounts.left <- accounts[tolower(accounts) %in% tolower(gsub(".csv", "", accounts.done)) == FALSE]

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


