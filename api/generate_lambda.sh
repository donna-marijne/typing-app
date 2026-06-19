#!/bin/bash

set -e

resource=$1
verb=$2

if [ -z "$resource" ] || [ -z "$verb" ]; then
    echo "Usage: $0 <resource> <verb>"
    echo "Example: $0 users delete"
    exit 1
fi

dir_name="lambda/${resource}_${verb}"

# Create function directory
mkdir -p "$dir_name"

# Generate main.go
cat > "$dir_name/main.go" <<EOF
package main

import (
    "context"

    "github.com/aws/aws-lambda-go/events"
    "github.com/aws/aws-lambda-go/lambda"
)

func handler(context context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
    return events.APIGatewayProxyResponse{
        StatusCode: 501,
    }, nil
}

func main() {
    lambda.Start(handler)
}
EOF
