departments = ["BIS", "COMM", "CRIM", "CULT", "ECON", "ENGL", "HE", "HIST", "HNRS", "LA", "MAIS", "MCL", "PHIL", "PSYC", "RELI", "SINT", "SOAN", "WMST"]

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: departments[0] },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == departments[0]
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: departments[1] },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == departments[1]
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: departments[2] },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == departments[2]
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: departments[3] },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == departments[3]
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: departments[4] },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == departments[4]
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: departments[5] },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == departments[5]
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: departments[6] },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == departments[6]
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: departments[7] },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == departments[7]
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: departments[8] },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == departments[8]
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: departments[9] },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == departments[9]
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: departments[10] },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == departments[10]
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: departments[11] },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == departments[11]
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: departments[12] },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == departments[12]
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: departments[13]},
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == departments[13]
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: departments[14] },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == departments[14]
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: departments[15] },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == departments[15]
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: departments[16] },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == departments[16]
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: departments[17] },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == departments[17]
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);
