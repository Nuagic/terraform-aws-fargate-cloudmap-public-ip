import json
import boto3
import os
ec2 = boto3.client('ec2')
sd = boto3.client('servicediscovery')

def lambda_handler(event, context):
    print(event["detail"]["group"])
    for a in event["detail"]["attachments"]:
        if a["type"] != "eni":
            continue
        for b in a["details"]:
            if b["name"] != "networkInterfaceId":
                continue
            print(b["value"])
            network_interface = ec2.describe_network_interfaces(NetworkInterfaceIds=[b["value"]])
            ip = network_interface["NetworkInterfaces"][0]["Association"]["PublicIp"]
            print(ip)
            sd.register_instance(
                ServiceId=os.environ.get('service_id'),
                InstanceId=os.environ.get('instance_id'),
                Attributes={
                    'AWS_INSTANCE_IPV4': ip
                }
            )
    
    return True

