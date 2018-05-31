$(document).ready ->
  $(".spinner").hide()

$(document).ready ->
  $("#update-form").on("submit", (e, data, status, xhr) ->
    $("#upload-sections").trigger('click'))
  $("#update-form").on("ajax:beforeSend", (e, data, status, xhr) ->
    $('.spinner').show())
  $("#update-form").on("ajax:complete", (e, data, status, xhr) ->
    $('.spinner').hide())

$(document).on 'turbolinks:load', ->
  $('#filter-submit').click ->
    $(this).parents('form').submit()

$(document).on 'turbolinks:load', ->
  $.fn.dataTable.moment( 'MMMM D, YYYY' );

  jQuery.extend jQuery.fn.dataTableExt.oSort,
    'dateNonStandard-asc': (a, b) ->
      x = Date.parse(a)
      y = Date.parse(b)
      if x == y
        return 0
      if isNaN(x) or x < y
        return 1
      if isNaN(y) or x > y
        return -1
      return
    'dateNonStandard-desc': (a, b) ->
      x = Date.parse(a)
      y = Date.parse(b)
      if x == y
        return 0
      if isNaN(y) or x < y
        return -1
      if isNaN(x) or x > y
        return 1
      return

  table = $('#class-sections').DataTable
    buttons: [ 'copy', 'excel', 'pdf' ]
    responsive: true
    fixedHeader: true
    order: [[ 3, "asc" ]]
    buttons: [ 'print', 'excel', 'pdf' ]
    columnDefs: [
      { type: 'dateNonStandard', targets: 15 }
      {
        responsivePriority: 1
        targets: [
          4
          16
        ]
      }
      {
        responsivePriority: 2
        targets: [ 0 ]
      }
      {
        responsivePriority: 3
        targets: [
          9
          10
          11
          12
          13
        ]
      }
    ]
    stateSave: true
  table.buttons().container().appendTo $('.col-md-6:eq(0)', table.table().container())


#  $('#class-sections').DataTable
#    responsive: true
#    fixedHeader: true
#    order: [[ 3, "asc" ]]
#    dom: 'Bfrtip'
#    buttons: [ 'print', 'excel', 'pdf' ]
#    columnDefs: [
#      { type: 'dateNonStandard', targets: 15 }
#      {
#        responsivePriority: 1
#        targets: [
#          4
#          16
#        ]
#      }
#      {
#        responsivePriority: 2
#        targets: [ 0 ]
#      }
#      {
#        responsivePriority: 3
#        targets: [
#          9
#          10
#          11
#          12
#          13
#        ]
#      }
#    ]
#    stateSave: true
  $('#upload-sections').on 'click', ->
    $(this).toggleClass 'unique-color grey'
    return
  $('#update-form').on 'submit', ->
    $('#upload-sections').attr 'class', 'btn unique-color'
    $('#uploadSupportedContent').addClass 'collapse'
    return
  $('input:file').change ->
    if $(this).val()
      $('button:submit').removeAttr 'disabled'
    return
  return
