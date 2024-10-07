# Makefile for EKS Cluster Setup and AWS Load Balancer Controller Installation

# Variables
CLUSTER_NAME := eksctl-cluster
REGION := us-east-1
POLICY_NAME := AWSLoadBalancerControllerIAMPolicy
ACCOUNT_ID := 842676002281

# Create EKS cluster
create:
	eksctl create cluster -f ekscluster.yaml
	aws eks update-kubeconfig --region $(REGION) --name $(CLUSTER_NAME)

# Install AWS Load Balancer Controller
lb-controller:
	eksctl utils associate-iam-oidc-provider --region $(REGION) --cluster $(CLUSTER_NAME) --approve
	curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
	aws iam create-policy --policy-name $(POLICY_NAME) --policy-document file://iam_policy.json
	eksctl create iamserviceaccount \
	  --cluster $(CLUSTER_NAME) \
	  --namespace kube-system \
	  --name aws-load-balancer-controller \
	  --attach-policy-arn arn:aws:iam::$(ACCOUNT_ID):policy/$(POLICY_NAME) \
	  --approve
	helm repo add eks https://aws.github.io/eks-charts
	helm repo update
	helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
	  --set clusterName=$(CLUSTER_NAME) \
	  --set serviceAccount.create=false \
	  --set serviceAccount.name=aws-load-balancer-controller \
	  --set region=$(REGION) \
	  --namespace kube-system

delete:
	eksctl delete cluster -f ekscluster.yaml

# All-in-one target
all: cluster lb-controller

.PHONY: cluster lb-controller delete all