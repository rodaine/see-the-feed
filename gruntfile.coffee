module.exports = (grunt) ->
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'
		
	load = [
		'grunt-contrib-coffee'
		'grunt-contrib-connect'
		'grunt-contrib-jasmine'
		'grunt-contrib-watch'
		'grunt-requirejs'
		'grunt-text-replace'
		'grunt-mocha'
		'grunt-mocha-test'
	]

	register =
		test: []
		default: []

	grunt.loadNpmTasks(task) for task in load
	grunt.registerTask(key, value) for key, value of register