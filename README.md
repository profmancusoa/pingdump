# pingdump

Simple tool to dump ping information


# Usage

```bash
Usage: ./pingdump.sh <cycle> <period> <target IP> <# packets> <max timeout> <outfile>

Example: ./pingdump.sh 100 30 1.1.1.1 3 2 dump.csv
```

- Perform a total of 100 (cycle), one every 30(period) seconds.

- Each cycle it pings 1.1.1.1 (target IP) by sending 3 (# packets) packets with a timeout of 2(max timeout) seconds.

- Each ping is dumped on outfile


# Output

The dump file is quite simple and it follow this format

```bash
timestamp,target,pkt_sent,pkt_recv,pkt_lost,rtt_min,rtt_avg,rtt_max,rtt_dev
1747756431313,1747756432368,44.218.80.9,3,3,0,104.323,104.506,104.621,0.130
1747756436433,1747756437542,44.218.80.9,3,3,0,104.475,140.124,211.154,50.225
1747756441660,1747756442717,44.218.80.9,3,3,0,104.588,104.710,104.787,0.087
1747756446783,1747756447839,44.218.80.9,3,3,0,103.891,104.131,104.544,0.293

```

|timestamp|target|pkt_sent|pkt_recv|pkt_lost|rtt_min|rtt_avg|rtt_max|rtt_dev|
|---|---|---|---|---|---|---|---|---|
|1747756713857|44.218.80.9|3|3|0|104.097|104.888|106.455|1.107|
|1747756718978|44.218.80.9|3|3|0|104.317|104.493|104.650|0.136|
|1747756724099|44.218.80.9|3|3|0|104.172|104.226|104.331|0.073|
|1747756729220|44.218.80.9|3|3|0|104.005|104.237|104.411|0.170|

This file can be easily parsed and interpreted by other tools.
