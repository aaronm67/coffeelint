(function () {
    var editor;
    var configEditor;

    var buildReportTable = function (errors) {

        var table = $('<div class="error_report">');
        $.each(errors, function (index, error) {
            var row = $('<div></div>');
            var lc = $('<span class="lineNumber"></span>'
                                ).html("Line #" + error.lineNumber + ':');
            var rc = $('<span class="reason"></span>').html(error.message);
            row.append(lc, rc);
            table.append(row);
        });
        return table;
    };


    var update = function (title, status_, content) {
        $('.report .section_body').empty().append(content || "").show();
        $('.report .section_title').text(title);
        $('.report_row').removeClass('success failure').addClass(status_).slideDown();

    };

    var displayReport = function (errors) {

        var title = 'Your code is lint free!';
        var status_ = 'success';
        var body = '';

        if (errors.length != 0) {
            title = 'Your code has lint.';
            status_ = 'failure';
            body = buildReportTable(errors);
        }

        update(title, status_, body);
    };

    var displayError = function (error) {
        var body = $('<div class="error_report"></div>');
        body.append(error.toString());
        update('Your code has an error', 'failure', body);
    };

    var runLinter = function () {
        var source = editor.getValue();

        var configError = null;
        var config = { }
        try {
          config = JSON.parse(configEditor.getValue());
        }
        catch (e) {
          configError = 'Invalid JSON in configuration';
        }

        var errors = [];
        var compileError = null;
        try {
            errors = coffeelint.lint(source, config);
        } catch (e) {
            compileError = e;
        }
        if (compileError) {
            displayError(compileError);
        }
        else if (configError) {
            displayError(configError);
        }
        else {
            displayReport(errors);
        }
    };

    $(document).ready(function () {
        var $editor = $('.editor');
        var $config = $('.config-editor');

        editor = CodeMirror.fromTextArea($editor[0], {
            lineNumbers: true
        }, $editor.val());

        configEditor = CodeMirror.fromTextArea($config[0], {
            lineNumbers: true
        }, $config.val());

        $editor.focus().keyup(runLinter);
        $('.run').click(runLinter);
    });

})();
