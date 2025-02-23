resource "aws_key_pair" "CyberSecurityKeyPair" {
  key_name   = "CyberSecurityKeyPair"
  public_key = file("/home/nicolasyassuda/.ssh/my-ec2-key.pub")
}
