#!/usr/bin/env bash

# fail the execution of the script on command returning error
set -e

. ~/.cronrc

file_length=$(wc -l < motifs.txt)
# get random line number
random_line_number=$((${RANDOM} % ${file_length} + 1))

export TWEET=$(awk NR==$random_line_number motifs.txt | sed -r 's/(^\S+? )|(: |;|,|\?|!)| ([\(\"].{3,}[\)\"]) |\b(--|int?o?|about|while|he|she|they|s?o? ?that|as|who|by|when|for|witho?u?t?|at|on|and|because|but|to b?e?|from|under|has|where|how many|how long|of|or|whiche?v?e?r?)\b/\1\2\n\3\4/g')

# debug output
echo -e "Should tweet\n\t'$TWEET'"

twurl set default MythologyBot
tweet_text="${TWEET//$'\n'/\\n}"
twurl '/2/tweets' --data "{\"text\": \"${tweet_text}\"}" --header 'Content-Type: application/json' --consumer-key "${MYTHBOT_CONSUMERKEY}" --consumer-secret "${MYTHBOT_CONSUMERSECRET}" --access-token "${MYTHBOT_ACCESSTOKEN}" --token-secret "${MYTHBOT_TOKENSECRET}"
curl -H "Authorization: Bearer $MYTHOLOGYBOT_MASTODON" -d "status=$TWEET" "https://botsin.space/api/v1/statuses"

# push the exported variable TWEET to bsky
"$HOME/apps/mythology/bsky.sh"
