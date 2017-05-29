class Dashing.Vote extends Dashing.Widget

  ready: ->
    vote_url = 'http://democrazy.herokuapp.com/#/results';
    example_url = 'https://example.com';
    console.log("Tile ready", @node);
    $(@node).find("#vote-frame").attr('src', vote_url)
