FROM public.ecr.aws/lambda/nodejs:22
 
# Copy the Lambda function code
COPY appointment-service.js ${LAMBDA_TASK_ROOT}
 

# Set the CMD to your Lambda function handler
CMD [ "appointment-service.handler" ]

