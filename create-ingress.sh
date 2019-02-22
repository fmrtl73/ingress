  kubectl create -f rbac.yaml
  kubectl create -f default-backend.yaml
  kubectl create ns ingress-nginx
  kubectl create -f default-backend.yaml
  kubectl create -f nginx-controller.yaml
  kubectl create -f nginx-configmap.yaml
