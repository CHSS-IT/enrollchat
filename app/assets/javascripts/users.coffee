$(document).on 'turbolinks:load', ->
  table = $('#user-list').DataTable
    responsive: true
    fixedHeader: true
    order: [[ 1, "asc" ]]
    stateSave: true
    columnDefs: [
      { type: 'dateNonStandard', targets: 7 } ]

document.addEventListener 'turbolinks:load',  ->
  $(".selectpicker").selectpicker()

document.addEventListener 'turbolinks:before-cache',  ->
  $('.selectpicker').selectpicker('destroy').addClass('selectpicker')
