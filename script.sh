function scrap_and_search_anomaly {

    symbol=$1

    curl "https://api.binance.com/api/v3/klines?symbol=$symbol&interval=1h&limit=1" > candledata.json

    elements=$(echo "$(cat candledata.json)" | jq -c '.[]')

    for element in $elements; do

        timestamp=$(echo "$element" | jq -r '.[0]')
        open_price=$(echo "$element" | jq -r '.[1]')
        high_price=$(echo "$element" | jq -r '.[2]')
        low_price=$(echo "$element" | jq -r '.[3]')
        close_price=$(echo "$element" | jq -r '.[4]')
        volume=$(echo "$element" | jq -r '.[5]')
        close_time=$(echo "$element" | jq -r '.[6]')
        quote_asset_volume=$(echo "$element" | jq -r '.[7]')
        trades=$(echo "$element" | jq -r '.[8]')
        taker_buy_base_asset_volume=$(echo "$element" | jq -r '.[9]')
        taker_buy_quote_asset_volume=$(echo "$element" | jq -r '.[10]')
        amplitude=$(echo "($high_price - $low_price)/$low_price" | bc -l)

       abs_amplitude=$(echo "$amplitude" | awk '{if ($1 < 0) print -$1; else print $1}')

        # We decided that a candle was an anomaly if its amplitude was greater than or equal to 0.7%, so we test that parameter here
        if [[ $(echo "$abs_amplitude >= 0.007" | bc -l) -eq 1 ]]; then

            # If the candle is an anomaly :
            echo "Amplitude is greater than or equal to 0.7%!"

            # Insert the anomaly in the database
            sqlite3 mydatabase.db "INSERT INTO candles (timestamp,symbol, open, high, low, close, volume, close_time, quote_asset_volume, trades, taker_buy_base_asset_volume, taker_buy_quote_asset_volume, amplitude, anomaly)
            VALUES ('$timestamp','$symbol', '$open_price', '$high_price', '$low_price', '$close_price', '$volume', '$close_time', '$quote_asset_volume', '$trades', '$taker_buy_base_asset_volume', '$taker_buy_quote_asset_volume','$amplitude',TRUE)"

            # Sends a message to the telegram bot to notify the anomaly in real time
            MSG=$(echo -e "Il y a une anomalie sur la paire $symbol :\nTimeStamp = $timestamp,\nOpen_Price = $open_price,\nClose_Price = $close_price,\nAmplitude = $(echo "$amplitude*100" | bc)")
            TOKEN='YOUR_TELEGRAM_TOKEN'
            CHAT_ID='YOUR_TELEGRAM_CHAT_ID'
            URL="https://api.telegram.org/bot$TOKEN/sendMessage"
            curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$MSG"
        else

            # If the candle is not an anomaly :
            echo "Amplitude is not greater than or equal to 0.7%!"

            # Insert the normal candle in the database
            sqlite3 mydatabase.db "INSERT INTO candles (timestamp,symbol, open, high, low, close, volume, close_time, quote_asset_volume, trades, taker_buy_base_asset_volume, taker_buy_quote_asset_volume, amplitude, anomaly)
            VALUES ('$timestamp','$symbol', '$open_price', '$high_price', '$low_price', '$close_price', '$volume', '$close_time', '$quote_asset_volume', '$trades', '$taker_buy_base_asset_volume', '$taker_buy_quote_asset_volume','$amplitude',FALSE)"

        fi
    done
}

# pair_tracked is an array containing the pairs we want to track
pair_tracked=("BTCUSDT" "ETHUSDT")

for element in "${pair_tracked[@]}"; do
  scrap_and_search_anomaly $element
done

