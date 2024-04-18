const { S3, Kinesis } = require('aws-sdk');

const streamName = process.env.STREAM_NAME;
const s3 = new S3();
const kinesis = new Kinesis();

const handler = async (event) => {
  console.log(JSON.stringify(event));
  // Producer of Kinesis will receive one object/Record at a time
  const bucketName = event.Records[0].s3.bucket.name;
  const keyName = event.Records[0].s3.object.key;

  // Get object from S3
  const params = {
    Bucket: bucketName,
    Key: keyName,
  };

  try {
    const data = await s3.getObject(params).promise();
    const dataString = data.Body.toString();
    const payload = {
      data: dataString,
    };

    // Send object to Kinesis
    await sendToKinesis(payload, keyName);
  } catch (error) {
    console.log(error);
  }
};

async function sendToKinesis(payload, partitionKey) {
  const params = {
    Data: JSON.stringify(payload),
    PartitionKey: partitionKey, // Determines which shard this data will go
    StreamName: streamName,
  };

  try {
    const response = await kinesis.putRecord(params).promise();
    console.log(response);
  } catch (error) {
    console.log(error);
  }
}

module.exports = { handler };
