if [ $# -ne 1 ]; then
    echo "usage: ./change_image_name_linux.sh [docker username]"
    exit
fi

IP=$(kubectl get nodes | awk ' /Ready/ { print $1;exit }')
export IP

sed -i s/journeycode/"$1"/ manifests/deploy-schedule.yaml
sed -i s/journeycode/"$1"/ manifests/deploy-session.yaml
sed -i s/journeycode/"$1"/ manifests/deploy-speaker.yaml
sed -i s/journeycode/"$1"/ manifests/deploy-vote.yaml
sed -i s/journeycode/"$1"/ manifests/deploy-webapp.yaml
