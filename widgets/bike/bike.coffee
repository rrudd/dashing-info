class Dashing.Bike extends Dashing.Widget

  @accessor 'updatedAtMessage', ->
  if updatedAt = @get('updatedAt')
    timestamp = new Date(updatedAt * 1000)
    hours = timestamp.getHours()
    minutes = ("0" + timestamp.getMinutes()).slice(-2)
    "#{hours}:#{minutes}"

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.