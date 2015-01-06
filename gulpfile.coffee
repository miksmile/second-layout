gulp = require 'gulp'
connect = require 'gulp-connect'
jade = require 'gulp-jade'
stylus = require 'gulp-stylus'
coffee = require 'gulp-coffee'
prettify = require 'gulp-prettify'
mainBowerFiles = require 'main-bower-files'

gulp.task 'images', ->
	gulp.src 'images/*'
		.pipe gulp.dest 'app/images'
		.pipe do connect.reload

gulp.task 'bower', ->
	gulp.src mainBowerFiles()
		.pipe gulp.dest 'app/bower'

gulp.task 'connect', ->
	connect.server
		port: 1337
		livereload: on
		root: 'app'

gulp.task 'jade', ->
	gulp.src 'jade/*.jade'
		.pipe do jade
		.pipe prettify {indent_size: 2}
		.pipe gulp.dest 'app'
		.pipe do connect.reload

gulp.task 'stylus', ->
	gulp.src 'stylus/*.styl'
		.pipe do stylus
		.pipe gulp.dest 'app/css'
		.pipe do connect.reload

gulp.task 'coffee', ->
	gulp.src 'coffee/*.coffee'
		.pipe do coffee
		.pipe gulp.dest 'app/js'
		.pipe do connect.reload

gulp.task 'watch', ->
	gulp.watch 'jade/*.jade', ['jade']
	gulp.watch 'stylus/*.styl', ['stylus']
	gulp.watch 'coffee/*.coffee', ['coffee']
	gulp.watch 'images/*', ['images']

gulp.task 'default', ['connect', 'watch', 'jade', 'stylus', 'coffee', 'bower', 'images']
