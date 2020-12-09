logfile <-"/home/akhila/Music/error"
inputs <- nc::capture_all_str(
  logfile,
  "input starts\n",
  inputs="(?:.*\n)*?",
  "input ends"
  )

inputs.values <- gsub("Missing value\n\n","",inputs$inputs[1])
inputs.values <- gsub("EXTERNAL: qs v0.23.4.\n","",inputs$inputs[1])

inputs.data <- nc::capture_all_str(inputs.values,
                                   argument=".*",
                                   " values: ",
                                   value=".*")
data.list <- list()
for(i in inputs.data){
  print(inputs.data[i]$argument)
  #data.list[i$argument] <-i$value
}
