## Jokes App + Deployment on AWS 

### What does this app do? 
Simple! When you first access the page (using the ip address which will be outputted after you run `terraform apply`)
- You will be met with this page:
![home](./images/Homepage.png)
- Insert your name and a joke. You should see the following success message:
![success](./images/Success.png)
- You can then head over to the collection to confirm that your joke has been added to the MongoDB. 
![collection](./images/Collection.png)

### Pre-requisites 
**This README assumes a basic understanding of docker, terraform and bash commands. After downloading the files in this repo:**

2. To host this app on AWS, you need the following installed on your system:
    a) Terraform 
    b) a bash / linux terminal 

    When this project is complete, you should be able to host the app by carrying out the following steps: (Currently not working,i still need to provision AMIs using Ansible) 

    i. make sure all variables are filled (see Configuation and Security section) with working AWS credentials 

    ii. terraform init, build and apply 

    iii. step ii will output an ip address, which you can type into your browser to access the app. 

3. To host this app locally, you need the following installed on your system:
    a) Docker 
    b) Python 

    i. global vars for `docker-compose` file

    ii. go into the `jokes_webapp` directory in your terminal
    
    iii. command: `docker-compose up` 
    
    iv. manually exec into the mongodb container and configure the db with your username and password (i should automate this step)
    

### Networking Structure 

- VPC 
    - region can be specified in the `terraform/variables.tf` file
    - IGW

    - Two Subnets
        - Public Subnet
            - Contains app instances
            - NACL allows HTTP, HTTPS, SSH from Admin
        - Private Subnet
            - Contains db instances
            - NACL allows MongoDB and SSH from Admin
        - route tables, route associations and security groups are all explicitly defined. 
    - Scaling 
        - ELB set up for app and db instances
        - Scaling Up and Down policies for both db and app instances for both >60% and <10% CPU usage which trigger autoscaling 
        - Cloudwatch Alarms set up for the above
        - Scaling across availability zones can be achieved by adding additional subnets to the list of subnets in the `terraform/scaling/main.tf` file. These subnets can be in other availability zones, but need to be created in advance. 



## Increment 
1. Currently the front-end servers are hosted in a public subnet, I would like to move them to the private subnet and allow access only via a bastion in the public subnet, for increased security, as described [here](https://developer.ibm.com/articles/secure-vpc-access-with-a-bastion-host-and-terraform/): 

![bastion](./images/bastion.png)

2. The proxy doesn't need to be an additional instance, and can probably be combined with the app-tier.

### Configuration and Security 
- These files do not contain any of the passwords or AWS key names or locations, instead these are called from environment variables. 
- For personal use or modification, you can either hard-code your key names / locations into the `docker-compose` and `main.py` files or create your own environment variables. 

To use global variables in `docker-compose`, save your variables in a file called `.my_env` and run the following commands 

```bash
set -a
source .my_env
docker-compose up -d
```

- You would also need either hard-code or call AWC credentials for the  `terraform/variables.tf` file.
