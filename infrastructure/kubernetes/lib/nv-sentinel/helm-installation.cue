package nvsentinel

import kustomizeapitypes "sigs.k8s.io/kustomize/api/types"

// NVSentinel automatically detects, classifies, and remediates hardware and software faults in
// GPU nodes. It monitors GPU health, system logs, and cloud provider maintenance events, then
// takes action: cordoning faulty nodes, draining workloads, and triggering break-fix workflows.
#NVSentinel: {
	namespace: string | *"nv-sentinel"

	kustomization: kustomizeapitypes.#Kustomization & {
		namespace: #NVSentinel.namespace

		helmCharts: [{
			repo:    "oci://ghcr.io/nvidia"
			name:    "nvsentinel"
			version: "v1.0.0"

			releaseName: "nv-sentinel"
			namespace:   #NVSentinel.namespace

			valuesInline: {
				faultQuarantine: enabled:  true
				nodeDrainer: enabled:      true
				faultRemediation: enabled: true
				janitor: enabled:          true

				mongodbStore: enabled: false
			}
		}]
	}
}
