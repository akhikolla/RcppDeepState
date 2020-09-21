log.error <- list(
  "<error>","\n\\s{2}",
  "<unique>",".*","</unique>\n\\s{2}",
  "<tid>",".*","</tid>\n\\s{2}",
  "<kind>",kind=".*","</kind>\n\\s{2}",
  "<what>",error=".*","</what>\n\\s{2}",
  "<stack>\n\\s*",stack="(?:.+\n)+","\\s*",
  "</error>\n")


trace <- list("<frame>\n\\s*","<ip>",".*","</ip>\n\\s*",
              "<obj>",".*","</obj>\n\\s*",
              "<fn>",".*","</fn>\n\\s*",
              "<dir>",".*","</dir>\n\\s*",
              "<file>",file="src.*","</file>\n\\s*",
              "<line>",line=".*","</line>\n\\s*","</frame>\n\\s*")



address.trace <- list("<auxwhat>",address=".*","</auxwhat>\n\\s*",
                      "<stack>\n\\s*",stack="(?:.+\n)+","\\s*",
                      "</stack>")



table <- nc::capture_all_str("/home/akhila/Desktop/valgrindlog",log.error)
t <- nc::capture_all_str("/home/akhila/Desktop/valgrindlog",trace)
t[, message.i := 1:.N]