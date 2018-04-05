minikube start
kubectl run hello-minikube --image=k8s.gcr.io/echoserver:1.4 --port=8080
kubectl expose deployment hello-minikube --type=NodePort
kubectl get pod
minikube dashboard
read -p "Press any key to continue... " -n1 -s
curl $(minikube service hello-minikube --url)
kubectl proxy
kubectl delete service hello-minikube
kubectl delete deployment hello-minikube
minikube status
minikube stop
