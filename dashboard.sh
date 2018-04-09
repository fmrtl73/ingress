helm install --name dashboard --set rbac.clusterAdminRole=true,serviceAccount.create=false,ingress.enabled=True,ingress.hosts[0]=k8s-dashboard.px stable/kubernetes-dashboard
