var ajaxHelper = function () {
    var loadingElement = $("#loadingcontainer");
    var errorElement = $("#errorContainer");

    var ajaxGet = function (params) {
        loadingElement.show();
        errorElement.hide();
        var url = params.url;

        if (params.getParams) {
            url = url + "?" + $.param(params.getParams);
        }

        $.ajax(url, {
            success: function (d) {
                loadingElement.hide();
                params.success(d);
            },
            error: function (errorType, e) {
                loadingElement.hide();
                errorElement.show();
                if (window.console && window.console.log) {
                    window.console.log(e);
                }
            },
            cache: false,
        });
    };

    var ajaxJsonPost = function (params) {
        loadingElement.show();
        errorElement.hide();

        $.ajax({
            type: 'POST',
            url: params.url,
            data: params.data,
            contentType: 'application/json; charset=utf-8',
        }).done(function (d) {
            loadingElement.hide();
            params.success(d);
        }).fail(function (r, s, e) {
            loadingElement.hide();
            errorElement.show();
            if (window.console && window.console.log) {
                window.console.log(e);
            }
        });
    };

    return {
        ajaxGet: ajaxGet,
        ajaxJsonPost: ajaxJsonPost
    };
}();