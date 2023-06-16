# Provisioning cluster

This procedure will provision the cluster with EFS and EBS support. 
```sh
terraform apply --auto-approve
aws eks update-kubeconfig --region us-east-1 --name demo
```
## Check that nodes are configured
```sh
kubectl get nodes -o wide
```

## Install the EFS CSI driver with helm
```sh
helm repo update aws-efs-csi-driver
helm upgrade -i aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver \
    --namespace kube-system \
    --set controller.serviceAccount.create=false \
    --set controller.serviceAccount.name=efs-csi-controller-sa
```

### Create the K8S service account

```sh
kubectl apply -f k8s/efs-service-account.yaml
```

# Test the configuration of the cluster

## Static Provisioning
See the tests directory and the multiple-pods example.

```ssh
terraform output
```
Should provde the FSID
```
efs_id = "fs-0005e8f3b30f5086f"
```

Edit pv.yaml and add the file system id.

Deploy the example

```
kubectl apply -f specs/pv.yaml
kubectl apply -f specs/claim.yaml
kubectl apply -f specs/storageclass.yaml
```

Deploy the app1 and app2 pods. 
```
kubectl apply -f specs/pod1.yaml
kubectl apply -f specs/pod2.yaml
kubectl get pods --watch
```

Verify that data is being written to the volume.
```
kubectl exec -ti app1 -- tail /data/out1.txt
```

## Dynamic Provisioning
Change storageclass.yaml to have the correct file system id.

```sh
kubectl apply -f examples/kubernetes/dynamic_provisioning/specs/storageclass.yaml
kubectl apply -f examples/kubernetes/dynamic_provisioning/specs/pod.yaml
```

```sh
kubectl get pods
```

Also you can verify that data is written onto EFS filesystem:

```sh
kubectl exec -ti efs-app -- tail -f /data/out
```
