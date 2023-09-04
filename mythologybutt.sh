#!/usr/bin/env bash

. ~/.cronrc;

set -e

file_length=$(wc -l < motifs.txt)
# get random line number
random_line_number=$((${RANDOM} % ${file_length} + 1))

TWEET=$(awk NR==$random_line_number new_motifs.txt | sed -r 's/(^\S+? )|(: |;|,|\?|!)| ([\(\"].{3,}[\)\"]) |\b(--|int?o?|about|while|he|she|they|s?o? ?that|as|who|by|when|for|witho?u?t?|at|on|and|because|but|to b?e?|from|under|has|where|of|or|whiche?v?e?r?)\b/\1\2\n\3\4/g');

# debug output
echo -e "Should tweet\n\t'$TWEET'"

twurl set default MythologyButt
twurl tweet -d "status=$TWEET" /1.1/statuses/update.json;
curl -H "Authorization: Bearer $MYTHOLOGYBUTT_MASTODON" -d "status=$TWEET" https://botsin.space/api/v1/statuses
