################################################################################
# VPC Peering - Request (Requester - São Paulo)
################################################################################

resource "aws_vpc_peering_connection" "sp_to_ohio" {
  vpc_id      = aws_vpc.sp_vpc.id
  peer_vpc_id = aws_vpc.ohio_vpc.id
  peer_region = var.aws_region_secondary
  auto_accept = false

  tags = {
    Name = "${var.project_name}-peering-sp-ohio"
  }
}

################################################################################
# VPC Peering - Acceptance (Accepter - Ohio)
################################################################################

resource "aws_vpc_peering_connection_accepter" "ohio_accepter" {
  provider                  = aws.ohio
  vpc_peering_connection_id = aws_vpc_peering_connection.sp_to_ohio.id
  auto_accept               = true

  tags = {
    Name = "${var.project_name}-peering-accepter-ohio"
  }
}

################################################################################
# Routes: Teaching São Paulo how to reach Ohio
################################################################################

resource "aws_route" "sp_to_ohio_route" {
  route_table_id            = aws_route_table.sp_private_rt.id
  destination_cidr_block    = var.vpc_ohio_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.sp_to_ohio.id
}

################################################################################
# Routes: Teaching Ohio how to reach São Paulo
################################################################################

resource "aws_route" "ohio_to_sp_route" {
  provider                  = aws.ohio
  route_table_id            = aws_route_table.ohio_private_rt.id
  destination_cidr_block    = var.vpc_sp_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.sp_to_ohio.id
}
