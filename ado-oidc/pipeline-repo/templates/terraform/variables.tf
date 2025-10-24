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
