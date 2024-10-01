#!/bin/bash

aws_profile="localstack"
# Định nghĩa hàm terminate_instance
terminate_instance() {
    local instance_id="$1"  # Sử dụng biến cục bộ
    aws ec2 terminate-instances --profile ${aws_profile} --instance-ids "${instance_id}"
}

# Nhập instance id
# echo "Enter the instance ID you want to terminate:"
# read instance_id

# # Kiểm tra xem người dùng đã nhập ID chưa
# if [ -z "$instance_id" ]; then
#     echo "Instance ID cannot be empty."
#     exit 1
# fi

# Gọi hàm terminate_instance
# terminate_instance "$instance_id"

# Enter 1 to delete the instance
# Enter 2 to delete security group
# Enter 3 to delete key pair
# Enter 0 to exit
echo "Enter 1 to delete the instance"
echo "Enter 2 to delete security group"
echo "Enter 3 to delete key pair"
echo "Enter 0 to exit"
read choice

case $choice in
    1)
        echo "Enter instance ID:"
        read instance_id
        echo "Deleting the instance..."
        terminate_instance "$instance_id"
        ;;
    2)
        echo "Enter the security group name:"
        read my_sercurity_group
        echo "Deleting the security group..."
        aws ec2 delete-security-group --profile ${aws_profile} --group-name ${my_sercurity_group}
        ;;
    3)
        echo "Enter the key pair name:"
        read key_name
        echo "Deleting the key pair..."
        aws ec2 delete-key-pair --profile ${aws_profile} --key-name ${key_name}
        ;;
    0)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac
