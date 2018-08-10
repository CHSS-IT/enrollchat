App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.trigger == 'Updated'
      location.reload()
    dom_id = '#section_' + data.section_id + ' td a span.comment-count'
    $(dom_id).html(data.comment_count);
    dom_id = '#section_' + data.section_id + ' td #resolved'
    if data.checkmark == true
      $('#resolved').addClass('fa fa-check')
    if data.checkmark == false
      $('#resolved').removeClass('fa fa-check')
