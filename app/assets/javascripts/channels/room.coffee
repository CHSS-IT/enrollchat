App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $('#notifications').prepend '<a class="dropdown-item" data-toggle="modal" data-target="#comments" data-remote="true" href="/sections/' + data.section_id + '/comments">New comment on ' + data.section_name + ' by ' + data.user + '.</a>'
    if data.section_name == 'Data Updated'
      location.reload()
