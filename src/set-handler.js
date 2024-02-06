const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, UpdateCommand } = require("@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient();
const docClient = DynamoDBDocumentClient.from(client);

const tableName = process.env.TABLE_NAME
const key = process.env.KEY

exports.handler = async (event) => {
    if (!event || !event.value) {
        throw new Error('event must have "value" property')
    }

    const value = event.value.toString();

    if (value.length > 128) {
        throw new Error("Value is longer than 128 chars")
    }

    const command = new UpdateCommand({
        TableName: tableName,
        Key: {
            key,
        },
        UpdateExpression: "set #newValue = :newValue",
        ExpressionAttributeValues: {
            ":newValue": value,
        },
        ExpressionAttributeNames: {
            "#newValue": 'value'
        }
    });
    const data = await docClient.send(command);
    
};