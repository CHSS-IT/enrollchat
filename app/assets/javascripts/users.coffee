$(document).ready ->
  table = $('#user-list').DataTable
    responsive: true
    fixedHeader: true
    order: [[ 1, "asc" ]]
    stateSave: true
    columnDefs: [
      { type: 'dateNonStandard', targets: 7 } ]
