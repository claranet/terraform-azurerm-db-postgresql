locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  tier_map = {
    "GeneralPurpose"  = "GP"
    "Basic"           = "B"
    "MemoryOptimized" = "MO"
  }
}
