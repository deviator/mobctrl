# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@setUpDeviceEventTracer = () ->
  $ ->
    if (window.DeviceOrientationEvent)
      window.addEventListener( "deviceorientation", () ->
        orientReact( event.beta, event.gamma, event.alpha )
      , true )
    else
      window.addEventListener( "MozOrientation", () ->
        orientReact( orientation.x * 50, orientation.y * 50, orientation.z * 50 )
      , true )
    if (window.DeviceMotionEvent)
      window.addEventListener( "devicemotion", () ->
        motionReact( event.acceleration.x * 2, event.acceleration.y * 2, event.acceleration.z * 2 )
      , true )

@orientReact = (x,y,z) ->
  $("#orient-print").html( "<p>" + x + "</p><p>" + y + "</p><p>" + z + "</p>" )
  pushParams 'orient': [x,y,z]

@motionReact = (x,y,z) ->
  $("#motion-print").html( "<p>" + x + "</p><p>" + y + "</p><p>" + z + "</p>" )
  pushParams 'motion': [x,y,z]

@pushParams = (d) ->
  $.post '/paramdata', data: d
