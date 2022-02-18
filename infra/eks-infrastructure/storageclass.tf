resource "kubectl_manifest" "storageclass-tf" {
    yaml_body = <<YAML
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: gp2-retain
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
  fsType: ext4 
reclaimPolicy: Retain
allowVolumeExpansion: true
YAML
}