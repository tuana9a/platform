# # it can take 7 - 37 days for the custom role to be deleted completely and its name can be reused
# resource "google_project_iam_custom_role" "budget_alert_editor" {
#   role_id     = "budget_alert_editor"
#   title       = "budget_alert_editor"
#   description = "budget_alert_editor"
#   permissions = [
#     "billing.budgets.list",
#     "billing.budgets.get",
#     "billing.budgets.create",
#     "billing.budgets.update",
#   ]
# }
