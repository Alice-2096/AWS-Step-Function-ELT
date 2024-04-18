import * as AWS from '@aws-sdk/*';
AWS.configure.update({
  region: process.env.AWS_REGION,
});

const streamName = process.env.STREAM_NAME;
const s3 = new AWS.s3();
const kinesis = new AWS.Kinesis();

export const handler = async (event) => {
  console.log(JSON.stringify(event));
  // producer of kinesis will receive one object/Record at a time
  const bucketName = event.Record[0].s3.bucket.name;
  const keyName = event.Record[0].object.key;

  // get object from s3
  const params = {
    Bucket: bucketName,
    Key: keyName,
  };

  await s3
    .getObject(params)
    .promise()
    .then(
      async (data) => {
        const dataString = data.Body.toString();
        const payload = {
          data: dataString,
        };

        // send object to kinesis
        await sendToKinesis(payload, keyName);
      },
      (error) => {
        console.log(error);
      }
    );
};

async function sendToKinesis(payload, partitionKey) {
  const params = {
    Data: JSON.stringify(payload),
    PartitionKey: partitionKey, //determines which shard this data will go
    StreamName: streamName,
  };

  await kinesis
    .putRecord(params)
    .promise()
    .then(
      (response) => {
        console.log(response);
      },
      (error) => {
        console.log(error);
      }
    );
}
