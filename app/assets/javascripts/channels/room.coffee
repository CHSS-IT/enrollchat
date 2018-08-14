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
    dom_id = '#section_' + data.section_id + ' td #preview-eye'
    if data.comment_count == 0
      if $(dom_id).hasClass('fa fa-eye')
        $(dom_id).removeClass('fa fa-eye')
    dom_id = '#section_' + data.section_id + ' td #resolved'
    if data.checkmark == true
      $(dom_id).addClass('fa fa-check')
    if data.checkmark == false
      $(dom_id).removeClass('fa fa-check')
