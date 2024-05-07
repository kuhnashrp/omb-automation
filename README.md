# OMB Assistant 

## Tools that Assist in setting up and running OMB tests
v1 of these tools are for use with the [redpanda driver of OMB](https://github.com/redpanda-data/openmessaging-benchmark/tree/main/driver-redpanda)

### Setup OMB Infrastructure
```
# Per https://github.com/redpanda-data/openmessaging-benchmark/blob/main/driver-redpanda/README.md 
brew install terraform ansible
ansible-galaxy role install geerlingguy.node_exporter prometheus.prometheus grafana.grafana
git clone git@github.com:redpanda-data/openmessaging-benchmark.git 
alias python=python3
brew install terraform-inventory
mvn clean package
ssh-keygen -f ~/.ssh/redpanda_aws # hit enter for all prompts
cd driver-redpanda/deploy
```
#### Exec Terraform to provision OMB test infrastructure
```
cp terraform.tfvars.example terraform.tfvars
terraform init
aws sts get-caller-identity || aws sso login
terraform apply -auto-approve
if [ "$(uname)" = "Darwin" ]; then 
    export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES; 
fi
```
#### Exec Ansible to configure the OMB provisioned nodes above.
```
if [ "$(uname)" = "Darwin" ]; then 
    brew install gnu-tar; 
fi # https://github.com/prometheus-community/ansible/issues/186
ansible-galaxy install -r requirements.yaml
ansible-playbook deploy.yaml
```

### Setup BuildKite Agent

```
 ssh -i ~/.ssh/redpanda_aws ubuntu@$(terraform output --raw client_ssh_host)
 ```

