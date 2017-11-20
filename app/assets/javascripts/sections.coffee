$(document).ready ->
  $(".spinner").hide()

$(document).ready ->
  $("#update-form").on("ajax:beforeSend", (e, data, status, xhr) ->
    $('.spinner').show())
  $("#update-form").on("ajax:complete", (e, data, status, xhr) ->
    $('.spinner').hide())

$(document).on 'turbolinks:load', ->
  $('#filter-submit').click ->
    $(this).parents('form').submit()

$(document).ready ->
  $('#class-sections').DataTable
    responsive: true
    fixedHeader: true
    order: [[ 3, "asc" ]]
    columnDefs: [
      {
        responsivePriority: 1
        targets: [
          4
          15
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
        ]
      }
    ]
    stateSave: true
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