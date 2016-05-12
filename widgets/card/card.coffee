class Dashing.Card extends Dashing.Widget

  ready: ->
    console.log("Tile ready", @node);
    $(@node).find(".iframe").attr('src', 'http://example.com')
