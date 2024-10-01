## create keypair
aws_profile="localstack"
key_name="my_keyname"
my_sercurity_group="my_security_group"
instance_type="t2.micro"

# Xoa keypem
aws --profile ${aws_profile} ec2 delete-key-pair --key-name ${key_name}

# create new keypair
aws --profile ${aws_profile} ec2 create-key-pair \
    --key-name ${key_name} \
    --query 'KeyMaterial' \
    --output text | tee ${key_name}.pem

# xem danh sach keypem aws --profile ${aws_profile}
#aws --profile ${aws_profile} ec2 describe-key-pairs

# xóa danh sách sercurity group
aws --profile ${aws_profile} ec2 delete-security-group --group-name ${my_sercurity_group}

# create sercurity group
aws --profile ${aws_profile} ec2 create-security-group \
    --group-name ${my_sercurity_group} \
    --description "My security group" \
    --output table

# xem danh sach sercurity group
#aws --profile ${aws_profile} ec2 describe-security-groups

# Lấy giá trị group_id
security_group_id=$(aws --profile ${aws_profile} ec2 describe-security-groups \
    --group-names ${my_sercurity_group} \
    --query 'SecurityGroups[0].GroupId' \
    --output text)

#### Cấu hình Security Group
# Thêm cổng 8000 Inbound rule
aws --profile ${aws_profile} ec2 authorize-security-group-ingress \
    --group-id ${security_group_id} \
    --protocol tcp \
    --port 8000 \
    --cidr 0.0.0.0/0 \
    --query 'SecurityGroupRules[0].[GroupId,IpProtocol,ToPort]' \
    --output table

# Thêm cổng 22
aws --profile ${aws_profile} ec2 authorize-security-group-ingress \
    --group-id ${security_group_id} \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0 \
    --query 'SecurityGroupRules[0].[GroupId,IpProtocol,ToPort]' \
    --output table

# In ket qua
echo "-------------------Sercurity group configurate done-------------------"

aws --profile ${aws_profile} ec2 describe-security-groups \
    --group-id ${security_group_id} \
    --query "SecurityGroups[*].[GroupName, IpPermissions[*].[FromPort, ToPort, IpRanges[*].CidrIp]]" \
    --output table
### Step 3: Khởi chạy instance

aws --profile ${aws_profile} ec2 run-instances \
    --image-id ami-005fc0f236362e99f \
    --count 1 \
    --instance-type ${instance_type} \
    --key-name ${key_name} \
    --security-group-ids ${security_group_id} \
    --query 'Instances[0].[ImageId,InstanceType,State.Name,PublicIpAddress,SecurityGroups[0].GroupName]' \
    --output table
#   --user-data file://./user_script.sh

echo "-------------------Instance ${instance_type} create done-------------------"

aws --profile ${aws_profile} ec2 describe-instances \
    --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,PublicIpAddress]' \
    --output table
# terminate instance
# aws --profile ${aws_profile} ec2 terminate-instances --instance-ids i-aa0138520011e8de5
