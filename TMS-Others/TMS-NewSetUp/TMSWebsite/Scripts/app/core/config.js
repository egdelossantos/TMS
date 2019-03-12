define(['amplify'], function (amplify) {

    var virtualPath = '';
    var baseUri = 'api';
    // amplify store expiry time
    var storeExpirationMs = (1000 * 60 * 60 * 24); // 1 day
    // for server set expiry times
    var getCacheExpiryTime = function (severUtcDate) {
        var now = moment();
        var expires = moment(severUtcDate);
        var diff = expires.diff(now);
        return diff;
    };

    // FAILED xhr requests.. and login
    var _requests = [];
    // this is for successful requests are popped off the stack
    var removeItemFromRequests = function (key) {
        _.each(_requests, function (item) {
            if (item && item.key && item.key === key)
                _requests.splice(_requests.indexOf(item), 1);
        });

    };

    var addRequestToReplayQueue = function (request) {
        //todo: add logic around adding requests to be replayed. 
        // could be stack of last 10 - pop off first when exceeding 10...
        // or keep for 10 minutes (may cause issues with disconnected states)
        // or simply compare the request to make sure no identical requests exist 
        _requests.push(request);

    };

    var getFailedRequestsForReplay = function () {
        // todo: can apply logic here for timeouts if desired. filter the list before returning, 
        var ret = _requests.slice();
        _requests = [];
        return ret;
    };


    var authorizationKey = "";
    var authorizationStorageKey = "auth.key";
    var authorizationPrefix = "Bearer ";

    var hasAuthorizationKey = function () {
        //safety check
        if (authorizationKey.length == 0) {
            // check the store...
            var key = amplify.store(authorizationStorageKey);
            if (key && key.length > 0) {
                authorizationKey = key;
            }
        }

        return authorizationKey.length > 0;
    };

    var setAuthorizationKey = function (tokenResponse) {
        if (tokenResponse && tokenResponse.AccessToken) {
            var cacheExpiry = getCacheExpiryTime(tokenResponse.Expires);
            authorizationKey = authorizationPrefix + tokenResponse.AccessToken;
            amplify.store(authorizationStorageKey, authorizationKey, { expires: cacheExpiry });
        }
    };

    var getAuthorizationKey = function () {
        if (!hasAuthorizationKey()) {
            // check the store...
            var key = amplify.store(authorizationStorageKey);
            if (key && key.length > 0) {
                authorizationKey = key;
            }
        }
        return authorizationKey;
    };

    var clearAuthorizationKey = function () {
        if (hasAuthorizationKey) {
            authorizationKey = "";
            amplify.store(authorizationStorageKey, authorizationKey);
        }
    };


    // this is so i can call this from the ajaxSetup and set the elementID in the login directive
    var loginId = 'modalLogin';



    /** general config... **/
    var httpVerbs = {
        Get: "GET",
        Post: "POST",
        Put: "PUT",
        Delete: "DELETE"
    };

    /**  formats **/
    var formats = {
        dates: {
            shortDate: 'dd/mm/yy'
        }
    };

    

    return {
        loginId: loginId,
        removeItemFromRequests: removeItemFromRequests,
        addRequestToReplayQueue: addRequestToReplayQueue,
        getFailedRequestsForReplay: getFailedRequestsForReplay,
        hasAuthorizationKey: hasAuthorizationKey,
        setAuthorizationKey: setAuthorizationKey,
        getAuthorizationKey: getAuthorizationKey,
        clearAuthorizationKey: clearAuthorizationKey,
        storeExpirationMs: storeExpirationMs,
        formats: formats,
        httpVerbs: httpVerbs,
        getCacheExpiryTime: getCacheExpiryTime,
        virtualPath: virtualPath,
        baseUri: baseUri
    };
});
