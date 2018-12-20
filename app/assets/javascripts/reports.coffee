$(document).on 'turbolinks:load', ->
  table = $('#report').DataTable
    responsive: true
    fixedHeader: true
    columnDefs: [
      { sortable: false, targets: [
          12
        ]
      }
    ]
