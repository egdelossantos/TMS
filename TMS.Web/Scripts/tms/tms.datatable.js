var tmsDatatable = function () {
    var checkboxTemplate;
    var fullButtonTemplate;
    var editButtonTemplate;

    var renderCheckbox = function (data) {
        var labelClass = data ? "checked" : "";
        return checkboxTemplate.replace(/\$labelClass\$/gi, labelClass);
    };

    var renderFullButtons = function (data) {
        return fullButtonTemplate.replace(/\$id\$/gi, data);
    };

    var renderEditButtons = function (data) {
        return editButtonTemplate.replace(/\$id\$/gi, data);
    };

    var init = function (options) {
        $(options.elementId).dataTable({
            bJQueryUI: true,
            bProcessing: true,
            sPaginationType: "full_numbers",
            aLengthMenu: [[15, 25, 50, 100], [15, 25, 50, 100]],
            iDisplayLength: 15,
            sAjaxSource: options.ajaxSource,
            sAjaxDataProp: options.ajaxProperty,
            aoColumns: options.columns
        });

        checkboxTemplate = $("#checkboxTemplate").html();
        fullButtonTemplate = $("#fullButtonTemplate").html();
        editButtonTemplate = $("#editButtonTemplate").html();

        $(options.elementId + "_filter input").focus();
    };

    return {
        init: init,
        renderCheckbox: renderCheckbox,
        renderEditButton: renderEditButtons,
        renderFullButtons: renderFullButtons,
    };
}();
