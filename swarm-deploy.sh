# check things like image tags, mounts, environment variables for your deployment

docker swarm init
docker network create --driver overlay --attachable argovis-db
docker service create --network argovis-db --name database --limit-memory 24Gi --mount type=bind,source=/home/ubuntu/db/_data,destination=/data/db  mongo:5.0.9
sleep 10
docker service create --network argovis-db --name redis --limit-memory 100Mi argovis/redis:7.0.3-220713
sleep 5
docker service create --network argovis-db --name api --replicas 2 --limit-memory 2Gi -p 8080:8080 argovis/api:2.0.0
docker container run  --network argovis-db --name keymanager -p 3030:3030 -d --restart always -e SENDGRID_API_KEY=your_key_here argovis/api-keymanager:2.0.0
docker container run -d -p 3000:3000 --restart always argovis/react:2.0.0