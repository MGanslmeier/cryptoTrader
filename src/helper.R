# load libraries
pacman::p_load(dplyr, streamR, tidyr, jsonlite, curl, tcltk2, rtweet, ROAuth, readr, PoloniexR, cryptor, digest)

# function to get tweets
exeTweetDownloader <- function(coinNames){
    stream_tweets(q = coinNames, timeout = 1000000, file_name = 'data/tweets.json', parse = FALSE)
}

# function to buy coin
exeTrader <- function(coinID, holdingTime, budgetShare){

    # Create objects and order book
    orderBook <- data.frame('orderType'= character(), 'orderPair' = character(), 'orderTime'= character(),
                            'orderPrice'= numeric(), 'orderAmount'= numeric(), stringsAsFactors = F)
    pair <- paste('BTC_', coinID, sep = '')
    buySuccess <- FALSE

    ###################

    # Listen to file update
    initTweet <- file.size('data/tweets.json')
    updateChecker <- T
    while(updateChecker){
        if(file.size('data/tweets.json') > initTweet){
            updateChecker <- F
        }
    }

    ###################

    # Execute buy order
    rate <- ReturnTradeHistory(theObject = poloniex.public, pair = pair) %>%
        as.data.frame(.) %>% subset(.,type=='buy') %>% select(rate) %>% .[[1]] %>%
        as.character(.) %>% as.numeric(.) %>% max(.)
    buyAmount <- (ReturnBalances(poloniex.trading)[['BTC']] * budgetShare)/rate
    buySuccess <- ProcessTradingRequest(poloniex.trading, command = poloniex.trading@commands$buy,
                                        args = list(currencyPair = pair, rate = rate, amount = buyAmount, immediateOrCancel = 1))
    buySuccess <- as.numeric(buySuccess$amountUnfilled) == 0

    # Create entry in order book
    print(paste('Bought: ', pair, ' ', buyAmount, ' at ', Sys.time(), ' with rate ', rate, sep=''))
    temp <- data.frame(orderType = 'sell', 'orderPair' = pair, 'orderTime'= Sys.time(),
                       'orderPrice'= rate, 'orderAmount'= buyAmount, stringsAsFactors = F)
    orderBook <<- rbind(orderBook, temp)

    ###################

    if(buySuccess ==  T){

        # Wait holdingTime
        Sys.sleep(holdingTime)

        # Execute sell
        rate <- ReturnTradeHistory(theObject = poloniex.public, pair = pair) %>%
            as.data.frame(.) %>% subset(.,type=='buy') %>% select(rate) %>% .[[1]] %>%
            as.character(.) %>% as.numeric(.) %>% min(.)
        sellAmount <- ReturnBalances(poloniex.trading)[[coinID]]
        ProcessTradingRequest(poloniex.trading, command = poloniex.trading@commands$sell,
                              args = list(currencyPair = pair, rate = rate, amount = sellAmount))

        # Create entry in order book
        print(paste('Sold: ', pair, ' ', sellAmount, ' at ', Sys.time(), ' with rate ', rate, sep=''))
        temp <- data.frame(orderType = 'sell', 'orderPair' = pair, 'orderTime'= Sys.time(),
                           'orderPrice'= rate, 'orderAmount'= sellAmount, stringsAsFactors = F)
        orderBook <<- rbind(orderBook, temp)

        # Reset buySuccess
        buySuccess <- FALSE
    }
}