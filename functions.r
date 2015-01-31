
################################################################################
# Scrape NYT Congress API for information on Members of 114th Congress
################################################################################

scrape_nytimes_congress_api <- function(api_key, chamber){
    
    require(RCurl)
    require(RJSONIO)

    # query URL
    url <- paste0("http://api.nytimes.com/svc/politics/v3/us/legislative/",
    "congress/114/", chamber, "/members.json?",
    "api-key=", api_key)

    # downloading data
    data <- fromJSON(getURL(url))   

    # reading fields and transforming into data frame
    fields <- names(data[[3]][[1]]$members[[1]])
    df <- matrix(NA, nrow=length(data[[3]][[1]]$members), ncol=length(names(data[[3]][[1]]$members[[1]])))
    for (i in 1:length(fields)){
        df[,i] <- unlistWithNA(data[[3]][[1]]$members, fields[i])
    }   

    df <- data.frame(df, stringsAsFactors=F)
    names(df) <- fields 

    # adding extra field if senate
    if (chamber=="senate"){df$district <- NA}

    df$chamber <- chamber
    return(df)
}

unlistWithNA <- function(lst, field){
    notnulls <- unlist(lapply(lst, function(x) try(!is.null(x[[field]]), silent=TRUE)))
    notnulls[grep('Error', notnulls)] <- FALSE
    notnulls <- ifelse(notnulls=="TRUE", TRUE, FALSE)
    vect <- rep(NA, length(lst))
    vect[notnulls] <- unlist(lapply(lst[notnulls], '[[', field))
    return(vect)
}


################################################################################
# Extract hashtags from a character vector and return frequency table
################################################################################

getCommonHashtags <- function(text, n=20){
    hashtags <- regmatches(text,gregexpr("#(\\d|\\w)+",text))
    hashtags <- unlist(hashtags)
    tab <- table(hashtags)
    return(head(sort(tab, dec=TRUE), n=n))
}