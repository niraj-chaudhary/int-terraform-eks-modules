# To integrate open-source logging and monitoring solutions into your Kubernetes cluster for tracking resource utilization, system health, and application performance, you can use a combination of Prometheus, Grafana, and ELK Stack (Elasticsearch, Logstash, Kibana) / LOKI Stack

1. Prometheus for Monitoring
Prometheus is a powerful open-source monitoring system and time-series database that is widely used in Kubernetes environments for collecting and querying metrics.
a) Install Prometheus
    1) Using Helm: It is a package manager for Kubernetes that simplifies the installation of applications. To install Prometheus using Helm:
    * Add the Prometheus Helm Chart Repository:
        helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
        helm repo update

    * Install Prometheus
        helm install prometheus prometheus-community/prometheus --namespace monitoring --create-namespace

    * Verify Installation:
        kubectl get pods -n monitoring

b) Configure Prometheus
    1) Add Targets:
    Prometheus needs to be configured to scrape metrics from various sources. You can configure this in the prometheus.yml file, which should be included in your Prometheus deployment.
    Example:
    scrape_configs:
      - job_name: 'kubernetes-apiservers'
        kubernetes_sd_configs:
          - role: apiserver
        relabel_configs:
          - source_labels: [__address__]
            target_label: instance
      - job_name: 'kubernetes-nodes'
        kubernetes_sd_configs:
          - role: node
        relabel_configs:
          - source_labels: [__address__]
            target_label: instance
      - job_name: 'kubernetes-pods'
        kubernetes_sd_configs:
          - role: pod
        relabel_configs:
          - source_labels: [__address__]
            target_label: instance

2. Grafana for Visualization
    Grafana is an open-source platform for monitoring and observability that integrates well with Prometheus to visualize metrics.

    a) Install Grafana 
     * Using Helm
        helm install grafana grafana/grafana --namespace monitoring
     * Verifying Installation
        kubectl get pods -n monitoring

# We can use the Ingress to expose grafana to access on 443.

* During setup we can use port-forwarding
kubectl port-forward service/grafana 3000:3000 -n monitoring
we will Login on Grafana and Go to Configuration > Data Sources and add Prometheus with URL http://prometheus:9090

* Create Dashboards: Use Grafana’s interface to create dashboards and visualizations. We can use pre-built dashboards from the Grafana community or create custom ones to visualize CPU usage, memory usage, network traffic, and other metrics

-------
# Logging

* Loki Stack for Logging
Loki is a log aggregation system designed to work seamlessly with Grafana. It is lightweight, easy to set up, and optimized for performance.

a) Install Loki: 
    1) Using Helm: 
        * Add the Loki Helm Chart Repository:
        helm repo add grafana https://grafana.github.io/helm-charts
        helm repo update
    
        * Install Loki:
        helm install loki grafana/loki-stack --namespace logging --create-namespace

        * Verify Installation:
        kubectl get pods -n logging

b) Install Promtail
Promtail is an agent that ships logs to Loki. It’s responsible for collecting logs from Kubernetes pods and sending them to Loki.
    1) Using Helm:
       * Install Promtail:
        helm install promtail grafana/promtail --namespace logging
        * Verifying:
        kubectl get pods -n logging

c) Configure Loki and Promtail
    1) Loki Configuration:
        * Create a ConfigMap for Loki:
        apiVersion: v1
        kind: ConfigMap
        metadata:
        name: loki-config
        namespace: logging
        data:
        loki-config.yaml: |
            server:
            http_listen_port: 3100
            distributor:
            ring:
                kvstore:
                store: inmemory
            ingester:
            chunk_idle_period: 5m
            chunk_retain_period: 30s
            max_chunk_age: 1h
            chunk_target_size: 1048576
            storage_config:
            boltdb_shipper:
                active_index_directory: /loki/index
                cache_location: /loki/cache
                shared_store: filesystem
            filesystem:
                directory: /loki/chunks
            limits_config:
            ingestion_rate_mb: 5
            ingestion_rate_mb: 20
            ingestion_burst_size_mb: 100
            schema_config:
            configs:
            - from: 2020-10-24
                store: boltdb-shipper
                object_store: filesystem
                schema: v11
                index:
                prefix: index_
                store: boltdb-shipper
                chunks:
                    prefix: chunks_
                config:
                    index_store: filesystem

    2) Promtail Configuration:
        * Create a ConfigMap for Promtail:

        apiVersion: v1
        kind: ConfigMap
        metadata:
        name: promtail-config
        namespace: logging
        data:
        promtail.yaml: |
            server:
            http_listen_port: 9080
            positions:
            filename: /var/log/positions.yaml
            clients:
            - url: http://loki:3100/loki/api/v1/push
            scrape_configs:
            - job_name: system
                static_configs:
                - targets:
                    - localhost
                    labels:
                    job: varlogs
                    __path__: /var/log/*.log

# Add Loki as a Data Source in Grafana:
    * Go to Configuration > Data Sources in Grafana.
    * Add Loki with URL http://loki:3100.

3) Create Dashboards:
    * Create dashboards for visualizing metrics from Prometheus and logs from Loki. Grafana’s interface allows us to combine metrics and logs in a single dashboard, giving a comprehensive view of our system.