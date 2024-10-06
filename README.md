# aws-eks-cluster

aws-eks-cluster

## aws loadbalancer-controller

```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update
eksctl utils associate-iam-oidc-provider --region us-east-1 --cluster eksctl-cluster --approve
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json
```

```bash
eksctl create iamserviceaccount \
  --cluster eksctl-cluster \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::842676002281:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
```

```bash
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --set clusterName=eksctl-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-east-1 \
  --namespace kube-system
```

```bash

```

```bash
helm uninstall aws-load-balancer-controller -n kube-system
```


https://repost.aws/knowledge-center/amazon-eks-cluster-access