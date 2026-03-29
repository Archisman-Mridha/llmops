package certmanager

import "github.com/archisman-mridha/llmops/infrastructure/kubernetes/lib"

// CertManager adds certificates and certificate issuers as resource types in Kubernetes clusters,
// and simplifies the process of obtaining, renewing and using those certificates. It can issue
// certificates from a variety of supported sources, including Let's Encrypt, HashiCorp Vault etc.
// It will ensure certificates are valid and up to date, and attempt to renew certificates at a
// configured time before expiry.
#CertManager: {
	namespace: string | *"cert-manager"

	helmInstallation: lib.#HelmInstallation & {
		repoURL: "https://charts.jetstack.io/"
		chart:   "cert-manager"
		version: "1.13.1"

		releaseName: "cert-manager"
		namespace:   #CertManager.namespace
		includeCRDs: false

		values: {}
	}
}
