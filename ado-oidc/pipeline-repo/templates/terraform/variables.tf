# ACAI Solutions
# Copyright (C) 2025 ACAI GmbH
#
# This file is part of ACAI VECTO. Visit https://www.acai.gmbh or https://docs.acai.gmbh for more information.
# 
# Proprietary and Confidential - Licensed under ACAI Rahmen-Lizenzvertrag + Order Form (Subscription required)
# For full license text, see LICENSE file in repository root.
#
# For commercial licensing, contact: contact@acai.gmbh


variable "cicd_metadata" {
  type    = map(string)
  default = {}
  validation {
    condition = (
      alltrue([
        for key, value in var.cicd_metadata :
        length(key) > 0 && length(key) <= 128 && !startswith(key, "aws:") &&
        length(value) <= 256 &&
        can(regex("^[a-zA-Z0-9 ._:/=+\\-@]+$", key)) &&
        can(regex("^[a-zA-Z0-9 ._:/=+\\-@]*$", value))
      ])
    )
    error_message = "Each tag key must be between 1 and 128 characters in length, not start with 'aws:', consist of allowed characters (alphanumeric, spaces, and ._:/=+-@), and each tag value must be between 0 and 256 characters in length and also consist of allowed characters."
  }
}
