#!/bin/bash
export DB_HOST=$(echo "$POSTGRES_PASSWORD" | jq .POSTGRES_PASSWORD)
