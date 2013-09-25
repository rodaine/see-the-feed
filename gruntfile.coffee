module.exports = (grunt) ->
	grunt.initConfig
		mochaUI:       'bdd'
		mochaReporter: 'dot'

		coffeeLib:    'src/lib/'
		coffeePublic: 'src/public/'

#------------------------------------------------------------------------------
# Coffeescript Compiling
#------------------------------------------------------------------------------

		coffee:
			options:
				bare: true

			lib:
				expand: true
				cwd: '<%= coffeeLib %>'
				src: ['**/*.coffee']
				dest: 'lib/'
				ext: '.js'


			public:
				expand: true
				cwd: '<%= coffeePublic %>'
				src: ['**/*.coffee']
				dest: '_public/scripts'
				ext: '.js'

#------------------------------------------------------------------------------
# Mocha (Server-Side) Testing
#------------------------------------------------------------------------------

		mochaTest:
			options: 
				globals: ['should']
				timeout: 3000
				ignoreLeaks: false
				growl: true
				ui: '<%= mochaUI %>'
				reporter: '<%= mochaReporter %>'
			lib:
				src: ['lib/tests/**/*.js']

#------------------------------------------------------------------------------
# Watch
#------------------------------------------------------------------------------

		watch:

			lib:
				files: ['<%= coffeeLib %>**/*.coffee']
				tasks: ['coffee:lib', 'mochaTest']

			public:
				files: ['<%= coffeePublic %>**/*.coffee']
				tasks: ['coffee:public']

#------------------------------------------------------------------------------
# Nodemon
#------------------------------------------------------------------------------				

		nodemon:
			dev: {}
	
#------------------------------------------------------------------------------
# Bootstrap
#------------------------------------------------------------------------------
	
	load = [
		#'grunt-contrib-connect'
		#'grunt-mocha'
		#'grunt-requirejs'
		#'grunt-text-replace'
		'grunt-contrib-coffee'
		'grunt-contrib-watch'
		'grunt-mocha-test'
		'grunt-nodemon'
	]

	register =
		default: ['coffee', 'mochaTest']
		test:    ['coffee', 'mochaTest']


	grunt.loadNpmTasks(task) for task in load
	grunt.registerTask(key, value) for key, value of register
