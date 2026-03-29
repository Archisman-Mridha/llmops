package cilium

import "github.com/archisman-mridha/llmops/infrastructure/kubernetes/lib"

#Cilium: {
	namespace: string | *"cilium"

	helmInstallation: lib.#HelmInstallation & {
		repoURL: "https://helm.cilium.io/"
		chart:   "cilium"
		version: "1.19.2"

		releaseName: "cilium"
		namespace:   #Cilium.namespace
		includeCRDs: false

		values: {
			// Use Cilium's SocketLB feature, instead of kube-proxy.
			kubeProxyReplacement: "true"
			k8sServiceHost:       string
			k8sServicePort:       "6443"

			// Hubble is a fully distributed networking and security observability platform, built on top
			// of Cilium and eBPF.
			hubble: {
				// By default, Hubble API operates within the scope of the individual node on which the
				// Cilium agent runs. This confines the network insights to the traffic observed by the
				// local Cilium agent.
				// Upon deploying Hubble Relay, network visibility is provided for the entire cluster or
				// even multiple clusters in a ClusterMesh scenario.
				// In this mode, Hubble data can be accessed via Hubble UI.
				relay: enabled: true

				// Hubble UI is a web interface which enables automatic discovery of the services
				// dependency graph at the L3/L4 and even L7 layer, allowing user-friendly visualization
				// and filtering of data flows as a service map.
				ui: enabled: true
			}
		}
	}
}
