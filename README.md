# Provisioning cluster

This procedure will provision the cluster with EFS and EBS support. 
```
terraform apply
aws eks update-kubeconfig --region us-east-1 --name demo
# Check that nodes are configured
kubectl get nodes
helm repo update aws-efs-csi-driver
helm upgrade -i aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver \                                                                                                                    [10:32:58]
    --namespace kube-system \
    --set controller.serviceAccount.create=false \
    --set controller.serviceAccount.name=efs-csi-controller-sa
kubectl apply -f k8s/efs-service-account.yaml
```
#
# Test the configuration of the cluster
#
```
vpc_id=$(aws eks describe-cluster \
    --name demo \
    --query "cluster.resourcesVpcConfig.vpcId" \
    --output text)

file_system_id=$(aws efs create-file-system \
    --region us-east-1 \
    --performance-mode generalPurpose \
    --query 'FileSystemId' \
    --output text)
echo $file_system_id
cd tests/multiple_pods
```
Edit pv.yaml and add the file system id.

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
