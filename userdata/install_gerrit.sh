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

wget https://documentation-samples.obs.cn-north-4.myhuaweicloud.com/solution-as-code-publicbucket/solution-as-code-moudle/deploy-a-source-code-build-system-based-on-jenkins/open-source-software/gerrit.tar

docker load -i gerrit.tar

docker run --name=gerrit  -u root --privileged=true --restart always -p 8080:8080 -p 29418:29418 -d  -e CANONICAL_WEB_URL=http://$1:8080 -v /app/gerrit/cache:/var/gerrit/cache -v /app/gerrit/db:/var/gerrit/db -v /app/gerrit/etc:/var/gerrit/etc -v /app/gerrit/git:/var/gerrit/git -v /app/gerrit/index:/var/gerrit/index gerritcodereview/gerrit:latest