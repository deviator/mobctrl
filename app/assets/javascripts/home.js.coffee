# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@setUpDeviceEventTracer = () ->
  $ ->
    cli =
      id: 0
      orient: [0,0,0]
      motion: [0,0,0]
      posx: 0
      posy: 0
      slider: 0

    orient_buf = []
    motion_buf = []

    has_cli = false

    updateOrient = (x,y,z) -> orient_buf.push [x,y,z]
    updateMotion = (x,y,z) -> motion_buf.push [x,y,z]

    mean = (buf) ->
      if buf.length == 0
        return [0,0,0]
      r = [0,0,0]
      for v in buf
        for i in [0...3]
          r[i] += v[i]
      l = buf.length
      for i in [0...3]
        r[i] /= l
      return r

    if (window.DeviceOrientationEvent)
      window.addEventListener( "deviceorientation", () ->
        orient_buf.push [ event.beta, event.gamma, event.alpha ]
        has_cli = true
      , true )
    else
      window.addEventListener( "MozOrientation", () ->
        orient_buf.push [ orientation.x * 50, orientation.y * 50, orientation.z * 50 ]
        has_cli = true
      , true )
    if (window.DeviceMotionEvent)
      window.addEventListener( "devicemotion", () ->
        motion_buf.push [ event.acceleration.x * 2, event.acceleration.y * 2, event.acceleration.z * 2 ]
        has_cli = true
      , true )

    $("#slider-1").change ->
      cli.slider = this.value
      has_cli = true

    $("#slider-1").val(70)
    $("#slider-1").slider('refresh')

    doc_width = $( document ).width()
    doc_height = $( document ).height()
    client_min = Math.min( doc_width, doc_height )
    $( "#collorpick" ).width( client_min )
    $( "#collorpick" ).height( client_min )

    $( "#collorpick" ).on "vmousemove", (event) ->
      size = $( "#collorpick" ).height()
      x = event.pageX - this.offsetLeft
      y = event.pageY - this.offsetTop
      if( x > size || x < 0 || y > size || y < 0 )
        return
      cli.posx = 2 * ( x - size / 2.0 ) / size
      cli.posy = 2 * ( y - size / 2.0 ) / size
      console.log( cli.posx )
      console.log( cli.posy )

    clidata = ->
      cli.orient = mean orient_buf
      cli.motion = mean motion_buf
      orient_buf = [cli.orient]
      motion_buf = [cli.motion]
      return mobclient: cli

    setInterval ->
      if has_cli
        $.post '/paramdata', data: clidata()
        has_cli = false
    ,10
