resource "ansible_host" "host" {
  name   = "10.0.139.151"   # Replace with the actual hostname or IP address of your host
  groups = ["test"]  # Replace with the name of the group(s) this host belongs to in your Ansible inventory

  variables = {
    ansible_user        = "ansible",
    ansible_ssh_private_key_file = "~/.ssh/id_rsa",  # Replace with the path to your SSH private key
    ansible_python_interpreter = "/usr/bin/python3"  # Replace with the path to your Python interpreter
  }
}
