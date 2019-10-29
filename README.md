# Crypto Trader: an automatic trader based on tweets

This repository provides an quick implementation of an algorithmic trader for crypto currencies using Poloniex. It trades automatically user-defined cryptocurrencies based on tweets. The idea is very simple: when a certain coin gets mentioned on twitter, a trade on Poloniex is executed. After a user defined holding time, the coin will be sold again.

To get the trader started, you need two accounts:
1. Twitter account: sign up/sign in to Twitter and create a twitter app so you can have access to the Twitter API. There are plenty of online tutorials how this is done. Just google it online. 
2. Poloniex account: as soon as you have the account running and some money is in your wallet, create a new key and secret and paste it into the code snippets below. 

The functions allow for four user-defined parameters: (1) coinID (e.g. ETH for Etherum), (2) holdingTime (e.g. 30, which means that you wait 30 seconds before you sell everything again), (3) budgetShare (e.g. 0.5, which means that you want to invest half of your budget each time you place a buy order), and (4) coinName (e.g. etherum, which is the word you are making twitter API requests on).

Important: open two different R Sessions, so you can run the twitter scraping and the trading function in parallel. In the first session, execute the following lines of code:

    # load functions in helper file
    source('src/helper.R')
    
    # Twitter Authentication
    rtweet_consumerkey <- 'XXXXXXXXXXXXXXXXXXXXXXXXX'
    rtweet_consumersecret  <- 'XXXXXXXXXXXXXXXXXXXXXXXXXX'
    
    # start tweet scraping function (copy this line in a new R session so you can execute the function below in parallel)
    exeTweetDownloader(coinNames = 'ETH')
    

In the second session, execute the following lines of code:
    
    # load functions in helper file
    source('src/helper.R')
    
    # POLONIEX Authentication
    poloniex.public <- PoloniexPublicAPI()
    key <- 'XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX'
    secret <- 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    poloniex.trading <- PoloniexTradingAPI(key = key, secret = secret)
    
    # start trading function
    tclTaskSchedule(exeTrader(coinID = 'ETH', holdingTime = 30, budgetShare = 0.05), redo = TRUE, wait = 800)
    
    # stop trading function
    tclTaskDelete(NULL)

Please note that this project is at the beta stage and there are plenty of things to that need to be done until one can make money with it. This repository should just provide a demonstration how such a trading algorithm can look like from an infrastructural perspective. Back-testing, sentiment analysis and much more remains subject of future developments.