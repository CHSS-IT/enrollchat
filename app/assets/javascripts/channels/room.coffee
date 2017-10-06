App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $('#notifications').prepend '<div class="card"><div class="card-header">' +
        'New comment on ' + data.section_name + ' by ' + data.user + '.</div><div class="card-body">' + data.body + '</div>' + '</div>'
