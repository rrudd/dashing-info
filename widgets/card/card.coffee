class Dashing.Card extends Dashing.Widget

  ready: ->
    card_url = 'https://hall-of-boids.herokuapp.com/widget/1?speed=15';
    example_url = 'https://example.com';
    console.log("Tile ready", @node);
    $(@node).find(".iframe").attr('src', card_url)
