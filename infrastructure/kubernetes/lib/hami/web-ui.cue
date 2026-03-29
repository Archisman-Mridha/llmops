package hami

import "github.com/archisman-mridha/llmops/infrastructure/kubernetes/lib"

#HAMi: {
	webUI: helmInstallation: lib.#HelmInstallation & {
		repoURL: "https://project-hami.github.io/HAMi-WebUI"
		chart:   "hami-webui"
		version: "1.0.5"

		releaseName: "hami"
		namespace:   #HAMi.namespace
		includeCRDs: false

		values: {
			externalPrometheus: {
				enabled: true
				address: string
			}
		}
	}
}
