kubectl create -f px-sc.yaml
helm install --name prometheus -f prometheus-values.yaml stable/prometheus
