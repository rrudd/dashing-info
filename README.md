This projects intends to provide an easy to use web view for use in office info screens.

Check out http://shopify.github.com/dashing for more information on how to set up the project.

## Set up the necessary environment variables

As the application relies heavily on third party API:s, you will need to set your access tokens as environment variables. Below is a table of the needed variables. Expect this list to grow as the project matures.

Variable     | Description
-------------|------------
FORECAST_KEY | Key to the Dark Sky Forecast API. Get it [here](https://developer.forecast.io/).

## Using Travis

This application supports Travis CI deployment to Heroku. In order to make it work, you will need to set up environment variables `HEROKU_KEY` and `HEROKU_APP` with your Heroku API key and application name in your Travis settings.
