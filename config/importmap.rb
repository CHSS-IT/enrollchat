# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@rails/actioncable", to: "@rails--actioncable.js" # @7.0.2
pin_all_from "app/javascript/channels", under: "channels"

pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
