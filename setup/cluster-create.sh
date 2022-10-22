#!/bin/bash
export KUBECONFIG="config"
project="it-atlas-cern"
gcpclusters=$(gcloud container clusters list)
kubeclusters=$(kubectl config get-clusters)
while IFS=, read name version region machinetype numnodes options
do
	if [[ $gcpclusters == *"${name}"* ]]; then
		if [[ $kubeclusters == *"gke_${project}_${region}_${name}"* ]]; then
			continue
		fi
		gcloud container clusters get-credentials --region ${region} ${name}
		continue
	fi
    gcloud container clusters create ${name} --async --cluster-version ${version} --region ${region} --machine-type ${machinetype} --num-nodes ${numnodes} ${options}
done < cluster-layout
