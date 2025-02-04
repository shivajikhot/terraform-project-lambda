FROM public.ecr.aws/lambda/nodejs:22

# Copy function code
COPY appointment-service.js ${LAMBDA_TASK_ROOT}
  
# Set the CMD to your handler 
CMD [ "appointment-service.js.handler" ]
