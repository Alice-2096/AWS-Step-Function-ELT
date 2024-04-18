import { SFNClient, StartExecutionCommand } from '@aws-sdk/client-sfn'; // ES Modules import
// const { SFNClient, StartExecutionCommand } = require("@aws-sdk/client-sfn"); // CommonJS import

const client = new SFNClient();
const state_machine_arn = process.env.STATE_MACHINE_ARN;

export const handler = async (event) => {
  console.log(JSON.stringify(event));
  for (const record of event.Records) {
    const data = JSON.parse(Buffer.from(record.kinesis.data, 'base64')); //extract data into a JSON object
    // push data to step function as input
    console.log(JSON.stringify(data));
    const input = {
      // StartExecutionInput
      stateMachineArn: state_machine_arn, // required
      input: JSON.stringify(data),
    };
    const command = new StartExecutionCommand(input);
    const response = await client.send(command);
  }
};
