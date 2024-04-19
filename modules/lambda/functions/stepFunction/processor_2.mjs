console.log('Loading function');

export const handler = async (event, context) => {
  console.log('Processor 2 Received event:', JSON.stringify(event));

  try {
    const data = cleanData(event.data);
    console.log('cleaned data:', data);
    var status;
    if (data.includes('ERROR')) {
      status = 'FAILED';
    } else {
      status = 'SUCCESS';
    }

    const re = {
      StatusCode: 200,
      Payload: {
        status: status,
        processor: 2,
      },
    };
    return re;
  } catch (error) {
    console.error('Error occurred during ETL:', error);
    return { statusCode: 500, body: 'An error occurred during ETL process' };
  }
};

const cleanData = (data) => {
  return data.toUpperCase();
};
