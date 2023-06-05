#!/bin/bash

wget -O /etc/yum.repos.d/docker-ce.repo https://repo.huaweicloud.com/docker-ce/linux/centos/docker-ce.repo
sudo sed -i 's+download.docker.com+repo.huaweicloud.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo
sudo yum makecache fast
sudo yum install docker-ce -y

mkdir /app
mkfs.ext4 /dev/vdb
mount /dev/vdb /app  
cat >> /etc/fstab << 'EOF'
/dev/vdb/  /app  ext4   defaults  0   0
EOF

systemctl enable docker
systemctl start docker

wget https://documentation-samples.obs.cn-north-4.myhuaweicloud.com/solution-as-code-publicbucket/solution-as-code-moudle/deploy-a-source-code-build-system-based-on-jenkins/open-source-software/jenkins.tar

docker load -i jenkins.tar

docker run --name=jenkins_01 -u root \
--privileged=true \
--restart always \
-p 8080:8080 \
-p 50000:50000 \
-v /app/jenkins_home:/var/jenkins_home \
-d jenkins/jenkins:lts