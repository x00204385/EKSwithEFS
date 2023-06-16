# provider "helm" {
#   kubernetes {
#     config_path = "~/.kube/config"
#   }
# }


# resource "helm_release" "aws_efs_csi_driver" {
#   name       = "aws-efs-csi-driver"
#   repository = "https://github.com/kubernetes-sigs/aws-efs-csi-driver"

#   chart = "aws-efs-csi-driver"

#   version = "1.5.6"

#   namespace = "kube-system"

#   set {
#     name  = "controller.serviceAccount.create"
#     value = "false"
#   }

#   set {
#     name  = "controller.serviceAccount.name"
#     value = "efs-csi-controller-sa"
#   }
# }

