# Binance Candle Anomaly Detection

This is my second project for the course Operating System.

The goal was to have up-to-date informations from continuous API requests of a website.

I decided to work on the website Binance, and more particularly on its trade spot market https://www.binance.com/en/trade/BTC_USDT?theme=dark&type=spot 

My script has two parts :
  
  - First, it scraps every hour the information of the last candle on a specific trading crypto pair, and it stores those informations in a database.
  - Then, it tags this candle as an "anomaly" or not, depending on a threshold I have chosen (0.7%). If a candle is tagged as an anomaly, the script sends a message on Telegram to the user to warn them.
  
The viewtable.sh script allows the user to visualize the whole database, with all the candles, and to look at the database with only the anomalies.

It is possible to track every crypto pair you wish, by adding its symbol in the pair_tracked array in the script.sh file.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

### To host this project on your machine.

First, clone this repo.

Then, you have to execute the createtable.sh script to create the database.

```
$ source createtable.sh
```

Then, use a cronjob to make it run automaticly every hour.

```
$ crontab -e (opens crontab file)

58 * * * * <Path to your script.sh> (the command to make the script run every hour)
```

By Hugo SCHNEEGANS.
