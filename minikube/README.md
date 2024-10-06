
minikube addons enable ingress

kubectl get pods --all-namespaces

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm upgrade --install loki --namespace=loki-stack grafana/loki-stack --values minikube/loki-values.yaml --create-namespace
kubectl get pods -n loki-stack

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm upgrade --install grafana-agent --namespace=loki grafana/grafana-agent --values grafana-values.yaml


kubectl port-forward svc/loki-grafana 3000:80 -n loki-stack

kubectl get secret loki-grafana -n loki-stack -o jsonpath="{.data.admin-password}" | base64 --decode ; echo


```json
{job="loki.source.kubernetes_events"}
```