#!/bin/bash
set -e

echo "=== [1/3] Building WAR ==="
cd /mnt/c/Users/Winfred/Projects/announcement3
mvn clean package -q

echo "=== [2/3] Uploading to VM ==="
gcloud compute scp /mnt/c/Users/Winfred/Projects/announcement3/target/announcement3.war \
  e11010129@bulletin-server2:~/ --zone=asia-northeast1-b

echo "=== [3/3] Deploying to Tomcat ==="
gcloud compute ssh e11010129@bulletin-server2 --zone=asia-northeast1-b --command="\
  sudo cp ~/announcement3.war /opt/tomcat/apache-tomcat-9.0.98/webapps/ && \
  sudo systemctl restart tomcat && \
  sleep 5 && \
  sudo systemctl is-active tomcat"

echo ""
echo "=== 部署完成！==="
echo "網址：http://34.146.210.129:8080/announcement3/list.html"
