locals {
  tier_map = {
    "GeneralPurpose"  = "GP"
    "Basic"           = "B"
    "MemoryOptimized" = "MO"
  }

  default_configurations = {
    "log_checkpoints"       = "on"
    "log_connections"       = "on"
    "connection_throttling" = "on"
  }
}
