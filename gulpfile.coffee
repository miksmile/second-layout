gulp = require 'gulp'
connect = require 'gulp-connect'
jade = require 'gulp-jade'
stylus = require 'gulp-stylus'
coffee = require 'gulp-coffee'
prettify = require 'gulp-prettify'
uglify = require 'gulp-uglify'
minifycss = require 'gulp-minify-css'
rename = require 'gulp-rename'
filter = require 'gulp-filter'
bowerFiles = require 'main-bower-files'
plumber = require 'gulp-plumber'

gulp.task 'bower', ->
	jsFilter = filter '*.js'
	cssFilter = filter '*.css'
	fontFilter = filter ['*.eot', '*.woff', '*.svg', '*.ttf']
	gulp.src do bowerFiles
# grab vendor js files from bower_components, minify and push in /app
		.pipe jsFilter
		.pipe gulp.dest './app/vendor/js'
		.pipe do uglify
		.pipe rename {suffix: '.min'}
		.pipe gulp.dest './app/vendor/js'
		.pipe do jsFilter.restore
# grab vendor css files from bower_components, minify and push in /app
		.pipe cssFilter
		.pipe gulp.dest './app/vendor/css'
		.pipe do minifycss
		.pipe rename {suffix: '.min'}
		.pipe gulp.dest './app/vendor/css'
		.pipe do cssFilter.restore
# grab vendor font files from bower_components and push in /app
		.pipe fontFilter
		.pipe gulp.dest './app/vendor/fonts'

gulp.task 'images', ->
	gulp.src './images/*'
		.pipe gulp.dest './app/images'
		.pipe do connect.reload

gulp.task 'connect', ->
	connect.server
		port: 1337
		livereload: on
		root: './app'

gulp.task 'jade', ->
	gulp.src './jade/*.jade'
		.pipe do plumber
		.pipe do jade
		.pipe prettify
			indent_size: 1
			indent_char: '\t'
		.pipe gulp.dest './app'
		.pipe do connect.reload

gulp.task 'stylus', ->
	gulp.src './stylus/*.styl'
		.pipe do plumber
		.pipe do stylus
		.pipe gulp.dest './app/css'
		.pipe do minifycss
		.pipe rename {suffix: '.min'}
		.pipe gulp.dest './app/css'
		.pipe do connect.reload

gulp.task 'coffee', ->
	gulp.src './coffee/*.coffee'
		.pipe do plumber
		.pipe do coffee
		.pipe gulp.dest './app/js'
		.pipe do uglify
		.pipe rename {suffix: '.min'}
		.pipe gulp.dest './app/js'
		.pipe do connect.reload

gulp.task 'watch', ->
	gulp.watch './jade/*.jade', ['jade']
	gulp.watch './stylus/*.styl', ['stylus']
	gulp.watch './coffee/*.coffee', ['coffee']
	gulp.watch './images/*', ['images']

gulp.task 'default', ['connect', 'watch', 'jade', 'stylus', 'coffee', 'images']
