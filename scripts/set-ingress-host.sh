if [ $# -ne 1 ];  then
   echo "usage: ./set-ingress-host.sh [cluster name]"
   exit
 fi
CLUSTER_NAME=$1

INGRESS_SECRET=$(bx cs cluster-get "$CLUSTER_NAME" | grep -i "ingress secret" | cut -d : -f 2 | tr -d '\n ')
INGRESS_SUBDOMAIN=$(bx cs cluster-get "$CLUSTER_NAME" | grep -i "ingress subdomain" | cut -d : -f 2 |  tr -d '\n ')

sed -i s/INGRESS_SUBDOMAIN/"$INGRESS_SUBDOMAIN"/g ../manifests/deploy-ingress.yaml
sed -i s/INGRESS_SECRET/"$INGRESS_SECRET"/g ../manifests/deploy-ingress.yaml

echo "Ready for deploy to $CLUSTER_NAME"
