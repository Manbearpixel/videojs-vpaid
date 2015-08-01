// Determine if passed variable is true
// -- used for grunt tasks
isTruth = function(check){
	return (check != undefined && (check == "true" || check == 1)  ) ? true : false;
};

module.exports = function (grunt) {
	
	grunt.initConfig({
    	pkg: grunt.file.readJSON('package.json'),
	  
		// CREATE LOCAL SERVER
		// -- REQUIRED TO PROPERLY TEST SWF
		connect: {
			dev: {
				port: 8000,
				base: '.'
			}
		},
	
		// BUILD VIDEOJS-VPAID.SWF FILE
		mxmlc: {
			options: {
				// http://livedocs.adobe.com/flex/3/html/help.html?content=compilers_16.html
				metadata: {
					// `-title "Adobe Flex Application"`
					title: 'VideoJS VPAID SWF',
					// `-description "http://www.adobe.com/flex"`
					description: 'https://github.com/Manbearpixel/video-js-vpaid-flash',
					// `-publisher "The Publisher"`
					publisher: 'Brightcove, Inc. | Manbearpixel',
					// `-creator "The Author"`
					creator: 'Brightcove, Inc. | Manbearpixel',
					// `-language=EN`
					// `-language+=klingon`
					language: 'EN',
					// `-localized-title "The Color" en-us -localized-title "The Colour" en-ca`
					localizedTitle: null,
					// `-localized-description "Standardized Color" en-us -localized-description "Standardised Colour" en-ca`
					localizedDescription: null,
					// `-contributor "Contributor #1" -contributor "Contributor #2"`
					contributor: null,
					// `-date "Mar 10, 2013"`
					date: null
				},

        		// http://livedocs.adobe.com/flex/3/html/help.html?content=compilers_18.html
        		application: {
					// `-default-size 240 240`
					layoutSize: {
						width: 640,
						height: 360
					},
					// `-default-frame-rate=24`
					frameRate: 30,
					// `-default-background-color=0x869CA7`
					backgroundColor: 0x000000,
					// `-default-script-limits 1000 60`
					scriptLimits: {
						maxRecursionDepth: 1000,
						maxExecutionTime: 60
					}
				},

				// http://livedocs.adobe.com/flex/3/html/help.html?content=compilers_19.html
				// `-library-path+=libraryPath1 -library-path+=libraryPath2`
				libraries: ['libs/*.*'],
				// http://livedocs.adobe.com/flex/3/html/help.html?content=compilers_14.html
				// http://livedocs.adobe.com/flex/3/html/help.html?content=compilers_17.html
				// http://livedocs.adobe.com/flex/3/html/help.html?content=compilers_20.html
				// http://livedocs.adobe.com/flex/3/html/help.html?content=compilers_21.html
				compiler: {
					// `-accessible=false`
					'accessible': false,
					// `-actionscript-file-encoding=UTF-8`
					'actionscriptFileEncoding': null,
					// `-allow-source-path-overlap=false`
					'allowSourcePathOverlap': false,
					// `-as3=true`
					'as3': true,
					// `-benchmark=true`
					'benchmark': true,
					// `-context-root context-path`
					'contextRoot': null,
					// `-debug=false`
					'debug': false,
					// `-defaults-css-files filePath1 ...`
					'defaultsCssFiles': [],
					// `-defaults-css-url http://example.com/main.css`
					'defaultsCssUrl': null,
					// `-define=CONFIG::debugging,true -define=CONFIG::release,false`
					// `-define+=CONFIG::bool2,false -define+=CONFIG::and1,"CONFIG::bool2 && false"
					// `-define+=NAMES::Company,"'Adobe Systems'"`
					'defines': {},
					// `-es=true -as3=false`
					'es': false,
					// `-externs className1 ...`
					'externs': [],
					// `-external-library-path+=pathElement`
					'externalLibraries': [],
					'fonts': {
						// `-fonts.advanced-anti-aliasing=false`
						advancedAntiAliasing: false,
						// `-fonts.languages.language-range "Alpha and Plus" "U+0041-U+007F,U+002B"`
						// USAGE:
						// ```
						// languages: [{
						//   lang: 'Alpha and Plus',
						//   range: ['U+0041-U+007F', 'U+002B']
						// }]
						// ```
						languages: [],
						// `-fonts.local-fonts-snapsnot filePath`
						localFontsSnapshot: null,
						// `-fonts.managers flash.fonts.JREFontManager flash.fonts.BatikFontManager flash.fonts.AFEFontManager`
						// NOTE: FontManager preference is in REVERSE order (prefers LAST array item).
						//       For more info, see http://livedocs.adobe.com/flex/3/html/help.html?content=fonts_06.html
						managers: []
					},
					// `-incremental=false`
					'incremental': false
				}
			},
			'vpaid-swf': {
				files: {
					'dist/videojs-vpaid.swf': ['src/VideoJS.as']
				}
			}
		},
	
		coffee: {
			'vpaid-lib': {
				options: {
					bare: true
				},
				expand: true,
				flatten: true,
				cwd: 'lib/',
				src: ['*.coffee'],
				dest: 'lib/',
				rename: function(dest, src) {
					return dest + src.replace('.coffee', '.js');
				}
			}
		},
		
		copy: {
			'vpaid-lib': {
				files: [
					{
						expand: true,
						cwd: 'lib/',
						src: ['*.js', '*.css'],
						dest: 'dist/'
					}
				]
			}
		},

		bumpup: {
			options: {
				updateProps: {
					pkg: 'package.json'
				}
			},
			file: 'package.json'
		},
	
		tagrelease: {
			file: 'package.json',
			commit:  true,
			message: 'Release %version%',
			prefix:  'v'
		},
	
		shell: {
			options: {
				failOnError: true
			},
			'git-diff-exit-code': { command: 'git diff --exit-code' },
			'git-diff-cached-exit-code': { command: 'git diff --cached --exit-code' },
			'git-add-dist-force': { command: 'git add dist --force' },
			'git-merge-stable': { command: 'git merge stable' },
			'git-merge-master': { command: 'git merge master' },
			'git-checkout-stable': { command: 'git checkout stable' },
			'git-checkout-master': { command: 'git checkout master' },
			'git-push-stable': { command: 'git push origin stable' },
			'git-push-master': { command: 'git push origin master' },
			'git-push-tags': { command: 'git push --tags' }
		},

		'prompt': {
			release: {
				options: {
					questions: [
						{
							config: 'release', // arbitray name or config for any other grunt task
							type: 'confirm', // list, checkbox, confirm, input, password
							message: 'You tested and merged the changes into stable?',
							default: false, // default value if nothing is entered
							// choices: 'Array|function(answers)',
							//
							// validate: function(value){ 
							//				console.log('hi', value); 
							//				grunt.fatal('test'); return "error"; }, 
							// return true if valid, error message if invalid
							//
							// filter:  function(value), // modify the answer
							//
							// when: function(answers) // only ask this question when this function returns true
						}
					]
				}
			}
		}
	});

	grunt.loadNpmTasks('grunt-contrib-copy');
	grunt.loadNpmTasks('grunt-contrib-coffee');
	grunt.loadNpmTasks('grunt-connect');
	grunt.loadNpmTasks('grunt-bumpup');
	grunt.loadNpmTasks('grunt-tagrelease');
	grunt.loadNpmTasks('grunt-npm');
	grunt.loadNpmTasks('grunt-shell');
	grunt.loadNpmTasks('grunt-prompt');
	grunt.loadNpmTasks('chg');
  
	// compiles .coffee to .js
	// -- if passed param is "TRUE" (true||1) it will also copy the compiled JS file to /dist/
	grunt.registerTask('build-lib', 'Compiles VPAID Flash Plugin library .coffee files into .js files. Optionally copies compiled files to /dist/', function(runDist){
	    runDist = isTruth(runDist);

	    grunt.log.writeln("\n--------------------\n:// COMPILING LIBRARY FILES");
	    grunt.task.run([
	        'coffee:vpaid-lib'
	    ]);

	    if(runDist) {
	        grunt.log.writeln("\n--------------------\n:// MOVING LIBRARY FILES");
	        grunt.task.run([
	            'copy:vpaid-lib'
	        ]);
	    }
	});
	
	// compiles videojs-vpaid.swf file from /src/swf/* and places it into /dist/
	grunt.registerTask('build-swf', 'Compiles VPAID Flash Plugin SWF into /dist/ folder', function(){
	    grunt.log.writeln("\n--------------------\n:// COMPILING SWF");
	    grunt.task.run([
	        'mxmlc:vpaid-swf'
	    ]);
	});
	
	// executes both build-lib AND build-swf, also moves compiled lib files into /dist/
	grunt.registerTask('dist', 'Compiles VPAID Flash Plugin SWF AND Library files and places all assets into /dist/ folder', function(){
	    grunt.log.writeln("\n--------------------\n:// COMPILING PLUGIN");
	    grunt.task.run([
			'coffee:vpaid-lib',
			'copy:vpaid-lib',
	        'mxmlc:vpaid-swf'
	    ]);
	});
	
	// compiles swf
	grunt.registerMultiTask('mxmlc', 'Compiling SWF', function () {
		// Merge task-specific and/or target-specific options with these defaults.
		var childProcess = require('child_process');
		var flexSdk = require('flex-sdk');
		var async = require('async');
		var pkg = grunt.file.readJSON('package.json');

		var options = this.options,
		done = this.async(),
		maxConcurrency = 1,
		q,
		workerFn;

		workerFn = function(f, callback) {
			// Concat specified files.
			var srcList = f.src.filter(function(filepath) {
				// Warn on and remove invalid source files (if nonull was set).
				if (!grunt.file.exists(filepath)) {
					grunt.log.error('Source file "' + filepath + '" not found.');
					return false;
				}
				else {
					return true;
				}
			});

			var cmdLineOpts = [];

			if (f.dest) {
				cmdLineOpts.push('-output');
				cmdLineOpts.push(f.dest);
			}

			cmdLineOpts.push('-define=CONFIG::version, "' + pkg.version + '"');
			cmdLineOpts.push('--');
			cmdLineOpts.push.apply(cmdLineOpts, srcList);

			grunt.verbose.writeln('package version: ' + pkg.version);
			grunt.verbose.writeln('mxmlc path: ' + flexSdk.bin.mxmlc);
			grunt.verbose.writeln('options: ' + JSON.stringify(cmdLineOpts));

			// Compile!
			childProcess.execFile(flexSdk.bin.mxmlc, cmdLineOpts, function(err, stdout, stderr) {
				if (!err) {
					grunt.log.writeln('File "' + f.dest + '" created.');
				}
				else {
					grunt.log.error(err.toString());
					grunt.verbose.writeln('stdout: ' + stdout);
					grunt.verbose.writeln('stderr: ' + stderr);

					if (options.force === true) {
						grunt.log.warn('Should have failed but will continue because this task had the `force` option set to `true`.');
					}
					else {
						grunt.fail.warn('FAILED');
					}
				}
				callback(err);
			});
		};

		q = async.queue(workerFn, maxConcurrency);
		q.drain = done;
		q.push(this.files);
	});
};