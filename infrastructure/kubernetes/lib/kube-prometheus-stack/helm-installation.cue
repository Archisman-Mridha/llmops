package kubeprometheusstack

import "github.com/archisman-mridha/llmops/infrastructure/kubernetes/lib"

#KubePrometheusStack: {
	namespace: string | *"kube-prometheus-stack"

	helmInstallation: lib.#HelmInstallation & {
		repoURL: "https://prometheus-community.github.io/helm-charts"
		chart:   "kube-prometheus-stack"
		version: "82.15.1"

		releaseName: "kube-prometheus-stack"
		namespace:   #KubePrometheusStack.namespace
		includeCRDs: true

		values: {
			prometheus: prometheusSpec: {
				// PodMonitors to be selected for target discovery.
				// When {}, select all PodMonitors.
				podMonitorSelector: {}

				// When true, a nil or {} value for prometheus.prometheusSpec.podMonitorSelector will cause
				// the prometheus resource to be created with selectors based on values in the helm
				// deployment, which will also match the podmonitors created.
				podMonitorSelectorNilUsesHelmValues: false

				// Namespaces to be selected for ServiceMonitor discovery.
				serviceMonitorNamespaceSelector: {}

				// When true, a nil or {} value for prometheus.prometheusSpec.serviceMonitorSelector will
				// cause the prometheus resource to be created with selectors based on values in the helm
				// deployment, which will also match the servicemonitors created.
				serviceMonitorSelectorNilUsesHelmValues: false
			}

			prometheusOperator: tls: enabled: false
		}
	}
}
