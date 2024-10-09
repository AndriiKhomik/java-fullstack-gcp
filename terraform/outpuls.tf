output "frontend_vm_ip" {
  value = module.frontend.frontend_vm_ip
}

output "backend_vm_ip" {
  value = module.backend.backend_vm_ip
}

output "mongodb_vm_ip" {
  value = module.mongodb.mongodb_vm_ip
}

output "postgres_vm_ip" {
  value = module.postgres.postgres_vm_ip
}

output "redis_vm_ip" {
  value = module.redis.redis_vm_ip
}

output "user_name" {
  value = var.user
}
