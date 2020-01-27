const gulp = require("gulp");
const pegjs = require("gulp-pegjs");

const compilePegjs = () =>
  gulp.src("./src/peg/*.pegjs")
    .pipe(pegjs())
    .pipe(gulp.dest("dist"));

const watchPegjs = () =>
  gulp.watch("./src/peg/*.pegjs", compilePegjs);

exports.default = watchPegjs;
