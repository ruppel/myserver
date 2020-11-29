#
# Usage:
# First: Check, that docker is up and running
# Second: ./docker-ansible-playbook.sh -i inventory.yml taskfile.yml
#

docker run --rm \
  -v ${HOME}/.ssh/:/root/.ssh/:ro \
  -v $(pwd):/data \
  cytopia/ansible:latest-tools ansible-playbook $@

# run the bash for checks
# docker run -t -i \
#   -v ${HOME}/.ssh/:/root/.ssh/:ro \
#   -v $(pwd):/data \
#   cytopia/ansible:latest-tools