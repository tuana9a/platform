data "google_billing_account" "vpbank" {
  display_name = "vpbank"
  open         = true
}

resource "google_billing_budget" "vpbank_1000000VND" {
  billing_account = data.google_billing_account.vpbank.id
  display_name    = "1000000VND"
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
    spend_basis       = "CURRENT_SPEND"
  }
  threshold_rules {
    threshold_percent = 0.9
    spend_basis       = "CURRENT_SPEND"
  }
}

resource "google_billing_budget" "vpbank_2000000VND" {
  billing_account = data.google_billing_account.vpbank.id
  display_name    = "2000000VND"
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
    spend_basis       = "CURRENT_SPEND"
  }
  threshold_rules {
    threshold_percent = 0.7
    spend_basis       = "CURRENT_SPEND"
  }
  threshold_rules {
    threshold_percent = 0.9
    spend_basis       = "CURRENT_SPEND"
  }
}

resource "google_billing_budget" "vpbank_4000000" {
  billing_account = data.google_billing_account.vpbank.id
  display_name    = "4000000VND"
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
    spend_basis       = "CURRENT_SPEND"
  }
  threshold_rules {
    threshold_percent = 0.7
    spend_basis       = "CURRENT_SPEND"
  }
  threshold_rules {
    threshold_percent = 0.9
    spend_basis       = "CURRENT_SPEND"
  }
}
