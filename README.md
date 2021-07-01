# Travaux Pratiques : My API on Kubernetes

## Objectifs

L'objectif de ce TP est de créer un *cluster* kubernetes permettant le déploiement d'un *pod* répliqué sur plusieurs *node* et utilisant un partage NFS pour fournir de la donnée à ses conteneurs. Ce TP utilise deux conteneurs qui présentent des APIs simple permettant de renvoyer des données au format JSON via le protocole HTTP. L'une des API est un backend (il est connecté au NFS) et l'autre est un frontend (dont le port est ouvert en dehors du cluster).

## Les applicatifs

Les applicatifs utilisés dans ce TP sont des images docker récupérées depuis DeckerHub aux adresses suivante : https://hub.docker.com/repository/docker/darkbahhh/myapi-backend et https://hub.docker.com/repository/docker/darkbahhh/myapi-frontend .
Le code ayant permis la génération de ses deux images est disponible à l'adresse suivante https://github.com/DarkBahhh/myapi_python .

## Le déploiement

Utiliser le fichier Vagrantfile pour déployer les machines virtuelles nécessaires: nasnfs (serveur NFS), master (*master* du cluster), node1 et node2 (les *node* sont utilisés comme *worker* kubernetes).
Une fois les machines virtuelles déployées, l'ensemble des outils et configurations nécessaire au cluster sont aussi déployés. La prochaine étape est de récupérer sur le master le contenu du fichier "/vagrant/join_kube_cluster", celui-ci contient la commande nécessaire pour joindre un node au cluster.

La suite consiste donc à se rendre sur les nodes afin d'exécuter cette commande (en root).
Une fois les node ayant rejoint le cluster, celui-ci est fonctionnel et il est donc possible de déployer et d'exécuter le pod. On peut le vérifier en exécutant la commande "kubectl get nodes" sur le master.

## Exécution du pod

Se rendre sur le master, dans le répertoire "/vagrant/pod_myapi" où l'on trouve le script bash "install.sh". Ce script applique l'ensemble de la configuration kubernetes contenue dans le réperoire "/vagrant/pod_myapi/config".

L'ensemble de la configuration du pod (partage de fichier, conteneur, réseau, etc) est fonctionnelle une fois le script exécuté. On peut vérifier l'exécution du pod via la commande "kubectl get pods".

## Résultat du TP

Arrivé à cette étape, les machines, le cluster et le pod sont déployer et fonctionnel. On peut vérifier l'accès à l'API en joignant (depuis le PC hôte de vagrant) les node sur le port déclaré dans la configuration du service du pod.

- Test sur le 1er node : http://10.0.3.4:30080
- Test sur le 2nd node : http://10.0.3.5:30080

Le retour de ce test, doit être le contenu du fichier "data.txt" présent dans le répertoire partagé via le NFS. Ce contenu est présenté dans une page WEB au format JSON.
Un autre test est de se rendre sur le nasnfs pour modifier le contenu du fichier "/share/nfs/myapi/data.txt". Ces modifications doivent être répercuté sur l'API.
