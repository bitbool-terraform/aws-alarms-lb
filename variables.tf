variable "metrics" {
  type = map
  default = {
    "5XX" = {
      "metric_name" = "HTTPCode_ELB_5XX_Count"
      "stat" = "Sum"
      "unit" = "Count"
      "comparison_operator" = "GreaterThanOrEqualToThreshold"
      "percentage_base_metric" = "RequestCount"
      "percentage_stat" = "Sum"
      "namespace" = "AWS/ApplicationELB"
      "treat_missing_data" = "notBreaching"
    }
    "4XX" = {
      "metric_name" = "HTTPCode_ELB_4XX_Count"
      "stat" = "Sum"
      "unit" = "Count"
      "comparison_operator" = "GreaterThanOrEqualToThreshold"
      "percentage_base_metric" = "RequestCount"      
      "percentage_stat" = "Sum"
      "namespace" = "AWS/ApplicationELB" 
      "treat_missing_data" = "notBreaching"
    }    
  }
}

variable "create_percentage_alarms" { default = ["5XX","4XX"] }
variable "create_count_alarms" { default = ["5XX","4XX"] }

variable "default_threshold_percentage" { default = 10 }
variable "default_threshold_count" { default = 50 }

variable "default_evaluation_periods" { default = 1 }
variable "default_period" { default = 120 }

variable "threshold_percentage" { default = {} }
variable "threshold_count" { default = {} }

variable "evaluation_periods" { default = {} }
variable "period" { default = {} }

# variable "alarm_specs" { default = {} }
# overrides like
  #   "5XX" = {
  #     "count" = {
  #       "threshold" = 100
  #       "evaluation_periods" = 1
  #       "period" = 120        
  #     }
  #   }
  # }

variable "balancer" {}
variable "description" {}
variable "prefix" {}

variable "actions" { default = null }
variable "alarm_actions" { default = null }
variable "ok_actions" { default = null }
variable "insufficient_data_actions" { default = null }
