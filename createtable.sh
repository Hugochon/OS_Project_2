# Run this script only once to create the database and table, if you run it again it will delete the table and create it again and you will lose the data you've already stored
sqlite3 mydatabase.db "DROP TABLE IF EXISTS candles"
sqlite3 mydatabase.db "CREATE TABLE candles (
    id INTEGER PRIMARY KEY,
    symbol TEXT NOT NULL,
    timestamp TEXT NOT NULL,
    open TEXT NOT NULL,
    high TEXT NOT NULL,
    low TEXT NOT NULL,
    close TEXT NOT NULL,
    volume TEXT NOT NULL,
    close_time TEXT NOT NULL,
    quote_asset_volume TEXT NOT NULL,
    trades TEXT NOT NULL,
    taker_buy_base_asset_volume TEXT NOT NULL,
    taker_buy_quote_asset_volume TEXT NOT NULL,
    amplitude REAL,
    anomaly BOOL NOT NULL
);"