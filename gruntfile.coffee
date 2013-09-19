module.exports = (grunt) ->
	grunt.initConfig
		pkg:           grunt.file.readJSON 'package.json'
		
	load = [
	]

	register =
		default: []

	grunt.loadNpmTasks(task) for task in load
	grunt.registerTask(key, value) for key, value of register