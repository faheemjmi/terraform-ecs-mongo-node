**This Project uses two applications** 

**Backend**: Built in noode js
  - This application uses Mongo DB Atlas as database
  - docker build -t itsfaheem/goals-node ./backend
  - Access app using http://localhost/goals 

**Frontend**: Built in React
  - This application uses React JS
  - docker build -t itsfaheem/goals-react ./frontend (for localhost:3000)
  - docker build -t itsfaheem/goals-react ./frontend/Dockerfile.prod (for production)
  - Access app using http://localhost:3000
  - Backend URL is hard coded at ./front/src/App.js as process.env.NODE_ENV 

**Deploy the Applications**    

1. Run **terraform init** to initialize the Terraform modules.
2. Run **terraform validate** to check the syntax.
3. Run **terraform plan -input=false -var-file devops/dev/dev.tfvars** to check the plan. 
4. Run **terraform apply -input=false -var-file devops/dev/dev.tfvars -auto-approve** to apply the changes.