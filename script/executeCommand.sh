aws ssm send-command \
    --document-name "AWS-RunShellScript" \
    --targets '[{"Key":"tag:Name","Values":["incident_response"]}]' \
    --cli-input-json file://script/execCommands.json

    