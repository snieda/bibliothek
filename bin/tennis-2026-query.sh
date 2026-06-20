#!/usr/bin/env bash

set -euo pipefail

GRAPHQL_ENDPOINT="https://api.example.com/graphql"
PRODUCT_ID="21114da0-4246-42b1-bab6-8d7ac49bb14f"

read -r -d '' QUERY <<'EOF'
query List_product_slots($productID: UUID!, $input: BookingSlotsInput!) {
  booking_slots(product_id: $productID, input: $input) {
    start
    end
    booking_period_start
    booking_period_end
    availability
    already_booked
    already_in_cart
    already_on_waiting_list
    blocked_by_resource
  }
}
EOF

read -r -d '' VARIABLES <<EOF
{
  "productID": "$PRODUCT_ID",
  "input": {
    "start": "2026-06-20T00:00:00Z",
    "end": "2026-06-30T23:59:59Z"
  }
}
EOF

curl -sS \
  -X POST "$GRAPHQL_ENDPOINT" \
  -H "Content-Type: application/json" \
  -d "$(jq -n \
      --arg query "$QUERY" \
      --argjson variables "$VARIABLES" \
      '{query: $query, variables: $variables}')"
      