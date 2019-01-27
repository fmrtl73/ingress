curl -o px-operator.yaml "https://docs.portworx.com/samples/k8s/portworx-pxc-operator.yaml"
kubectl create secret generic alertmanager-portworx -n kube-system --from-file=<(curl -s https://docs.portworx.com/samples/k8s/portworx-pxc-alertmanager.yaml | sed 's/<.*address>/dummy@dummy.com/;s/<.*password>/dummy/;s/<.*port>/localhost:25/')
# while : ; do
#   kubectl apply -f https://docs.portworx.com/samples/k8s/prometheus/02-service-monitor.yaml
#   [ $? -eq 0 ] && break
# done
curl -o alertmanager.yaml "https://docs.portworx.com/samples/k8s/prometheus/05-alertmanager-service.yaml"
curl -o px-rules.yaml "https://docs.portworx.com/samples/k8s/prometheus/06-portworx-rules.yaml"
curl -o px-prometheus.yaml "https://docs.portworx.com/samples/k8s/prometheus/07-prometheus.yaml"
mkdir /tmp/grafanaConfigurations
curl -o /tmp/grafanaConfigurations/Portworx_Volume_template.json -s https://raw.githubusercontent.com/portworx/px-docs/gh-pages/k8s-samples/grafana/dashboards/Portworx_Volume_template.json
curl -o /tmp/grafanaConfigurations/dashboardConfig.yaml -s https://raw.githubusercontent.com/portworx/px-docs/gh-pages/k8s-samples/grafana/config/dashboardConfig.yaml
kubectl create configmap grafana-config --from-file=/tmp/grafanaConfigurations -n kube-system
curl -s https://docs.portworx.com/samples/k8s/grafana/grafana-deployment.yaml | sed 's/config.yaml/dashboardConfig.yaml/g;/- port: 3000/a\\    nodePort: 30950' > grafana-deployment.yaml
sudo curl -s http://openstorage-stork.s3-website-us-east-1.amazonaws.com/storkctl/2.0.0/linux/storkctl -o /usr/bin/storkctl
sudo chmod +x /usr/bin/storkctl
if [ $(hostname) != master-1 ]; then
  while : ; do
    token=$(ssh -oConnectTimeout=1 -oStrictHostKeyChecking=no vagrant@k1n1 pxctl cluster token show | cut -f 3 -d " ")
    echo $token | grep -Eq '.{128}'
    [ $? -eq 0 ] && break
    sleep 5
  done
  storkctl generate clusterpair -n default remotecluster-1 | sed '/insert_storage_options_here/c\\    ip: k1n1\n    token: '$token >cp.yaml
  cat cp.yaml | ssh -oConnectTimeout=1 -oStrictHostKeyChecking=no vagrant@k1m kubectl apply -f -
fi
