App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: 'BIS' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == 'BIS'
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: 'COMM' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == 'COMM'
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: 'CRIM' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == 'CRIM'
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: 'CULT' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == 'CULT'
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: 'ECON' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == 'ECON'
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: 'ENGL' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == 'ENGL'
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: 'HE' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == 'HE'
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: 'HIST' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == 'HIST'
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: 'HNRS' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == 'HNRS'
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: 'LA' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == 'LA'
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: 'MAIS' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == 'MAIS'
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: 'MCL' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == 'MCL'
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: 'PHIL' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == 'PHIL'
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: 'PSYC' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == 'PSYC'
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: 'RELI' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == 'RELI'
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: 'SINT' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == 'SINT'
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: 'SOAN' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == 'SOAN'
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);

App.department = App.cable.subscriptions.create { channel: "DepartmentChannel", room: 'WMST' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.department == 'WMST'
      $('#notifications').prepend data.message
      if $('#alerts-button').hasClass('unique-color-dark')
        $('#alerts-button').removeClass('unique-color-dark').addClass('rgba-lime-strong')
      $('button#alerts-button').effect("pulsate", {times:2}, 1000)
      dom_id = '#section_' + data.section_id + ' td a span.comment-count'
      $(dom_id).html(data.comment_count);
