$(document).ready(function() {
  var parser;
  var grammarEditor      = null;
  var inputEditor        = null;
  var outputEditor       = null;
  var buildAndParseTimer = null;
  var parseTimer         = null;

  function writeOutput(text) {
    outputEditor.setValue(text);
  }

  function buildErrorMessage(e, cm) {
    if (e.line !== undefined && e.column !== undefined) {
      //cm.setCursor({line: e.line, ch: e.column});
      //cm.focus();
      return e.line + ":" + e.column + " " + e.message;
    } else {
      return e.message;
    }
  }

  function build() {
    writeOutput("Building...");
    try {
      parser = PEG.buildParser(grammarEditor.getValue(), {
        cache: false, trackLineAndColumn: true
      });
      var parserUrl = "data:text/plain;charset=utf-8;base64," + Base64.encode("module.exports = " + parser.toSource() + ";\n");
      $("#parser-download").attr("href", parserUrl);
     return true;
    } catch (e) {
      writeOutput(buildErrorMessage(e, grammarEditor));
      $("#parser-download").attr("href", "#");
      return false;
    }
  }

  function parse() {
    writeOutput("Parsing the input...");
    try {
      var output = parser.parse(inputEditor.getValue());
      writeOutput(jsDump.parse(output));
      return true;
    } catch (e) {
      writeOutput(buildErrorMessage(e, inputEditor));
      return false;
    }
  }
  
  function buildAndParse() {
    build() && parse();
  }

  function scheduleBuildAndParse() {
    if (buildAndParseTimer !== null) {
      clearTimeout(buildAndParseTimer);
      buildAndParseTimer = null;
    }
    if (parseTimer !== null) {
      clearTimeout(parseTimer);
      parseTimer = null;
    }
    buildAndParseTimer = setTimeout(function() {
      buildAndParse();
      buildAndParseTimer = null;
    }, 500);
  }

  function scheduleParse() {
    if (buildAndParseTimer !== null)
      return;
    if (parseTimer !== null) {
      clearTimeout(parseTimer);
      parseTimer = null;
    }
    parseTimer = setTimeout(function() {
      parse();
      parseTimer = null;
    }, 500);
  }

  $("#loader").hide();
  $("#content").show();

  $('#columns').split({
    orientation: 'vertical',
    limit: 330,
    position: $(window).width() * 3 / 5
  });

  $('#rows').split({
    orientation: 'horizontal',
    limit: 100,
    position: "50%"
  });

  grammarEditor = CodeMirror.fromTextArea(document.getElementById("grammar"), {
    mode: {name: "pegjs"},
    lineNumbers: true
  });
  grammarEditor.setSize(null, "100%");
  grammarEditor.on("change", function () {
    scheduleBuildAndParse();
  });

  inputEditor = CodeMirror.fromTextArea(document.getElementById("input"), {
    lineNumbers: true
  });
  inputEditor.setSize(null, "100%");
  inputEditor.on("change", function () {
    scheduleParse();
  });
  
  outputEditor = CodeMirror.fromTextArea(document.getElementById("output"), {
    lineNumbers: true,
    readOnly: true
  });
  outputEditor.setSize(null, "100%");

  grammarEditor.focus();

  buildAndParse();

});
