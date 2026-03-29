# LLMOPs

## Tech Stack

- [Vast AI](https://cloud.vast.ai)
  > Vast AI provides you `Docker containers` as `VAST AI instances`. And, if you want a proper VM,
  > they do have some `KVM` based container image for that. But, the issue is : if you use that
  > `KVM` container image, you cannot use `NVIDIA A100` series GPUs (which support `MIG`).

- [NVIDIA GPU Operator](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html)
  > Planned to use [HAMi](https://project-hami.io/docs) for `GPU partitioning` using `MIG`, but currently it doesn't seem mature enough.

- [NVSentinel](https://github.com/NVIDIA/NVSentinel)

## Creating the Kubernetes cluster

- Create a VastAI instance.

- SSH into that instance, while forwarding port 6443 to your local machine :
  ```sh
  ssh -i ./.key -p 54648 root@69.157.137.231 -L 6443:127.0.0.1:6443
  ```

- Create a single-node Kubernetes cluster using `KubeOne`. You can find the KubeOne config file at [here](./infrastructure/kubernetes/clusters/development/kubeone-cluster.yaml).
  
  Upon facing the following issue :
  ```log
  E: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process 4836 (unattended-upgr)
  E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), is another process using it?
  ```

  you can mitigate it by using the following commands :
  ```sh
  export PID="62019"
  ps -p $PID -o pid,cmd
  sudo kill -9 $PID
  ```

- KubeOne installs `ContainerD v1.17.0` by default. And we can't configure KubeOne to change that.
  So, after bootstrapping the cluster, we manually upgrade the ContainerD version to the latest,
  by executing :
  ```sh
  apt upgrade containerd.io
  systemctl restart containerd
  ```

  > This is going to take a pretty good amount of time, since it's going to build some modules
  > related to the NVIDIA GPUs.

- Remove the `node-role.kubernetes.io/control-plane` taint from the only node of the cluster.

- You can verify whether the NVIDIA GPU Operator is installed properly or not, by checking whether
  the following pod gets scheduled :
  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
    name: cuda-vectoradd
  spec:
    restartPolicy: OnFailure
    containers:
      - name: cuda-vectoradd
        image: "nvcr.io/nvidia/k8s/cuda-sample:vectoradd-cuda11.7.1-ubuntu20.04"
        resources:
          limits:
            nvidia.com/gpu: 1
  ```

## TODOs

- Look at [NVIDIA AICR](https://github.com/NVIDIA/aicr)
