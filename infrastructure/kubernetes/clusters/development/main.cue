package development

import (
	lib "github.com/archisman-mridha/llmops/infrastructure/kubernetes/lib"

	ciliumlib "github.com/archisman-mridha/llmops/infrastructure/kubernetes/lib/cilium"
	certmanagerlib "github.com/archisman-mridha/llmops/infrastructure/kubernetes/lib/cert-manager:certmanager"
	kubeprometheusstacklib "github.com/archisman-mridha/llmops/infrastructure/kubernetes/lib/kube-prometheus-stack:kubeprometheusstack"
	argocdlib "github.com/archisman-mridha/llmops/infrastructure/kubernetes/lib/argocd"

	gpuoperatorlib "github.com/archisman-mridha/llmops/infrastructure/kubernetes/lib/gpu-operator:gpuoperator"
	// hamilib "github.com/archisman-mridha/llmops/infrastructure/kubernetes/lib/hami"
	nvsentinellib "github.com/archisman-mridha/llmops/infrastructure/kubernetes/lib/nv-sentinel:nvsentinel"
)

{
	cilium: lib.#App & {
		resources: ciliumlib.#Cilium & {
			helmInstallation: values: {
				operator: replicas: 1

				k8sServiceHost: "0.0.0.0"
			}
		}
	}

	certmanager: lib.#App & {
		resources: certmanagerlib.#CertManager
	}

	kubeprometheusstack: lib.#App & {
		resources: kubeprometheusstacklib.#KubePrometheusStack
	}

	argocd: lib.#App & {
		resources: argocdlib.#ArgoCD
	}

	gpuoperator: lib.#App & {
		resources: gpuoperatorlib.#GPUOperator
	}

	// HAMi needs some more maturity.
	// hami: lib.#App & {
	// 	resources: hamilib.#HAMi & {
	// 		helmInstallation: values: {
	// 			scheduler: kubeScheduler: imageTag: "v1.34.0"
	// 		}
	//
	// 		webUI: helmInstallation: values: {
	// 			externalPrometheus: address: "http://prometheus-kube-prometheus-stack-prometheus-0.kube-prometheus-stack.svc.cluster.local:9090"
	// 		}
	// 	}
	// }

	nvsentinel: lib.#App & {
		resources: nvsentinellib.#NVSentinel
	}
}
