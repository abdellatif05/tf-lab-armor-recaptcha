resource "google_recaptcha_enterprise_key" "challenge" {
  display_name = "challenge-key"
  project      = var.project

  waf_settings {
    waf_feature = "CHALLENGE_PAGE"
    waf_service = "CA"
  }

  web_settings {
    integration_type              = "INVISIBLE"
    allow_all_domains             = true
    allowed_domains               = []
    challenge_security_preference = "USABILITY"
  }
}

resource "google_recaptcha_enterprise_key" "session" {
  display_name = "session-key"
  project      = var.project

  waf_settings {
    waf_feature = "SESSION_TOKEN"
    waf_service = "CA"
  }

  testing_options {
    testing_score = 0.5
  }

  web_settings {
    integration_type  = "SCORE"
    allow_all_domains = true
    allowed_domains   = []
  }
}

resource "google_recaptcha_enterprise_key" "action" {
  display_name = "action-key"
  project      = var.project

  waf_settings {
    waf_feature = "ACTION_TOKEN"
    waf_service = "CA"
  }

  web_settings {
    integration_type  = "SCORE"
    allow_all_domains = true
    allowed_domains   = []
  }
}
