# Обьединение vm в группу

resource "google_compute_instance_group" "reddit-group" {
  name = "reddit-group"

  instances = [
    "${google_compute_instance.app.*.self_link}",
  ]

  named_port {
    name = "http"
    port = "9292"
  }

  zone = "${var.zone}"
}

# Создание проверки на доступность
resource "google_compute_http_health_check" "reddit-health" {
  name               = "reddit-health"
  request_path       = "/"
  timeout_sec        = 5
  check_interval_sec = 5
  port               = "9292"
}

resource "google_compute_backend_service" "reddit-backend" {
  name        = "reddit-backend"
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 10

  backend {
    group = "${google_compute_instance_group.reddit-group.self_link}"
  }

  health_checks = ["${google_compute_http_health_check.reddit-health.self_link}"]
}

resource "google_compute_url_map" "reddit-urlmap" {
  name            = "reddit-urlmap"
  default_service = "${google_compute_backend_service.reddit-backend.self_link}"
}

resource "google_compute_target_http_proxy" "reddit-proxy" {
  name    = "proxy-reddit"
  url_map = "${google_compute_url_map.reddit-urlmap.self_link}"
}

resource "google_compute_global_forwarding_rule" "reddit-forwarding-rule" {
  name       = "reddit-website"
  target     = "${google_compute_target_http_proxy.reddit-proxy.self_link}"
  port_range = "80"
}
