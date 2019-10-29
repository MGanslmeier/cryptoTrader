# Crypto Trader: an implementation of an algo trader based on tweets

XXXXXX

	# load functions in helper file
    source('src/helper.R')
    
    # POLONIEX Authentication
    poloniex.public <- PoloniexPublicAPI()
    key <- 'XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX'
    secret <- 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    poloniex.trading <- PoloniexTradingAPI(key = key, secret = secret)
    
    # Twitter Authentication
    rtweet_consumerkey <- 'XXXXXXXXXXXXXXXXXXXXXXXXX'
    rtweet_consumersecret  <- 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    
    # start tweet scraping function
    exeTweetDownloader(coinNames = 'ETH')
    
    # start trading function
    tclTaskSchedule(exeTrader(coinID = 'ETH', holdingTime = 30, budgetShare = 0.05), redo = TRUE, wait = 800)
    
    # stop trading function
    tclTaskDelete(NULL)
