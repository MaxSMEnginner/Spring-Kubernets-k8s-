# Spring Boot en Kubernetes - Guía de Despliegue

Este proyecto demuestra cómo desplegar una aplicación Spring Boot en Kubernetes con autoescalado horizontal y monitoreo
de métricas.

## 📋 Tabla de Contenidos

- [Requisitos Previos](#-requisitos-previos)
- [Configuración de Kubernetes](#-configuración-de-kubernetes)
- [Construcción y Despliegue](#-construcción-y-despliegue)
- [Monitoreo y Métricas](#-monitoreo-y-métricas)
- [Pruebas de Autoescalado](#-pruebas-de-autoescalado)
- [Comandos Útiles](#-comandos-útiles)
- [Troubleshooting](#-troubleshooting)

## 🔧 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- Un cluster de Kubernetes (minikube, Docker Desktop, o un cluster en la nube)
- [Java 21](https://openjdk.org/projects/jdk/21/) o superior
- [Maven 3.9+](https://maven.apache.org/download.cgi)

## ⚙️ Configuración de Kubernetes

### 1. Metrics Server

El Metrics Server es necesario para que ver fácilmente el autoescalado horizontal (HPA). Instálalo primero:

```bash
kubectl apply -f k8s-metric-server.yaml
```

Verifica que esté funcionando:

``` bash
kubectl get pods -n kube-system | grep metrics-server
```

### 2. Configuraciones de los Archivos YAML

#### Deployment `k8s-deployment.yaml`

- **Imagen**: `davinchijv/spring-k8s:1.0`
- **Puerto**: 8080
- **Recursos**: CPU: 100m-500m, Memoria: 128Mi-200Mi
- **Réplicas iniciales**: 1

#### Service `k8s-service.yaml`

- **Tipo**: LoadBalancer
- **Puerto externo**: 80
- **Puerto interno**: 8080

#### HPA `k8s-hpa.yaml`

- **Rango de réplicas**: 1-4 pods
- **Métrica**: 50% de utilización de CPU
- **Versión API**: autoscaling/v2

## 🚀 Construcción y Despliegue

### Paso 1: Construir la Imagen Docker

``` bash
# Construir la imagen localmente
docker build -t tu_usuario/spring-k8s:1.0 .

# (Opcional) Subir a DockerHub
docker push tu_usuario/spring-k8s:1.0
```

> **Nota**: Si subes tu propia imagen, actualiza la referencia en `k8s-deployment.yaml`
>

### Paso 2: Desplegar en Kubernetes

Ejecuta los siguientes comandos en orden:

``` bash
# 1. Aplicar el deployment
kubectl apply -f k8s-deployment.yaml

# 2. Crear el servicio
kubectl apply -f k8s-service.yaml

# 3. Configurar el autoescalado
kubectl apply -f k8s-hpa.yaml
```

### Paso 3: Verificar el Despliegue

``` bash
# Ver el estado de los pods
kubectl get pods

# Ver los servicios
kubectl get services

# Ver el estado del HPA
kubectl get hpa
```

## 📊 Monitoreo y Métricas

### Ver Uso de Recursos

``` bash
# Uso de recursos de todos los pods
kubectl top pods

# Uso de recursos de los nodos
kubectl top nodes
```

### Monitorear el HPA

``` bash
# Ver el estado del autoescalado en tiempo real
kubectl get hpa spring --watch
```

### Ver Logs de la Aplicación

``` bash
# Ver logs del deployment
kubectl logs -l app=spring -f

# Ver logs de un pod específico
kubectl logs <nombre-del-pod> -f
```

## 🧪 Pruebas de Autoescalado

### Generar Carga de Trabajo

Para probar el autoescalado, genera tráfico hacia tu aplicación:

``` bash
# Crear un pod generador de carga
kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://spring; done"
```

### Observar el Escalado

En otra terminal, observa cómo se escala la aplicación:

``` bash
# Ver el HPA en tiempo real
kubectl get hpa spring --watch

# Ver los pods escalándose
kubectl get pods --watch
```

## 🔧 Comandos Útiles

### Gestión de Pods

``` bash
# Listar todos los pods
kubectl get pods

# Describir un pod específico
kubectl describe pod <nombre-del-pod>

# Ejecutar un comando dentro de un pod
kubectl exec -it <nombre-del-pod> -- /bin/bash
```

### Gestión del Deployment

``` bash
# Ver el estado del deployment
kubectl get deployment spring

# Escalar manualmente (temporalmente)
kubectl scale deployment spring --replicas=3

# Ver el historial de rollouts
kubectl rollout history deployment/spring
```

### Debugging

``` bash
# Ver eventos del cluster
kubectl get events --sort-by=.metadata.creationTimestamp

# Ver información detallada del HPA
kubectl describe hpa spring

# Ver configuración del servicio
kubectl describe service spring
```

## 🔍 Troubleshooting

### Problemas Comunes

1. **El HPA no funciona**

``` bash
   # Verificar que metrics-server esté funcionando
   kubectl get apiservice v1beta1.metrics.k8s.io -o yaml
```

1. **Los pods no se crean**

``` bash
   # Ver eventos del deployment
   kubectl describe deployment spring
```

1. **No se puede acceder a la aplicación**

``` bash
   # Verificar el servicio
   kubectl get svc spring
   # En minikube, usar tunnel
   minikube tunnel
```

1. **Imagen no encontrada**
    - Verificar que la imagen existe en el registry
    - Comprobar la configuración de `imagePullPolicy`

### Limpiar Recursos

Para eliminar todos los recursos creados:

``` bash
kubectl delete -f k8s-hpa.yaml
kubectl delete -f k8s-service.yaml
kubectl delete -f k8s-deployment.yaml
kubectl delete -f k8s-metric-server.yaml
```

## 📝 Notas Adicionales

- El autoescalado puede tardar unos minutos en reaccionar a los cambios de carga
- Los recursos definidos en el deployment son críticos para el funcionamiento del HPA
- En entornos de producción, considera usar límites de recursos más específicos
- Para clusters en la nube, ajusta el tipo de servicio según tus necesidades

## 🤝 Contribución

Si encuentras algún problema o tienes sugerencias de mejora, no dudes en crear un issue o pull request.