# obnoxious-albatross

(Randomly generated repository and app name)

## Preface

- This project was developed and tested locally using [minikube](https://minikube.sigs.k8s.io/docs/) in a home lab environment. This may affect my runtime versus native Kubernetes runtime commands/application.
- I chose [Python](https://www.python.org/) for the hello world web app as it's the language I'm most comfortable in, however I could have also chosen Rust using [Rocket.rs](https://rocket.rs/) or TypeScript using [Express](https://www.npmjs.com/package/express).
- I've utilised [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry) to host my [Docker image](https://github.com/users/AbstractUmbra/packages/container/package/obnoxious-albatross) for use within the K8s deployment.
- As this is a technical test I have left [`flask`](https://flask.palletsprojects.com/en/stable/) running in it's debug mode. In a production environment we'd switch to another [WSGI](https://en.wikipedia.org/wiki/Web_Server_Gateway_Interface) instead of the native `Flask.run()` method.

### Security notes

- With the consideration of security for a web app, I would never run this facing an exposed interface, meaning that the container would be directly accessible on the public internet. I would personally run this behind a reverse proxy like [NGINX](https://nginx.org/en/) or [Caddy](https://caddyserver.com/) with SSL/TLS configured.
  - Additionally, being behind a firewall like [ufw](https://help.ubuntu.com/community/UFW) as well as implementing [fail2ban](https://github.com/fail2ban/fail2ban) are standard practices for non-enterprise machines in my opinion, I would do this prior to exposing internet facing services.
- Added to the previous note, we would also switch to using a dedicated WSGI application, instead of the Flask native method of running, which also defaults to running in debug mode. This has been considered and deemed outside the scope of the test, minus the discussion around it's security implication.
- If we were going the route of no public endpoints, we would implement an authentication system like [OAuth2](https://oauth.net/2/) or an alternate means of securely providing API tokens or similar.

If this were in a cloud/enterprise environment then the steps above might not be as fitting. If we use Azure hosting as the example then you would use [Azure Firewall](https://learn.microsoft.com/en-us/azure/firewall/overview) and other related cloud native security features, like [RBAC](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview) and [API Gateway](https://learn.microsoft.com/en-us/azure/api-management/api-management-gateways-overview).

## Setup
### Required Software

- [ ] Git
- [ ] Docker
- [ ] Kubernetes runtime (kubectl, kubelet etc...)
  - [ ] Minikube (Optional in place of above)

### Steps

1. Clone the repository and enter directory
```sh
git clone https://github.com/AbstractUmbra/obnoxious-albatross.git
cd obnoxious-albatross
```

<details>
<summary>Build the image locally</summary>

Build the image using the provided Dockerfile.
```sh
docker build -t ghcr.io/abstractumbra/obnoxious-albatross:latest .
```

Spin up a test container using the image.
```sh
docker run -p 8000:8000 ghcr.io/abstractumbra/obnoxious-albatross:latest # add the -d flag to `run` to detach
```

</details>

<details>
<summary>Kubernetes deployment and service</summary>

Create the Kubernetes namespace.
```sh
kubectl create namespace obnoxious-albatross
```

Create the deployment.
```sh
kubectl apply -f k8s/deployment.yaml -n obnoxious-albatross
```

(Optional) View deployment logs.
```sh
kubectl logs -f deployment/obnoxious-albatross-deploy -n obnoxious-albatross
```

Create the service
```sh
kubectl apply -f k8s/service.yaml -n obnoxious-albatross
```

(Optional) Verify service was created and IP assigned
```sh
kubectl get svc -n obnoxious-albatross # add the -w flag to `get svc` to watch command output for changes

# (minikube) once above is complete, I had to port-forward as minikube did not allow the allocation of an external ip
# to access the cluster externally
kubectl port-forward deployment/obnoxious-albatross-deploy -n obnoxious-albatross 8080:8000

# open a new terminal and issue the following command to check the deployed pods and containers are working
# and that we get the hello world response
curl -s http://localhost:8080 # or port 8000 if you did not need to portforward as above
```

</details>

<details>
<summary>Clean up and delete resources</summary>

Remove Kubernetes service
```sh
kubectl delete -f k8s/service.yaml
```

Remove Kubernetes deployment
```sh
kubectl delete -f k8s/deployment.yaml
```

Remove Kubernetes namespace
```sh
kubectl delete namespace obnoxious-albatross
```

Remove Docker image
```sh
docker image rm ghcr.io/abstractumbra/obnoxious-albatross:latest
```

</details>
