FROM public.ecr.aws/lambda/nodejs:22

# Copy function code
COPY patient-service.js ${LAMBDA_TASK_ROOT}
  
# Set the CMD to your handler 
CMD [ "patient-service.handler" ]
