$(document).ready ->
  table = $('#report').DataTable
    responsive: true
    fixedHeader: true
    columnDefs: [
      { sortable: false, targets: [
          12
        ]
      }
    ]
