data "terraform_remote_state" "rds" {
  backend = "remote"
  config = {
    organization = "hellocloud-eem"
    workspaces = {
      name = "create-ec2-rds-day8"
    }
  }
}