resource "kubernetes_manifest" "aws_auth" {
  manifest = {
    apiVersion = "v1"
    kind       = "ConfigMap"
    metadata = {
      name      = "aws-auth"
      namespace = "kube-system"
    }
    data = {
      mapUsers = yamlencode([
        {
          userarn  = "arn:aws:iam::${var.account_id}:user/test"
          username = "test"
          groups   = ["system:masters"]
        }
      ])
    }
  }
  depends_on = [module.eks]
}
