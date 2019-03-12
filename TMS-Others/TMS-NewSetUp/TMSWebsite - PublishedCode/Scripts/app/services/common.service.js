define(['console'
    , 'app/core/config'
    , 'app/core/angular.config'
], function (
    console
    , config
    , angularConfig
) {
    "use strict";

    var service = function ($http, $q) {

        var result = {};
        result.doGetRequestWithParamsAndReturnPromise = function (url, params) {
            var deferred = $q.defer();
            $http.get(url, { params: params }).success(function (data) {
                deferred.resolve(data);
            }).error(function (data, status) {
                deferred.reject(status);
            });

            var promise = deferred.promise;
            return promise;
        };

        result.doGetRequestAndReturnPromise = function (url) {
            var deferred = $q.defer();
            $http.get(url).success(function (data) {
                deferred.resolve(data);
            }).error(function (data, status) {
                deferred.reject(status);
            });

            var promise = deferred.promise;
            return promise;
        };

        result.doDeleteAndReturnPromise = function (url) {
            var deferred = $q.defer();
            $http.delete(url).success(function () {
                deferred.resolve();
            }).error(function () {
                deferred.reject();
            });
            var promise = deferred.promise;
            return promise;
        };

        result.doPostRequestAndReturnPromiseForData = function (url, postBody) {
            var deferred = $q.defer();
            $http.post(url, postBody).success(function (data) {
                deferred.resolve(data);
            }).error(function (data, status) {
                deferred.reject(status);
            });

            var promise = deferred.promise;
            return promise;
        };

        console.debug('commonService factory was called and an object was returned', result);
        return result;
    };

    service.serviceName = angularConfig.core.services.commonService;

    service.$inject = ['$http', '$q'];

    console.debug('api service created');
    return service;
});