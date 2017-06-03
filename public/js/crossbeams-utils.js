// General utility functions for Crossbeams.

var crossbeamsUtils = {

    // Toggle the visibility of en element in the DOM:
    // Optionally pass in a button to add the pure-button-active class (Pure.css)
    toggle_visibility: function (id, button) {
        var e = document.getElementById(id);

        if (e.style.display === "block") {
            e.style.display = "none";
            if (button !== undefined) {
                button.classList.remove("pure-button-active");
            }
        } else {
            e.style.display = "block";
            if (button !== undefined) {
                button.classList.add("pure-button-active");
            }
        }
    },

    getCharCodeFromEvent: function (event) {
        event = event || window.event;
        return (event.which === "undefined")
            ? event.keyCode
            : event.which;
    },

    isCharNumeric: function (charStr) {
      return !!(/\d/.test(charStr));
    },

    isKeyPressedNumeric: function (event) {
        var charCode = this.getCharCodeFromEvent(event);
        var charStr = String.fromCharCode(charCode);
        return this.isCharNumeric(charStr);
    },

    // Make a select tag using an array for the options.
    // The Array can be an Array of Arrays too.
    makeSelect: function (name, arr) {
        var sel = "<select id='" + name + "' name='" + name + "'>";
        arr.forEach(function (item) {
            if (item.constructor === Array) {
                sel += "<option value='" + (item[1] || item[0]) + "'>" + item[0] + "</option>";
            } else {
                sel += "<option value='" + item + "'>" + item + "</option>";
            }
        });
        sel += "</select>";
        return sel;
    },

    // Adds a parameter named "json_var" to a form
    // containing a stringified version of the passed object.
    addJSONVarToForm: function (formId, jsonVar) {
        var form = document.getElementById(formId);
        var element1 = document.createElement("input");
        element1.type = "hidden";
        element1.value = JSON.stringify(jsonVar);
        element1.name = "json_var";
        form.appendChild(element1);
    },

    // Return the index of an LI tag in a UL/OL list.
    getListIndex: function (node) {
        var childs = node.parentNode.childNodes;
        var i = 0;
        childs.forEach(function (child) {
            i += 1;
            if (node === child) {
                return;
            }
        });
        return i;
    }

};

