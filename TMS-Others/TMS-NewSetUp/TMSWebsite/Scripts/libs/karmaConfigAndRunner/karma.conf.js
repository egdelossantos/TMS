module.exports = function(config){
  config.set({
    basePath : '../../',

    files : [
      'Libs/angular/angular.js',
      'Libs/angular/angular-*.js',
      'app/**/*.js',
      'tests/unit/**/*.js',
      'app/app.js'
    ],

    exclude : [
      'Libs/angular/angular-loader.js',
      'Libs/angular/*.min.js',
      'Libs/angular/angular-scenario.js'
    ],

    autoWatch : true,

    frameworks: ['jasmine'],

    browsers : ['Chrome'],

    plugins : [
            'karma-teamcity-reporter',
            //'karma-junit-reporter', // stops complaints: [Cannot find plugin "karma-junit-reporter". Did you forget to install it ?]
            'karma-chrome-launcher',
            'karma-firefox-launcher',
            'karma-script-launcher',
            'karma-jasmine'
            ],

    junitReporter : {
      outputFile: 'test_out/unit.xml',
      suite: 'unit'
    }
  });
};
