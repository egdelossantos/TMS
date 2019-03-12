var requireConfig = {
    baseUrl: "<WEBSITE URL>/scripts/",
    paths: {
        app: "app",
        text: 'libs/require/text',
        console: 'libs/console/console-min',
        toastr: 'libs/toastr/toastr',
        jQuery: 'jquery-2.0.3.min',
        jQueryUi: 'jquery-ui-1.10.3',
        bootstrap: 'bootstrap.min',
        underscore: 'libs/underscore/underscore-full',
        amplify: 'libs/amplify-1.1.0/amplify',
        supplant: 'libs/supplant/supplant',
        angular: 'libs/angular/angular',
        angularRoutes: 'libs/angular/angular-route',
        infragisticsCore: 'libs/infragistics/infragistics.core',
        infragisticsLob: 'libs/infragistics/infragistics.lob'
    },
    shim: {
        'text': {},
        'console': { exports: 'console' },
        'underscore': { exports: '_' },
        'jQuery': { exports: '$' },
        'jQueryUi': { deps: ['jQuery'] },
        'toastr': { deps: ['jQuery'] },
        'angular': { exports: 'angular' },
        'angularRoutes': { deps: ['angular'] },//doesn't export anything. Just needs to be loaded, and have a dependency on angular
        'amplify': { deps: ['jQuery'], exports: 'amplify' },
        'bootstrap': { deps: ['jQuery'], exports: '$' }, // exports not really required.
        'supplant': { exports: 'String.prototype.supplant' },
        'infragisticsCore': { deps: ['jQuery', 'jQueryUi'] },
        'infragisticsLob': { deps: ['jQuery', 'jQueryUi', 'infragisticsCore'] }
    }
};