define(['console', 'app/core/domain.config'], function (console, domainConfig) {
    "use strict";
    console.group("Entering validation message module");

    var directive =
       [ function () {
           return {
               restrict: 'A', // means it's a html attribute i.e. <span validation-message
               replace: false,
               link: function (scope, element, attrs) {
                   
                   var validationMessage = attrs["validationMessage"];
                   var messageFields = attrs["messageFields"];
                   if (messageFields)
                       messageFields = messageFields.split(',');

                   var message = domainConfig.messages.validation[validationMessage];
                   if (message) {
                       if (messageFields && messageFields.length > 0)
                           message = message.supplant(messageFields);

                       element[0].innerHTML = message;
                   }
               }
           };
       }];
    directive.directiveName = "validationMessage";

    console.groupEnd();
    return directive;
});
