resource "aws_cloudwatch_metric_alarm" "percent" {
  for_each =  toset(var.create_percentage_alarms)

  alarm_name        = format("%s-%s-percent",var.prefix,each.key)
  alarm_description = format("%s rate for %s",each.key,var.description)

  comparison_operator       = var.metrics[each.key].comparison_operator
  evaluation_periods        = try(var.evaluation_periods[each.key],var.default_evaluation_periods)
  threshold                 = try(var.threshold_percentage[each.key],var.default_threshold_percentage)

  metric_query {
    id          = "e1"
    expression  = "m2/m1*100"
    label       = "Rate"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = var.metrics[each.key].percentage_base_metric
      namespace   = var.metrics[each.key].namespace
      period      = try(var.period[each.key],var.default_period)
      stat        = var.metrics[each.key].percentage_stat
      unit        = var.metrics[each.key].unit

      dimensions = {
        LoadBalancer = var.balancer #join("/",slice(split("/",aws_elastic_beanstalk_environment.adminapi[each.key].load_balancers[0]),1,4))
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = var.metrics[each.key].metric_name
      namespace   = var.metrics[each.key].namespace
      period      = try(var.period[each.key],var.default_period)
      stat        = var.metrics[each.key].percentage_stat
      unit        = var.metrics[each.key].unit

      dimensions = {
        LoadBalancer = var.balancer 
      }
    }
  }

  alarm_actions             = coalesce(var.alarm_actions,var.actions)
  ok_actions                = coalesce(var.ok_actions,var.actions)
  insufficient_data_actions = coalesce(var.insufficient_data_actions,var.actions)

  treat_missing_data = var.metrics[each.key].treat_missing_data

}

resource "aws_cloudwatch_metric_alarm" "count" {
  for_each =  toset(var.create_count_alarms)

  alarm_name        = format("%s-%s-count",var.prefix,each.key)
  alarm_description = format("%s count for %s",each.key,var.description)

  comparison_operator       = var.metrics[each.key].comparison_operator
  evaluation_periods        = try(var.evaluation_periods[each.key],var.default_evaluation_periods)
  threshold                 = try(var.threshold_count[each.key],var.default_threshold_count)


  metric_name = var.metrics[each.key].metric_name
  namespace   = var.metrics[each.key].namespace
  period      = try(var.period[each.key],var.default_period)
  statistic   = var.metrics[each.key].stat
  unit        = var.metrics[each.key].unit

  dimensions = {
    LoadBalancer = var.balancer 
  }

  alarm_actions             = coalesce(var.alarm_actions,var.actions)
  ok_actions                = coalesce(var.ok_actions,var.actions)
  insufficient_data_actions = coalesce(var.insufficient_data_actions,var.actions)

  treat_missing_data = var.metrics[each.key].treat_missing_data
}


resource "aws_cloudwatch_metric_alarm" "unhealthyHost" {
  for_each =  var.create_unhealthyHost_alarm ? toset(["unhealthyHost"]) : toset([])

  alarm_name        = format("%s-%s",var.prefix,each.key)
  alarm_description = format("%s for %s",each.key,var.description)

  comparison_operator       = var.metrics[each.key].comparison_operator
  evaluation_periods        = try(var.evaluation_periods[each.key],var.default_evaluation_periods)
  threshold                 = try(var.threshold_count[each.key],0.5)


  metric_name = var.metrics[each.key].metric_name
  namespace   = var.metrics[each.key].namespace
  period      = try(var.period[each.key],var.default_period)
  statistic   = var.metrics[each.key].stat
  unit        = var.metrics[each.key].unit

  dimensions = {
    LoadBalancer = var.balancer 
  }

  alarm_actions             = coalesce(var.alarm_actions,var.actions)
  ok_actions                = coalesce(var.ok_actions,var.actions)
  insufficient_data_actions = coalesce(var.insufficient_data_actions,var.actions)

  treat_missing_data = var.metrics[each.key].treat_missing_data
}
