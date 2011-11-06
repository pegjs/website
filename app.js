var express = require("express");

var app = express.createServer();

/* Configuration */

app.configure(function(){
  app.set("views", __dirname + "/views");
  app.set("view engine", "ejs");
  app.use(express.logger());
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + "/public"));
});

app.configure("development", function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure("production", function(){
  app.use(express.errorHandler());
});

/* Helpers */

app.dynamicHelpers({
  req: function(req, res) { return req; }
});

app.helpers({
  menuItem: function(req, id, title) {
    return "<a"
      + (req.path === "/" + id ? " class=\"current\"" : "")
      + " href=\"/" + id + "\">"
      + title
      + "</a>";
  }
});

/* Routes */

app.get("/", function(req, res) {
  res.render("index", { title: "" });
});

app.get("/online", function(req, res) {
  res.render("online", { title: "Online version", layout: "layout-online" });
});

app.get("/documentation", function(req, res) {
  res.render("documentation", { title: "Documentation" });
});

app.get("/development", function(req, res) {
  res.render("development", { title: "Development" });
});

app.get("/download", function(req, res) {
  res.redirect("/#download", 301);
});

/* Export */

module.exports = app;
