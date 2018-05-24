$(document).on 'turbolinks:load', ->
  table = $('#user-list').DataTable
    responsive: true
    fixedHeader: true
    order: [[ 1, "asc" ]]
    stateSave: true
