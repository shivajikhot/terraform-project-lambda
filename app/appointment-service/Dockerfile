# Use the AWS Lambda Node.js 16 base image
FROM public.ecr.aws/lambda/nodejs:16
 
# Set the working directory in the container
WORKDIR /var/task

# Copy the package.json and install dependencies
COPY appointment-service.js ${LAMBDA_TASK_ROOT}
 
COPY package.json ./
RUN npm install
 
# Copy the rest of your application code
COPY . .
 
EXPOSE 3001
 
# Set the CMD to your Lambda function handler
CMD [ "appointment-service.handler" ]


