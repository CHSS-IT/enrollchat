# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js", preload: true
pin "jquery-ui", to: "https://ga.jspm.io/npm:jquery-ui@1.13.1/ui/widget.js"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@4.6.1/dist/js/bootstrap.js"
pin "popper.js", to: "https://ga.jspm.io/npm:popper.js@1.16.1/dist/umd/popper.js"
pin "bootstrap-select", to: "https://ga.jspm.io/npm:bootstrap-select@1.13.18/dist/js/bootstrap-select.js"