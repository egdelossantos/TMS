actionBar = function() {
    var confirmAction = function(e) {
        if (e.isDirty && e.isDirty()) {
            return confirm("Your changes will not be saved. Continue?");
        }

        return true;
    };

    var saveExit = function() {
        var inputs = $('form input[type="submit"]:not(.icon)');
        if (inputs.length > 1) {
            inputs.each(function() {
                if ($(this).attr('id') == "btnsave") {
                    $('form input[name="saveAndExit"]').val('true');
                    $(this)[0].click();
                }
            });
        } else {
            inputs.click();
        }
    };

    var saveOnly = function() {
        var inputs = $('form input[type="submit"]:not(.icon)');
        if (inputs.length > 1) {
            inputs.each(function() {
                if ($(this).attr('id') == "btnsaveonly") {
                    $(this)[0].click();
                }
            });
        } else {
            inputs.click();
        }
    };

    var clear = function () {
        var inputs = $('form input[id="btnclear"]:not(.icon)');
        if (inputs.length > 1) {
            inputs.each(function () {
                if ($(this).attr('id') == "btnclear") {
                    $(this)[0].click();
                }
            });
        } else {
            inputs.click();
        }
    };

    return { confirmAction: confirmAction, saveExit: saveExit, saveOnly: saveOnly, clear: clear };
}();