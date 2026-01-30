variable "network_info" {
    type = object({
        vpcid=string
        vpcname=string
        subnets=list(object({
          subnetname=list(string)
          subnetid=list(string)
          subnetaz=list(string) 
        }))
    })
    default = {
      vpcid = "10.0.0.0/16"
      vpcname = "vpc23"
      subnets = [ {
      subnetname=["subnet1","subnet2"]
      subnetid=["10.0.1.0/24","10.0.2.0/24"]
      subnetaz=["ap-south-1a","ap-south-1b"]
      }]
    }
}