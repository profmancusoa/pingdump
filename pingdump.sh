#!/usr/bin/env bash
#
# Developed with support from chatGPT

usage() {
  echo "Usage: $0 <cycle> <period> <target IP> <# packets> <max timeout> <outfile>"
  echo "Example: $0 100 30 1.1.1.1 3 2 dump.csv"
  exit 1
}

[ $# -eq 6 ] || usage

# Params
cycle=$1
period=$2
target=$3
packets=$4
timeout=$5
outfile=$6

# If file doesnt exists, create the header
if [ ! -s "$outfile" ]; then
  echo "timestamp,target,pkt_sent,pkt_recv,pkt_lost,rtt_min,rtt_avg,rtt_max,rtt_dev" > "$outfile"
fi

# Ping loop
for (( i=1; i<=cycle; i++ )); do
  start_ns=$(date +%s%N)
  raw=$(ping -c "$packets" -W "$timeout" "$target" 2>/dev/null)
  end_ns=$(date +%s%N)
  
  # calculate timestamp as the average between start and end time
  median_ns=$(( (start_ns + end_ns) / 2 ))  
  median_ms=$(( median_ns / 1000000 ))

  # parsing ping output
  pkt_line=$(echo "$raw" | grep -E 'packets transmitted')
  if [ -n "$pkt_line" ]; then
    pkt_sent=$(echo "$pkt_line" | awk '{print $1}')
    pkt_recv=$(echo "$pkt_line" | awk '{print $4}')
    pkt_lost=$((pkt_sent - pkt_recv))
  else
    pkt_sent=0; pkt_recv=0; pkt_lost=0
  fi

  # parsing line RTT: "rtt min/avg/max/mdev = A/B/C/D ms"
  rtt_line=$(echo "$raw" | grep -E 'rtt.*=')
  if [ -n "$rtt_line" ]; then
    # remove prefix and ms then split on su /
    stats=$(echo "$rtt_line" | sed 's/.*= //; s/ ms//')
    IFS='/' read -r rtt_min rtt_avg rtt_max rtt_dev <<< "$stats"
  else
    rtt_min="NaN"; rtt_avg="NaN"; rtt_max="NaN"; rtt_dev="NaN"
  fi

  # CSV line
  line="${median_ms},${target},${pkt_sent},${pkt_recv},${pkt_lost},${rtt_min},${rtt_avg},${rtt_max},${rtt_dev}"

  # dump on file
  echo $line >> $outfile
    
  if [ "$i" -lt "$cycle" ]; then
    sleep "$period"
  fi
done
