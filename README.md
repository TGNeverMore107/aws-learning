# Localstack

## Installation
- Install [Docker](https://www.docker.com/)
- Install [localstack CLI](https://github.com/localstack/localstack?tab=readme-ov-file#installation)
- Install [awslocal CLI](https://docs.localstack.cloud/user-guide/integrations/aws-cli/#localstack-aws-cli-awslocal) or [aws CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Docker localstack Plugin](https://hub.docker.com/extensions/localstack/localstack-docker-desktop)
- [Localstack Dashboard](https://app.localstack.cloud/download) (same [AWS Console](https://console.aws.amazon.com/console/services)) or use [Web UI](https://app.localstack.cloud/instances) if you connected `localstack` account via [Docker localstack Plugin](https://hub.docker.com/extensions/localstack/localstack-docker-desktop)

## Run localstack: `docker-compose up -d`

## Configuration and Practicing
### Localstack
- Change `.env` with [localstack Configuration](https://docs.localstack.cloud/references/configuration/)
- Add configuration `services > services > localstack > environment` of `docker-compose.yml`

### AWS CLI configuration connect localstack
#### Step 1: Config localstack: [aws-cli configuration](https://docs.localstack.cloud/user-guide/integrations/aws-cli/)
##### Solution 1: Change `environment` at `docker-compose.yml`
```
AWS_ACCESS_KEY_ID=test-key-id
AWS_SECRET_ACCESS_KEY=test-access-key
AWS_DEFAULT_REGION=ap-southeast-1
```
##### Solution 2: Config at Docker LocalStack Extension, add variables.

#### Step 2: Config `aws` CLI
##### Change `~/.aws/config`
```
region=ap-southeast-1
output=json
endpoint_url=http://localhost:4566
```
##### Change `~/.aws/credentials`
```
aws_access_key_id=test
aws_secret_access_key=test
```
##### Or Run CMD `aws configure --profile localstack` and enter step.

##### Test 
```
aws s3 mb s3://test --profile localstack
aws s3 ls --profile localstack
```
###### [LocalStack endpoints](https://docs.localstack.cloud/references/internal-endpoints/#localstack-endpoints)

### create instance
```
# create instance
aws ec2 run-instances \
    --image-id ami-0c55b159cbfafe1f0 \
    --instance-type t2.micro

# check all instance
awslocal ec2 describe-instances --query Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]
```

### stop instace
```
awslocal ec2 stop-instances --instance-ids <instance_id>
```

## Document
- [localstack](https://docs.localstack.cloud/overview/)

