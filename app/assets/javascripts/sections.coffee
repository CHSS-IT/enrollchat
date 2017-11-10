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
