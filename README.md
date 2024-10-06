# aws-eks-cluster

aws-eks-cluster

```bash
eksctl create cluster -f ekscluster.yaml
```

```bash
aws eks update-kubeconfig --region us-east-1 --name eksctl-cluster
```

## aws loadbalancer-controller

```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update
eksctl utils associate-iam-oidc-provider --region us-east-1 --cluster eksctl-cluster --approve
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json
eksctl create iamserviceaccount \
  --cluster eksctl-cluster \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::842676002281:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --set clusterName=eksctl-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-east-1 \
  --namespace kube-system
```


```bash
helm uninstall aws-load-balancer-controller -n kube-system
```

```bash
helm install --values values.yaml loki grafana/loki
helm install --values values.yaml loki grafana/loki --dry-run --debug > output.yaml
```

## Local modified chart

```bash
helm pull grafana/loki --untar
helm install --values values.yaml loki ./loki --dry-run --debug > output.yaml
```

### Articles

<https://repost.aws/knowledge-center/amazon-eks-cluster-access>

<https://aws.amazon.com/blogs/aws/introducing-karpenter-an-open-source-high-performance-kubernetes-cluster-autoscaler/>

<https://aws.amazon.com/blogs/compute/cost-optimization-and-resilience-eks-with-spot-instances/>

<https://aws.amazon.com/blogs/containers/amazon-eks-pod-identity-a-new-way-for-applications-on-eks-to-obtain-iam-credentials/>