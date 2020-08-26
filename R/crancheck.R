crancheck<-function(){
pkg.name.vec <- dir("/home/akhila/Documents/checks/packages")
dir.create("/home/akhila/Documents/checks", showWarnings=FALSE)
pkg.check.vec <- file.path("/home/akhila/Documents/checks/files", sub("_.*", "",basename(pkg.name.vec)))
for(pkg.i in seq_along(pkg.name.vec)){
  pkg.name <- sub("_.*", "",basename(pkg.name.vec[[pkg.i]]))
  cat(sprintf("%4d / %4d %s\n", pkg.i, length(new.i.vec), pkg.name))
  u <- paste0(
    "https://cloud.r-project.org/web/checks/check_results_",
    pkg.name,
    ".html")
  pkg.check <- pkg.check.vec[[pkg.i]]
  download.file(u, pkg.check)
}

memtests.pattern <- list(
  "<a href=\"https://www.stats.ox.ac.uk/pub/bdr/memtests/",
  type=".*?",
  "/")

issues.pattern <- list(
  '<h3><a href="check_issue_kinds.html">Additional issues</a></h3>\n<p>',
  issues="(?:.*\n)*?",
  "</p>")

link.pattern <- list(
  '<a href="',
  href=".*?",
  '"><span class="check_ko">',
  type=".*?",
  "</span></a>")

check.file.vec <- Sys.glob("/home/akhila/Documents/checks/files/*")
type.dt.list <- list()
issue.dt.list <- list()
for(pkg.i in seq_along(check.file.vec)){
  check.file <- check.file.vec[[pkg.i]]
  pkg <- basename(check.file)
  cat(sprintf("\n%4d / %4d pkg=%s\n", pkg.i, length(check.file.vec), pkg))
  memtests.types <- nc::capture_all_str(check.file, memtests.pattern)
  if(nrow(memtests.types)){
    type.dt.list[[pkg]] <- data.table(
      pkg, memtests.types)
  }
  issue.row <- nc::capture_all_str(check.file, issues.pattern)
  if(nrow(issue.row)){
    pkg.issues <- nc::capture_all_str(issue.row$issues, link.pattern)
    issue.dt.list[[pkg]] <- data.table(
      pkg, pkg.issues)
  }
}
issue.dt <- do.call(rbind, issue.dt.list)
unique(issue.dt$pkg)


for(issue.i in seq_along(issue.dt)){
  cran.issue <- file.path("/home/akhila/Documents/checks/CRANIssue",issue.dt$pkg[[issue.i]])
  download.file(issue.dt$href[[issue.i]], cran.issue)
}

  
}