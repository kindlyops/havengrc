const fs = require('fs')
const sass = require('node-sass')
console.log('Building CSS...')
sass.render({
  file: 'custom.scss'

}, function (err, result) {
  if (err) {
    console.error(err)
  } else {
    console.log('Writing CSS Output...')
    fs.writeFileSync('public/css/custom.css', result.css)
    console.log('Done')
  }
})
