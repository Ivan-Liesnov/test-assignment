# Running FleetDM stack on local Minikube cluster

A brief description of how to start Minikube cluster, install FleetDM tuned Helm chart and cleanup after work finished.

### Prerequsites
This instructions applicable to macOS Sequoia, on other OS/versions setup wasn't tested. Also it is assumed that required tools are already installed and configured (if not - please do it in preferable way now). Tools list:
* `Docker Desktop`
* `minikube`
* `kubectl`
* `helm`
* `make` (as part of `xcode` utils)
* `git`

### Installation & teardown instructions
* clone public GitHub repo [Ivan-Liesnov / test-assignment](https://github.com/Ivan-Liesnov/test-assignment)
* navigate to cloned repo and locate [provided Makefile](/Makefile)
* basic commands are:
  - `make start` - will check if `Docker` service is running and start `minikube` cluster.
  - `make install` - will install provided in repo FleetDM Helm chart with required dependencies.
  - `make uninstall` - will delete installed Helm chart from cluster and cleanup leftovers. 

### Verification steps to confirm FleetDM, MySQL, and Redis are operational
Since it is local install, simpliest way to check if FleetDM, MySQL and Redis are running - do port-forward of appropriative services and try to connect locally.
* MySQL
```bash
kubectl port-forward --namespace fleet svc/fleet-mysql 3306:3306
telnet 127.0.0.1 3306
```
* Redis
```bash
kubectl port-forward --namespace fleet svc/fleet-redis-master 6379:6379
telnet 127.0.0.1 6379
```
* FleetDM
```bash
kubectl port-forward --namespace fleet svc/fleet-service 8080:8080
curl 127.0.0.1:8080
```
Another valid sugestion - use `mysql` client, `redis-cli` to check connection. In case of FleetDM - open forwarded URL in browser.
<img width="1512" height="835" alt="Screenshot 2025-08-21 at 20 52 09" src="https://github.com/user-attachments/assets/d87aa9da-4a30-4d65-82c4-e02bcfbb315e" />

### Additional Notes
* Used FleetDM Helm chart version - `v6.6.12`, maybe it worth rename and restart versioning, as it is modified heavily
* enabled install of bundled MySQL and Redis charts, however MySQL chart was bumped `9.12.5` --> `v14.0.3` to ensure compartibility with local mysql@9 client. Also fleet DB and user were already added to [MySQL chart values](fleet/charts/mysql/values.yaml)
* correct values stored in [root values.yaml](/values.yaml), was disabled ingress creation, using of TLS, correctly configured `Secret` names and `Service` addresses for `MySQL` and `Redis`.
