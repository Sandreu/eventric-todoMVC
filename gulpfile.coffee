gulp = require "gulp"

require('./gulp/scripts')(gulp)
require('./gulp/livereload')(gulp)
require('./gulp/watch')(gulp)

gulp.task "default", ["scripts", "livereload:start", "watch"]