parse.details <- nc::capture_all_str(
  "/home/akhila/example_parse",
  "Package name : " ,
  package=".*",
  list="(?:.*\n)*?",
  "list ends"
)
fileConn<-file("/home/akhila/data_file")
for (row in 1:nrow(parse.details)) {
  dput(parse.details[row,"package"],"/home/akhila/data_file")
  dput(parse.details[row, "list"],"/home/akhila/data_file")
}    

gsub("list ends(?:.*\n)*Package name : ", "", "/home/akhila/example_parse")
lines <- readLines("/home/akhila/example_parse")

#qdapRegex::ex_between(lines,"Package name : ","list ends")