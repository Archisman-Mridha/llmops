package argocd

#GeneratedArgoCDAppPatch: {
  spec: {
    // Will ignore differences between live and desired states during the diff.
    ignoreDifferences: [
      // Why do we need to do this?
      //
      // We're installing the ArgoCD Helm chart. Then creating argocd ArgoCD App to manage that
      // ArgoCD installation.
      // Now, initially, when we create the argocd ArgoCD App, it isn't managing ArgoCD. All
      // the Kubernetes resources associated with the App, thus doesn't have the
      // "argocd.argoproj.io/instance: argocd" label.
      // It's only when we sync the App, it starts managing ArgoCD, thus adding labels to all
      // the resources managed by it. This causes checksum changes, which triggers pod
      // restarts.
      //
      // We are preventing the "argocd.argoproj.io/instance: argocd" label to be considered
      // during checksum calculation. So there will be no checksum change (and thus Pod
      // restarts) when we sync the argocd ArgoCD App.
      {
        kind: "*"
        namespace: #ArgoCD.namespace
        jqPathExpressions: [
          ".metadata.labels.\"argocd.argoproj.io/instance\""
        ]
      }
    ]
  }
}
