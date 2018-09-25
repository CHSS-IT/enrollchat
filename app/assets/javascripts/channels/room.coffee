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
    if data.trigger == 'Refresh'
      dom_id = '#section_' + data.section_id + ' td .comment-hover'
      $(dom_id).attr('data-content', data.body);
      dom_id = '#section_' + data.section_id + ' td .comment-hover'
      $(dom_id).attr('data-title', 'New comment by ' + data.user);
      dom_id = '#section_' + data.section_id + ' td .comment-hover'
      $(dom_id).attr('data-original-title', 'New comment by ' + data.user);
    if data.trigger == 'Remove'
      if data.comment_count == 0
        dom_id = '#section_' + data.section_id + ' td #preview-comment'
        if $(dom_id).hasClass('fa fa-info-circle')
          $(dom_id).removeClass('fa fa-info-circle')
    if data.checkmark == true
      dom_id = '#section_' + data.section_id + ' td #resolved'
      $(dom_id).addClass('fa fa-check')
    if data.checkmark == false
      dom_id = '#section_' + data.section_id + ' td #resolved'
      $(dom_id).removeClass('fa fa-check')
