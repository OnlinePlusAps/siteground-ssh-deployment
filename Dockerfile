FROM debian:9.7-slim

LABEL "com.github.actions.name"="GitHub Action for Siteground SSH Gateway Deployment"
LABEL "com.github.actions.description"="An action to deploy your repository to Siteground via the SSH Gateway"
LABEL "com.github.actions.icon"="chevrons-up"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/OnlinePlusAps/siteground-ssh-deployment"
LABEL "maintainer"="OnlinePlus <wordpress@onlineplus.dk>"
RUN apt-get update && apt-get install -y openssh-server rsync
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
