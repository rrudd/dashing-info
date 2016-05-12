class Dashing.Card extends Dashing.Widget

  ready: ->
    console.log("Tile ready", @node);
    $(@node).find(".iframe").attr('src', 'https://hall-of-boids.herokuapp.com/widget/1?speed=15')
