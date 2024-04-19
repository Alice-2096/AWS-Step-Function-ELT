console.log('Loading function');

export const handler = async (event, context) => {
  console.log('failure handler Received event:', JSON.stringify(event));
  console.log('handle failure...');
};
