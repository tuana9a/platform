resource "google_billing_budget" "two_budget_1mil_vnd" {
  billing_account = data.google_billing_account.two.id
  display_name    = "budget_1mil_vnd"
  amount {
    specified_amount {
      currency_code = "VND"
      units         = "1000000"
    }
  }
  budget_filter {
    credit_types_treatment = "INCLUDE_SPECIFIED_CREDITS"
    credit_types = [
      "SUSTAINED_USAGE_DISCOUNT",
      "DISCOUNT",
      "COMMITTED_USAGE_DISCOUNT",
      "FREE_TIER",
      "COMMITTED_USAGE_DISCOUNT_DOLLAR_BASE",
      "SUBSCRIPTION_BENEFIT",
    ]
  }
  threshold_rules {
    threshold_percent = 0.7
  }
  threshold_rules {
    threshold_percent = 0.9
    spend_basis       = "FORECASTED_SPEND"
  }
}

resource "google_billing_budget" "two_budget_2mil_vnd" {
  billing_account = data.google_billing_account.two.id
  display_name    = "budget_2mil_vnd"
  amount {
    specified_amount {
      currency_code = "VND"
      units         = "2000000"
    }
  }
  budget_filter {
    credit_types_treatment = "INCLUDE_SPECIFIED_CREDITS"
    credit_types = [
      "SUSTAINED_USAGE_DISCOUNT",
      "DISCOUNT",
      "COMMITTED_USAGE_DISCOUNT",
      "FREE_TIER",
      "COMMITTED_USAGE_DISCOUNT_DOLLAR_BASE",
      "SUBSCRIPTION_BENEFIT",
    ]
  }
  threshold_rules {
    threshold_percent = 0.5
  }
  threshold_rules {
    threshold_percent = 0.7
    spend_basis       = "FORECASTED_SPEND"
  }
  threshold_rules {
    threshold_percent = 0.9
    spend_basis       = "FORECASTED_SPEND"
  }
}

resource "google_billing_budget" "two_budget_4mil_vnd" {
  billing_account = data.google_billing_account.two.id
  display_name    = "budget_4mil_vnd"
  amount {
    specified_amount {
      currency_code = "VND"
      units         = "4000000"
    }
  }
  budget_filter {
    credit_types_treatment = "INCLUDE_SPECIFIED_CREDITS"
    credit_types = [
      "SUSTAINED_USAGE_DISCOUNT",
      "DISCOUNT",
      "COMMITTED_USAGE_DISCOUNT",
      "FREE_TIER",
      "COMMITTED_USAGE_DISCOUNT_DOLLAR_BASE",
      "SUBSCRIPTION_BENEFIT",
    ]
  }
  threshold_rules {
    threshold_percent = 0.5
    spend_basis       = "FORECASTED_SPEND"
  }
  threshold_rules {
    threshold_percent = 0.7
    spend_basis       = "FORECASTED_SPEND"
  }
  threshold_rules {
    threshold_percent = 0.9
    spend_basis       = "FORECASTED_SPEND"
  }
}
