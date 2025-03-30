resource "aws_instance" "this" {
  ami                    = "ami-09c813fb71547fc4f"
  #vpc_security_group_ids = [aws_security_group.allow_tls.id]
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  instance_type          = "t3.micro"
  subnet_id = local.public_subnet_id
  # 20GB is not enough
  root_block_device {
    volume_size = 50  # Set root volume size to 50GB
    volume_type = "gp3"  # Use gp3 for better performance (optional)
  }
  
  user_data = file("bastion.sh")
  tags = merge(
     var.common_tags,
     {
       Name = "${var.project_name}-${var.environment}-bastion"
     }
  )
}
#Adding provisioner to avoid manull installation
  # provisioner "remote-exec" {
  #   inline = [
       
  #     "lsblk", #before docker disk space
  #     "sudo growpart /dev/nvme0n1 4",
  #     "sudo lvextend -l +50%FREE /dev/RootVG/rootVol",
  #     "sudo lvextend -l +50%FREE /dev/RootVG/varVol",
  #     "sudo xfs_growfs /",
  #     "sudo xfs_growfs /var",
  #     "df -hT", #to check the diskapce partition

  #     "sudo dnf -y install dnf-plugins-core",
  #     "sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo",
  #     "sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
  #     "sudo systemctl enable --now docker",
  #     "sudo systemctl start docker",
  #     "sudo usermod -aG docker ec2-user"
  #   ]
  # }
  
  # connection {
  #   type        = "ssh"
  #   user        = "ec2-user"
  #   password    = "DevOps321"
  #   host        = self.public_ip
  # }
  # #Ending provisioner code