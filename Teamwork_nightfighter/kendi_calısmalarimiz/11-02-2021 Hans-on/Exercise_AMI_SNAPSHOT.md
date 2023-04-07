# Teamwork-Project-01 : Working with EC2 Snapshots, AMIs and Volumes

Purpose of the this project is to learn how to take a snapshot of EC2 instance, create an image and volume (root and additional volumes), creating another volume and instance from these snapshots, attaching and mounting new volume and instance together.

## Learning Outcomes

- At the end of the this hands-on training, students will be able to;

- take snapshots of EC2 instance and volume on AWS console.

- create images from EC2 instances on AWS console.

- understand of difference between the image and the snapshot.

- create different types of AMI.

- coping and sharing AMI

- formatting and resizing additional volume and mounting with root volume 

- attaching and mounting new volume and instance together

## Outline

Part 1 - Creating an EC2 instance (EC2A) with an additional volume (10 GiB)

Part 2 - Mounting the additional volume

Part 3 - Adding a .txt file to additional volume

Part 4 - Taking snapshot of the EC2 (EC2A) with 2 volumes

Part 5 - Create an instance (EC2B) from root volume's snapshop of EC2A

Part 6 - Create an additional volume (15 GiB) from additional volume's snapshop of EC2A

Part 7 - Attach and Mount EC2B and additional volume (15 GiB)

## Part 1 - Creating an Image from the Snapshot of the Nginx Server and Launching a new Instance

- Launch an instance with following configurations.

  a. Security Group: Allow SSH and HTTP ports from anywhere with named "SSH and HTTP"

  b. User data (paste user data seen below for Nginx)

  ```text
  #!/bin/bash

  yum update -y
  amazon-linux-extras install nginx1.12
  yum install wget -y
  cd /usr/share/nginx/html
  chmod o+w /usr/share/nginx/html
  rm index.html
  wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/index.html
  wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/ken.jpg
  systemctl start nginx
  systemctl enable nginx
  ```

  c. Tag: Since "Data Lifecycle Manager" work based on tags, we use tag to customize Instance!!!!!!!! 

  ```text
  Key: Name 
  Value: SampleInstance  
  ```
- First copy the Instance ID and then go to EC2 dashboard and click "Snapshot" section from left-hand menu.


- Click `create snapshot` button.

Select resource type : Instance
Instance ID          : Select the instance ID of Nginx
Name(manually)       : Instance-Snapshot_First

- Click create snapshot.

- Click snapshot `Action` menu and select `create image`

```text
Name        : clwwAMI_1
Description : clwwAMI_1
```

- Click the `launch instance` tab.

- Click `myAMI` from left-hand menu.

- Select `clwwAMI_1' AS AMI

- Launch instance named "Instance_1_from_Sample_Instance"

- Copy the public IP of the newly created instance and paste it to the browser.

- Show that the Nginx Web Server is working.

## Part 2 - Creating an Image and Launching an Instance from the same Image with "Action Menu"

- Go to `SampleInstance`

- Click the actions menu.

- Select image >> create image.

```text
Name        : clwwAMI_2
Description : clwwAMI_2
```

- Click AMI section from left hand menu and show `clwwAMI_2`

- After clwwAMI creation process is completed, click snapshot section from left-hand menu.

-  Show that AWS has created a new snapshot for newly created `clwwAMI_2` image.

-  Click the `launch instance` tab.

- Click `myAMI` from left-hand menu.

- Select `clwwAMI_2`.


- Launch instance as named "Instance_2_from_Sample_Instance_"

- Copy the public IP of the newly created instance and paste it to the browser.

- Show that the Nginx Web Server is working.

- Check the "Snapshot Menu" ıf there is an extra snapshot or not. If yes, then  name it. Explain the reason.

```text
Name : Snapshot_Second_Auto 
```
## Part 3 - Creating an Image from the Snapshot of the Root Volume and Launching a new Instance

- Go to EC2 menu and click snapshot section from left-hand menu.

- Click `create snapshot` button.
```text
Select resource type : ****Volume
Instance ID : select the root volume of the SampleInstance
Name(manually)       : Snapshot_Third 
```

- Go to the AMI menu and Click create AMI.

```text
Name        : clwwAMI_3
Description : clwwAMI_3
```
- Click the `launch instance` tab.

- Click `myAMI` from left-hand menu.

- Select `clwwAMI_3`.

- Launch instance as named "Instance_3_from_Sample_Instance_"

- Copy the public IP of the newly created instance and paste it to the browser.

- Show that the Nginx Web Server is working.

## Part 4 - Make AMI public.

- First go to the AMI section  from left-hand menu and say students to not to do together.

- Select the clwwAMI_4

- Click on permission and Click on  "Make public "

- After a while it will be public. Send the AMI ID from slack

- Tell the student to  go Launch Instance-----> Choose AMI------> Community AMI, and paste the "ID of AMI" to the search bar 

- Delete all AMIs and Snapshots. 

## Part 5 - Hosting WordPress on EC2 with AMI

- Create EC2 instnace
  - AMI: AWS Marketplace  : "WordPress Certified by Bitnami and Automattic" (Free tier)
  - Instance type         : t2.micro
  - Volume                : 10Gb is default.***
  - Tag                   : Key=Name, Value= WordPress
  - Sec.Grp               : HTTP & HTTPS & SSH are default ***
  - 
- Go to the browser and paste WP IP .

- to customize the page >>>>> after the IP add "/wp-admin"
- In the opening page you need a user name and password for customizing WP
- Select the wordpress Instance from console
   - Action  >>>  Monitor and Troubleshoot >>>>>> Get System logs >>>> "user name and password" 
- Go to browser and log in with credentials. 
- Delete the WP instance. 

## Part 6 - Using Data Lifecycle Manager :

- In the Amazon EC2 Console, under Elastic Block Store——>Lifecycle Manager——>Create Snapshot Lifecycle Policy. 

- You can select the policy type depending on your target component to snapshot. 

```text
Policy type: EBS snapshot policy
```

- You can select the resource type as volume or instance depending on whether you want to schedule snapshots. We will be selecting "Instance" as the resource type.

Select resource type: Instance

- Enter a description:

```text
Description: "Test policy"
```
- Now select the tags associated with the EBS volumes or EC2 instance, it will depend on the option chosen above. We are  including all the instances with tag name : 


```text
  Key: Name 
  Value: SampleInstance  
```
- 55.This policy must be associated with an IAM role that has the appropriate permissions. If you choose to create a new role, you must grant relevant role permissions and setup trust relationships correctly. If you are unsure of what role to use, choose Default role. 
```text
  Default Role 
```

- Schedules define how often the policy is triggered, and the specific actions that are to be performed. The policy must have at least one schedule. This schedule is mandatory, while schedules 2, 3, and 4 are optional.

```text
Policy Schedule 1
Schedule name : My_schedule
Frequency     : Daily
Every         : 24H
Starting at   : 03:00 UTC
Retention Type: Count 
Retain        : 5
```
- Copy the "Copy tags from source" option. Thanks to this option, tags from the source volume are automatically assigned to snapshots created by the schedule.

- Cross region copy

```text
Uncheck "Enable cross region copy"
```
- Cross-account sharing

```text
Check "Enable cross-account sharing"
```
- Confirm the Policy Summary to be sure that the rules are specified correctly, as per your requirement. Choose Enable policy to start the policy, runs at the next scheduled  time.

```text
Enable Policy
```
- Finally, choose Create Policy. 

- That's it, you're DLM policy is created. Check ıt from console. 

- Delete the policy. 