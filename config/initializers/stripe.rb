Rails.configuration.stripe = {
  publishable_key: 'pk_test_51JjnbAEBWJ8umcOgRa4E1XhHPDPsSPYt1ciFhiGLf2pl8sFWPOgJI3x45cqUKiUtNCta5V6RSW6PtjjN6o7FeOhI00Boa53qEb',
  secret_key: 'sk_test_51JjnbAEBWJ8umcOgllPtGNhLx0WclY4aFN6I64cHfqFFt9PNd04JYvLNVkIysbO0PxRdi0OnNFTPU29jUlDI50Gf00uRWZKZPW'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
