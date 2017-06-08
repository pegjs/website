#!/usr/bin/env node

var bodyParser = require("body-parser"),
    express    = require("express"),
    layout     = require("express-layout"),
    logger     = require("morgan");

var app = express();

/* Configuration */

var PORT = process.env.OPENSHIFT_NODEJS_PORT || process.env.PORT || 3000;
var IP = process.env.OPENSHIFT_NODEJS_IP || "127.0.0.1";

app.set("views", __dirname + "/views");
app.set("view engine", "ejs");

app.use(logger("dev"));
app.use(express.static(__dirname + "/public"));

app.use(layout());
app.use(function(req, res, next) {
  res.locals.req = req;
  next();
});

/* Helpers */

app.locals.menuItem = function(req, id, title) {
    return "<a"
      + (req.path === "/" + id ? " class=\"current\"" : "")
      + " href=\"/" + id + "\">"
      + title
      + "</a>";
};

/* Routes */

app.get("/", function(req, res) {
  res.render("index", { title: "" });
});

app.get("/online", function(req, res) {
  res.render("online", { title: "Online version", layout: "layout-online" });
});

app.post("/online/download", bodyParser.urlencoded({ extended: false, limit: "1024kb" }), function(req, res) {
  res.set("Content-Type", "application/javascript");
  res.set("Content-Disposition", "attachment;filename=parser.js");
  res.send(req.body.source);
});

app.get("/documentation", function(req, res) {
  res.render("documentation", { title: "Documentation" });
});

app.get("/development", function(req, res) {
  res.render("development", { title: "Development" });
});

app.get("/download", function(req, res) {
  res.redirect(301, "/#download");
});

/* Main */

var server = app.listen(PORT, IP, function() {
  var host = server.address().address,
      port = server.address().port,
      env  = app.get("env");

  console.log(
    "PEG.js website running at http://%s:%d in %s mode...",
    host,
    port,
    env
  );
})
