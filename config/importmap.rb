# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@rails/actioncable", to: "@rails--actioncable.js" # @7.0.2
pin_all_from "app/javascript/channels", under: "channels"