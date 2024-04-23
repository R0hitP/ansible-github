data "aws_instances" "ansible" {
  instance_tags = {
    target = "test"
  }
}

resource "ansible_host" "host" {
  for_each = toset(data.aws_instances.ansible.private_ips)
  name   = "${each.key}"  # Replace with the actual hostname or IP address of your host
  groups = ["test"]  # Replace with the name of the group(s) this host belongs to in your Ansible inventory

  variables = {
    ansible_user        = "ansible",
    ansible_ssh_private_key_file = "~/.ssh/id_rsa",  # Replace with the path to your SSH private key
    ansible_python_interpreter = "/usr/bin/python3"  # Replace with the path to your Python interpreter
  }
}

resource "ansible_host" "public_host" {
  for_each = toset(data.aws_instances.ansible.public_ips)
  name   = "${each.key}"  # Replace with the actual hostname or IP address of your host
  groups = ["test"]  # Replace with the name of the group(s) this host belongs to in your Ansible inventory

  variables = {
    ansible_user        = "ansible",
    ansible_ssh_private_key_file = "~/.ssh/id_rsa",  # Replace with the path to your SSH private key
    ansible_python_interpreter = "/usr/bin/python3"  # Replace with the path to your Python interpreter
  }
}