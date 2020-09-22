init:
	git clone https://github.com/geerlingguy/ansible-role-docker.git roles/geerlingguy.docker
	git clone https://github.com/geerlingguy/ansible-role-pip.git roles/geerlingguy.pip

devops-init:
	virtualenv --python python3 venv && \
	. venv/bin/activate && \
	pip install -r requirements.txt

run-local: devops-init
	sudo ansible-playbook jenkins.yml -i inventory --limit test-local

run-aws-jenkins: devops-init
	ansible-playbook jenkins.yml -i jenkins-aws_ec2.yml --key-file /dir/to/your/.pem

tf-init:
	cd ./terraform/ && terraform init

tf-apply:
	cd ./terraform/ && terraform apply

tf-delete:
	cd ./terraform && terraform destroy -auto-approve
