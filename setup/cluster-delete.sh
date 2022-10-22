#!/bin/bash
export KUBECONFIG="config"
project="it-atlas-cern"
gcpclusters=$(gcloud container clusters list)
kubeclusters=$(kubectl config get-clusters)
while IFS=, read name version region machinetype numnodes options
do
	if [[ $gcpclusters == *"${name}"* ]]; then
		echo "Delete cluster ${name}..."
    	gcloud -q container clusters delete ${name} --async --region ${region}
	fi
done < cluster-layout
