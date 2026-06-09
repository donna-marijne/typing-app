#!/bin/bash

set -e

resource=$1
verb=$2

if [ -z "$resource" ] || [ -z "$verb" ]; then
    echo "Usage: $0 <resource> <verb>"
    echo "Example: $0 users delete"
    exit 1
fi

dir_name="lambda/${resource}/${verb}"

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

# Create go.mod
cd "$dir_name"
go mod init "github.com/donnamarijne/typing-app/api/${dir_name}"
go mod tidy
go fmt
cd - > /dev/null

endpoint_name="${resource^}${verb^}"
function_name="${endpoint_name}Function"

echo "Created: $dir_name"
echo ""
echo "Next steps:"
echo "1. Add the following resource to your template.yaml (under Resources:):"
echo ""
cat <<YAML
  ${function_name}:
    Type: AWS::Serverless::Function
    Metadata:
      BuildMethod: go1.x
    Properties:
      CodeUri: ${dir_name}/
      Handler: bootstrap
      Runtime: provided.al2023
      Architectures:
        - x86_64
      Events:
        CatchAll:
          Type: Api
          Properties:
            Path: /${resource}
            Method: ${verb^^}
YAML
echo ""
echo "2. Add the following outputs to your template.yaml:"
cat <<YAML
  ${endpoint_name}Api:
    Description: "API Gateway endpoint URL for ${verb^^} ${resource} function"
    Value: !Sub "https://\${ServerlessRestApi}.execute-api.\${AWS::Region}.\${AWS::URLSuffix}/Prod/${resource}/"
  ${function_name}:
    Description: "${function_name} ARN"
    Value: !GetAtt ${function_name}.Arn
  ${function_name}IamRole:
    Description: "IAM Role created for ${function_name}"
    Value: !GetAtt ${function_name}Role.Arn
YAML
echo ""
echo "3. Run 'sam build' to compile the new function."
echo "4. Test locally: sam local invoke ${function_name} --event events/event.json"
