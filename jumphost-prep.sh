#!/bin/bash
set -e
# set -x
#
# Description: Execute this from within a terraform directory to remotely 
#              setup an OMB jump host ala https://github.com/redpanda-data/openmessaging-benchmark/tree/main/driver-redpanda 

# Author: Jeremy Kuhnash, jeremy.kuhnash@redpanda.com 

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
THIS_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
echo "This Dir: $THIS_DIR"
source $THIS_DIR/settings.sh

# you can manually ssh into the jumphost via from with the driver-redpanda/deploy directory: 
# ssh -i ~/.ssh/redpanda_aws ubuntu@$(terraform output --raw client_ssh_host)
SSH_HOST=$(terraform output --raw client_ssh_host)

ssh -i ~/.ssh/redpanda_aws ubuntu@${SSH_HOST} <<EOF
# Install initial required packages
sudo apt install \
  python-is-python3
python3 -m pip install numpy jinja2 pygal

# Install Buildkite Agent
curl -fsSL https://keys.openpgp.org/vks/v1/by-fingerprint/32A37959C2FA5C3C99EFBC32A79206696452D198 | sudo gpg --dearmor -o /usr/share/keyrings/buildkite-agent-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/buildkite-agent-archive-keyring.gpg] https://apt.buildkite.com/buildkite-agent stable main" | sudo tee /etc/apt/sources.list.d/buildkite-agent.list
sudo apt-get update && sudo apt-get install -y buildkite-agent
sudo sed -i "s/xxx/${__BUILDKITE_AGENT_TOKEN}/g" /etc/buildkite-agent/buildkite-agent.cfg
sudo systemctl enable buildkite-agent && sudo systemctl start buildkite-agent

EOF
