

resource "aws_subnet" "corsa_pii" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr
  availability_zone =  var.zone
  map_public_ip_on_launch = false

  tags = {
    Name = "corsa-pii"
  }
}

resource "aws_route_table" "corsa_pii" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }

  tags = {
    Name = "corsa-pii-route-table"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.corsa_pii.id
  route_table_id = aws_route_table.corsa_pii.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = aws_subnet.corsa_pii.id
}
