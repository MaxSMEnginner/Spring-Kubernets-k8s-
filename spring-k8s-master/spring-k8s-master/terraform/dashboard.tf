resource "helm_release" "kubernetes_dashboard" {
  depends_on       = [module.eks, kubernetes_manifest.aws_auth]
  provider         = helm.eks_admin
  name             = "kubernetes-dashboard"
  namespace        = "kubernetes-dashboard"
  repository       = "https://kubernetes.github.io/dashboard/"
  chart            = "kubernetes-dashboard"
  create_namespace = true
  version          = "7.14.0"

  set {
    name  = "protocolHttp"
    value = "true"
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

}

resource "kubernetes_service_account" "dashboard_admin" {
  depends_on = [helm_release.kubernetes_dashboard]

  metadata {
    name      = "admin-user"
    namespace = "kubernetes-dashboard"
  }
}

resource "kubernetes_cluster_role_binding" "dashboard_admin_binding" {
  depends_on = [kubernetes_service_account.dashboard_admin]
  metadata {
    name = "admin-user-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.dashboard_admin.metadata[0].name
    namespace = "kubernetes-dashboard"
  }
}

resource "kubernetes_secret_v1" "dashboard_admin_token" {
  depends_on = [kubernetes_service_account.dashboard_admin]
  metadata {
    name      = "admin-user-token"
    namespace = "kubernetes-dashboard"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.dashboard_admin.metadata[0].name
    }
  }

  type = "kubernetes.io/service-account-token"
}

data "kubernetes_service" "dashboard_lb" {
  depends_on = [helm_release.kubernetes_dashboard]

  metadata {
    name      = "kubernetes-dashboard"
    namespace = "kubernetes-dashboard"
  }
}


