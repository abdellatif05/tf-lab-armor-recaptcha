resource "google_compute_security_policy" "main" {
  advanced_options_config {
    json_parsing = "DISABLED"
  }

  description = "policy for bot management"
  name        = "recaptcha-policy"
  project     = var.project

  recaptcha_options_config {
    redirect_site_key = google_recaptcha_enterprise_key.challenge.name
  }

  rule {
    action      = "deny(403)"
    description = "block invalid token"

    match {
      expr {
        expression = "request.path.matches('test-recaptcha-action.html') && !(token.recaptcha_action.valid)"
      }
    }

    preview  = "false"
    priority = "500"
  }

  rule {
    action = "redirect"

    match {
      expr {
        expression = "request.path.matches('median-score.html') && token.recaptcha_session.score == 0.5"
      }
    }

    preview  = "false"
    priority = "1000"

    redirect_options {
      type = "GOOGLE_RECAPTCHA"
    }
  }

  rule {
    action = "allow"

    match {
      expr {
        expression = "request.path.matches('good-score.html') && token.recaptcha_session.score > 0.4"
      }
    }

    preview  = "false"
    priority = "2000"
  }

  rule {
    action = "deny(403)"

    match {
      expr {
        expression = "request.path.matches('bad-score.html') && token.recaptcha_session.score < 0.6"
      }
    }

    preview  = "false"
    priority = "3000"
  }

  rule {
    action      = "allow"
    description = "default rule"

    match {
      config {
        src_ip_ranges = ["*"]
      }

      versioned_expr = "SRC_IPS_V1"
    }

    preview  = "false"
    priority = "2147483647"
  }

  type = "CLOUD_ARMOR"
}
