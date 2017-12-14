App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $('#notifications').prepend data.message
    if data.trigger == 'Updated'
      location.reload()
    if $('#alerts-button').hasClass('unique-color-dark')
      $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
    $('button#alerts-button').effect("pulsate", {times:2}, 1000)
    dom_id = '#section_' + data.section_id + ' td a span.comment-count'
    $(dom_id).html(data.comment_count);
