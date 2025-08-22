# Makefile for starting up lokal Minikube cluster on MacOS and deploying FleetDM Helm chart

CHART_NAME ?= fleet
RELEASE_NAME ?= fleet
NAMESPACE ?= fleet

.PHONY: cluster install uninstall

cluster:
	echo "Ensuring that Docker is running and starting local Minikube k8s cluster..."
	docker ps -a > /dev/null 2>&1 || open --background -a Docker && sleep 5
	minikube start --driver=docker

install:
	echo "Installing Helm chart $(CHART_NAME) into namespace $(NAMESPACE)..."
	helm upgrade --install $(RELEASE_NAME) ./$(CHART_NAME) --namespace $(NAMESPACE) --values values.yaml --create-namespace

uninstall:
	echo "Uninstalling Helm release $(RELEASE_NAME) from namespace $(NAMESPACE)..."
	helm uninstall $(RELEASE_NAME) --namespace $(NAMESPACE) || true
	kubectl delete namespace $(NAMESPACE) --ignore-not-found
