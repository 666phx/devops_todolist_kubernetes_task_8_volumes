# Validation instructions

Deploy everything first:

```
bash bootstrap.sh
```

## 1. App is running

```
kubectl get pods -n todoapp
kubectl get pv,pvc -n todoapp
```

- Pod `todoapp-...` must be `Running` and `READY 1/1`.
- PV `todoapp-pv` and PVC `todoapp-pvc` must both be `Bound`.

Optionally open the app (NodePort is mapped by `cluster.yml`) or port-forward:

```
kubectl port-forward -n todoapp deployment/todoapp 8080:8080
curl http://localhost:8080/api/health
```

Check that the PVC is mounted at `/app/data`:

```
kubectl exec -n todoapp deployment/todoapp -- df -h /app/data
```

## 2. ConfigMap data is mounted as files

```
kubectl exec -n todoapp deployment/todoapp -- ls -l /app/configs
kubectl exec -n todoapp deployment/todoapp -- cat /app/configs/PYTHONUNBUFFERED
```

- Each key of the ConfigMap `app-config` must be a file in `/app/configs` (expected: `PYTHONUNBUFFERED` with content `1`).
- The mount must be read-only (the command must fail with "Read-only file system"):

```
kubectl exec -n todoapp deployment/todoapp -- touch /app/configs/test
```

## 3. Secret data is mounted as a file

```
kubectl exec -n todoapp deployment/todoapp -- ls -l /app/secrets
kubectl exec -n todoapp deployment/todoapp -- cat /app/secrets/SECRET_KEY
```

- Each key of the Secret `app-secret` must be a file in `/app/secrets` (expected: `SECRET_KEY`, decoded value).
- The mount must be read-only:

```
kubectl exec -n todoapp deployment/todoapp -- touch /app/secrets/test
```
