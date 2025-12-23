output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "dashboard_load_balancer_hostname" {
  value = data.kubernetes_service.dashboard_lb.status[0].load_balancer[0].ingress[0].hostname
}

output "dashboard_admin_token" {
  value     = kubernetes_secret_v1.dashboard_admin_token.data["token"]
  sensitive = true
}

