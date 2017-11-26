#variable
${var.foo}

#map
${var.amis["us-east-1"]}

#list
${var.subnets}

#list element
${var.subnets[idx]}

#attributes
${self.private_ip}
${aws_instance.web.id}
${data.aws_ami.ubuntu.id}

#outputs
${module.foo.bar}

