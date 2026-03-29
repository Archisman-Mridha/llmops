package hami

import "github.com/archisman-mridha/llmops/infrastructure/kubernetes/lib"

// Formerly known as k8s-vGPU-scheduler, HAMi enables device sharing across multiple containers and
// workloads.
#HAMi: {
	namespace: string | *"hami"

	helmInstallation: lib.#HelmInstallation & {
		repoURL: "https://project-hami.github.io/HAMi"
		chart:   "hami"
		version: "2.8.0"

		releaseName: "hami"
		namespace:   #HAMi.namespace
		includeCRDs: false

		values: {
			// Ensure the scheduler.kubeScheduler.imageTag matches your Kubernetes server version.
			scheduler: kubeScheduler: imageTag: string

			// DRA is a Kubernetes feature that lets you request and share resources among Pods. These
			// resources are often attached devices like hardware accelerators.
			//
			// With DRA, device drivers and cluster admins define device classes that are available to
			// claim in workloads. Kubernetes allocates matching devices to specific claims and places
			// the corresponding Pods on nodes that can access the allocated devices.
			//
			// HAMi has provided support for K8s DRA (Dynamic Resource Allocation). By installing the
			// HAMi DRA webhook in your cluster, you can get a consistent user experience in DRA mode
			// that matches the traditional usage.
			//
			// The implementation of DRA functionality requires support from the corresponding device's
			// DRA Driver. Currently supported devices include: NVIDIA GPU.
			dra: enabled: true

			// MIG enables multiple GPU Instances to run in parallel on a single, physical NVIDIA Ampere
			// architecture GPU.
			//
			// The new Multi-Instance GPU (MIG) feature allows GPUs (starting with NVIDIA Ampere
			// architecture) to be securely partitioned into up to seven separate GPU Instances for CUDA
			// applications, providing multiple users with separate GPU resources for optimal GPU
			// utilization.
			//
			// With MIG, each instance’s processors have separate and isolated paths through the entire
			// memory system - the on-chip crossbar ports, L2 cache banks, memory controllers, and DRAM
			// address busses are all assigned uniquely to an individual instance. This ensures that an
			// individual user’s workload can run with predictable throughput and latency, with the same
			// L2 cache allocation and DRAM bandwidth, even if other tasks are thrashing their own caches
			// or saturating their DRAM interfaces.
			//
			// NOTE : Aside MIG, another strategy for sharing a physical GPU is time slicing.
		}
	}
}
