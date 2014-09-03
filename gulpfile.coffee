gulp = require "gulp"

require('./gulp/build')(gulp)
require('./gulp/livereload')(gulp)
require('./gulp/watch')(gulp)

gulp.task "default", ["build", "livereload:start", "watch"]