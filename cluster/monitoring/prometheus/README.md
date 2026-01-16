# Prometheus Stack Deployment

Monitoring stack for k3s cluster using `kube-prometheus-stack` Helm chart.

## Files

- **`values.yaml`** - Override values (your customizations)
- **`values-default.yaml`** - Default chart values (reference only)

## Deployment

The Prometheus stack is already deployed on my Ubuntu VM 

If you need to redeploy or modify:

```powershell
cd c:\Users\cezar\github\my-home-lab-k3s\cluster\monitoring\prometheus

# Update Helm repos
helm repo update

# Read Grafana password from credentials file (skip empty lines)
$GRAFANA_PASSWORD = Get-Content '../grafana credentials.txt' | Where-Object { $_.Trim() -ne '' } | Select-Object -Last 1

# Validate password was read
if (-not $GRAFANA_PASSWORD) {
    Write-Host "❌ Error: Could not read Grafana password from ../grafana credentials.txt" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Grafana password loaded: $($GRAFANA_PASSWORD.Substring(0,6))..." -ForegroundColor Green

# Upgrade the release with your custom values
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack `
  -n monitoring `
  -f .\values.yaml `
  --set grafana.adminPassword=$GRAFANA_PASSWORD

# Verify deployment
kubectl get pods -n monitoring
kubectl get svc -n monitoring
```

## Access

**From Windows (NodePort):**

Get the Ubuntu VM IP and NodePort:
```powershell
# Find your Ubuntu VM IP
$UBUNTU_IP = "x.x.x.x"  # Update this with your actual VM IP

# Get the NodePorts
kubectl get svc -n monitoring -o wide

# Access via browser
# Prometheus: http://$UBUNTU_IP:<prometheus-nodeport>
# Grafana: http://$UBUNTU_IP:<grafana-nodeport>
```

**Port Forwarding (local access):**

```powershell
# Grafana on localhost:3000
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80

# Prometheus on localhost:9090
kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090
```

## Credentials

- **Grafana Admin**: `admin` / (password stored in `../grafana credentials.txt`)
- Password is injected at deployment time via `--set` flag
- **DO NOT** store passwords in `values.yaml` or commit to git

## Customization

Edit `values.yaml` to customize:
- Retention period (currently: 15 days)
- Storage size (Prometheus: 20Gi, Alertmanager: 5Gi)
- Grafana admin password
- Service monitors and pod monitors
- Alerting rules

For all available options, reference `values-default.yaml` (auto-generated from Helm chart).

## Useful Commands

```powershell
# Check Prometheus targets
kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090
# Visit: http://localhost:9090/targets

# View Prometheus logs
kubectl logs -n monitoring -l app.kubernetes.io/name=prometheus -f

# View Grafana logs
kubectl logs -n monitoring -l app.kubernetes.io/name=grafana -f

# Describe the Prometheus object
kubectl describe prometheus -n monitoring
```

## Documentation

- [kube-prometheus-stack Helm Chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [Prometheus Operator](https://prometheus-operator.dev/)
