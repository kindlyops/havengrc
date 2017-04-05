You must create a configmap for the webui pod.

    kubectl create configmap webui-config --from-literal=AUTH0_CLIENT_ID=foo
