# Select the whole database and print it to the screen
sqlite3 mydatabase.db <<'END_SQL'
SELECT * FROM candles
END_SQL

# Select all the anomalies and print them to the screen
sqlite3 mydatabase.db <<'END_SQL'
SELECT * FROM candles WHERE anomaly=1
END_SQL

# If the user decides that an anomaly is another threshold than the one I chose arbitrarily (0.7%), he can run this command

#threshold=0.007
#sqlite3 mydatabase.db <<'END_SQL'
#UPDATE candles SET anomaly=0 WHERE amplitude<$threshold
#UPDATE candles SET anomaly=1 WHERE amplitude>=$threshold
#Select * FROM candles WHERE anomaly=1
#END_SQL
