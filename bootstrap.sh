#!/bin/bash
#
# This is a bootstrap file used for CentOS to install GO, Python, Docker, Docker-compose
# and some other useful tools for development
#
LOG_FILE="/var/log/bootstrap.log"
START_TIME=`date`
PS1="\[\e[32m\]\h\[\e[m\] | \[\e[36m\]\u\[\e[m\]  | \[\e[35m\]\t\[\e[m\] | \[\e[32m\]\w\[\e[m\]\[\e[35m\] ➤ \[\e[m\]"

echo "${START_TIME}: INFO: Start Bootstrapping Process" >> $LOG_FILE


out=$(/usr/bin/yum -y update)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to update yum" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Successfully updated yum" >> $LOG_FILE
fi

out=$(/usr/bin/yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to add docker repo" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Successfully installed docker repo" >> $LOG_FILE
fi

out=$(/usr/bin/yum --enablerepo=extras install epel-release -y)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to enable epel repos" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Successfully enabled epel repos" >> $LOG_FILE
fi

out=$(yum install -y python-devel \
    libffi-devel \
    openssl-devel \
    gcc \
    make \
    dh-autoreconf \
    vim \
    mlocate \
    yum-utils \
    device-mapper-persistent-data \
    lvm2 \
    python-pip \
    docker-ce-19.03.2 docker-ce-cli-19.03.2 containerd.io \
    jq \
    bash-completion bash-completion-extras \
    xz-devel \
    the_silver_searcher)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to install yum packages" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Successfully installed yum packages" >> $LOG_FILE
fi

out=$( systemctl enable docker &&  systemctl start docker)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to enable and start docker" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Successfully enabled and started docker" >> $LOG_FILE
fi

out=$( pip install --upgrade pip)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to update pip" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Successfully updated pip" >> $LOG_FILE
fi

out=$( pip install docker-compose==1.25.0 --ignore-installed)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to install docker-compose" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Successfully installed docker compose" >> $LOG_FILE
fi

out=$( pip install shyaml)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to install shyaml" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Successfully installed shyaml" >> $LOG_FILE
fi

out=$(curl https://dl.google.com/go/go1.13.linux-amd64.tar.gz > /tmp/go.tar.gz)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to download Golang" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Successfully downloaded Golang" >> $LOG_FILE
fi

out=$(tar -C /usr/local -xzf /tmp/go.tar.gz )
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to extract Golang" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Successfully extracted Golang" >> $LOG_FILE
fi

out=$(echo "export PATH=$PATH:/usr/local/go/bin" >> /home/centos/.bash_profile && \
      echo "export GOROOT=/usr/local/go" >> /home/centos/.bash_profile)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to set Go env variables" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Successfully set Go env variables" >> $LOG_FILE
fi

out=$(usermod -aG docker centos)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to added centos user to docker group" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Successfully added centos user to docker group" >> $LOG_FILE
fi

out=$(echo "export PS1=\"$PS1\"" >> /home/centos/.bash_profile)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to set ps1" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Successfully  to set ps1" >> $LOG_FILE
fi

out=$( updatedb && locate bash_completion.sh && source /etc/profile.d/bash_completion.sh)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to add shell autocomplete" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Successfully added shell autocomplete" >> $LOG_FILE
fi

out=$(curl -L https://raw.githubusercontent.com/docker/compose/1.25.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to add docker autocomplete" >> $LOG_FILE
else
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Successfully added docker autocomplete" >> $LOG_FILE
fi
