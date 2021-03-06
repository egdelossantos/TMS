/* needs configuration */
module.exports = function (config) {
    config.set({


        basePath: '../../',

    files : [
        //'test/e2e/**/*.js'  // change below is because we are unconventional angular
        'tests/e2e/**/*.js'
    ],

    autoWatch : false,

    browsers : ['Chrome'],

    frameworks: ['ng-scenario'],

    singleRun : false,

    proxies : {
      '/': 'http://localhost:83/'
    },

    plugins: [
            'karma-teamcity-reporter',
            // 'karma-junit-reporter', // shut up [Cannot find plugin "karma-junit-reporter".]
            'karma-chrome-launcher',
            'karma-firefox-launcher',
            'karma-jasmine',
            'karma-ng-scenario'
            ],

    junitReporter : {
      outputFile: 'test_out/e2e.xml',
      suite: 'e2e'
    }

})}

