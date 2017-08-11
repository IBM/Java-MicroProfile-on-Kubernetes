if [ $# -ne 1 ]; then
    echo "usage: ./change_image_name_linux.sh [docker username]"
    exit
fi

export IP=$(kubectl get nodes | awk ' /Ready/ { print $1;exit }')

sed -i s#"journeycode"#$1# manifests/deploy-schedule.yaml
sed -i s#"journeycode"#$1# manifests/deploy-session.yaml
sed -i s#"journeycode"#$1# manifests/deploy-speaker.yaml
sed -i s#"journeycode"#$1# manifests/deploy-vote.yaml
sed -i s#"journeycode"#$1# manifests/deploy-webapp.yaml
sed -i s#"journeycode"#$1# manifests/deploy-nginx.yaml
sed -i s#"xxx.xxx.xx.xxx"#$IP# manifests/deploy-nginx.yaml