# envoy-job-curl
Small docker image wired with [monzo/envoy-preflight](https://github.com/monzo/envoy-preflight) and curl that are really usefull when running Kubernetes Jobs/CronJobs inside an Istio service mesh (or similar that injects envoy sidecars for jobs).

Envoy-preflight will handle terminating the envoy sidecar when the main container finishes.

## Usage example

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: recurring-curl-poke
spec:
  schedule: "*/5 * * * *"
  concurrencyPolicy: Forbid
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: curl-poker
              image: ghcr.io/jarnfast/envoy-job-curl:latest
              env:
                - name: ENVOY_ADMIN_API
                  value: http://localhost:15000
                - name: ENVOY_KILL_API
                  value: http://localhost:15020/quitquitquit
                - name: ALWAYS_KILL_ENVOY
                  value: "true"
              command: ["/usr/bin/envoy-preflight"]
              args:
              - "sh"
              - "-c"
              - curl -XPOST http://other.svc:80/do-something
          restartPolicy: Never
```
