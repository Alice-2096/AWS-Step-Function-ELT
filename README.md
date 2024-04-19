# Serverless Big Data Ingestion Architecture for Real-time Analytics

This project focuses on creating a scalable and efficient serverless architecture for ingesting and processing large volumes of data in real-time. The core components of the architecture include Kinesis, Lambda, and S3. There are many relevant services to enhance this project such as EMR, Glue, Redshift, SQS, SNS, etc. For the purpose of this demo, we will stick with only the most essential part of this data pipeline: 

- Amazon Kinesis Suite: Used for ingesting massive data streams
- Amazon S3: Used for storing both unprocessed and processed data
- Step Function & Lambda: distributed ETL data processing with controlled parallel workflow

# To run this project 
Create a terraform.tfvars file to set values for the required variables. Then run terraform apply. Alternatively, you can provide variables as flags by running: terraform apply --auto-approve -var="region=" -var="path=" -var="environment=" -var="project-name=". 
