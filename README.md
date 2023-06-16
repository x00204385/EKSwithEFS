# Provisioning cluster

This procedure will provision the cluster with EFS and EBS support. 
```
terraform apply
aws eks update-kubeconfig --region us-east-1 --name demo
# Check that nodes are configured
kubectl get nodes
helm repo update aws-efs-csi-driver
helm upgrade -i aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver \
    --namespace kube-system \
    --set controller.serviceAccount.create=false \
    --set controller.serviceAccount.name=efs-csi-controller-sa
kubectl apply -f k8s/efs-service-account.yaml
```

# Test the configuration of the cluster

## Static Provisioning

```
file_system_id=$(aws efs create-file-system \
    --region us-east-1 \
    --performance-mode generalPurpose \
    --query 'FileSystemId' \
    --output text)
echo $file_system_id
cd tests/multiple_pods
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
