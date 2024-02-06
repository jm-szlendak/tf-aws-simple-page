const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, GetCommand }=  require( "@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient();
const docClient = DynamoDBDocumentClient.from(client);

const tableName = process.env.TABLE_NAME
const key = process.env.KEY

exports.handler = async (event) => {

    const command = new GetCommand({
        TableName: tableName,
        Key: { key: key },
    });

    const data = await docClient.send(command);
    const item = data.Item;

    if (!item) {
        throw new Error("item is not set")
    }

    return `<h1>${item.value}</h1>`
};