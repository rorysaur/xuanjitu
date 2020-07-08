const { environment } = require('@rails/webpacker')
const typescript =  require('./loaders/typescript')

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)

environment.loaders.prepend('typescript', typescript)
module.exports = environment
