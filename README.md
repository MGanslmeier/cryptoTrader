# Crypto Trader: buy cryptocurrencies based on tweets within seconds

XXXXXX

	# load functions in helper file
    source('src/helper.R')
    
    # POLONIEX Authentication
    poloniex.public <- PoloniexPublicAPI()
    key <- 'XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX'
    secret <- 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    poloniex.trading <- PoloniexTradingAPI(key = key, secret = secret)
    
    # Twitter Authentication
    rtweet_consumerkey <- 'XXXXXXXXXXXXXXXXXXXXXXXXX'
    rtweet_consumersecret  <- 'XXXXXXXXXXXXXXXXXXXXXXXXXX'
    
    # start tweet scraping function in new RStudio session
    exeTweetDownloader(coinNames = 'ETH')
    
    # start trading function
    tclTaskSchedule(exeTrader(coinID = 'ETH', holdingTime = 30, budgetShare = 0.05), redo = TRUE, wait = 800)
    
    # stop trading function
    tclTaskDelete(NULL)
