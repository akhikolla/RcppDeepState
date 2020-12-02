d <- data.frame(tail=c(12,11,32,0),
                legs=c(4,4,4,2),
                height=c(31,35,62,68))

export.list <- list()
unexport.list <- list()


export.list <- c("accelerometry","BNSL","factorcpt","humaniformat",
                 "IntegratedMRF","jmotif","olctools","QuantTools",
                 "PAutilities","RcppDynProg","rhoR","TransPhylo")

names(export.list) <- c("accelerometry","BNSL","factorcpt","humaniformat",
                        "IntegratedMRF","jmotif","olctools","QuantTools",
                        "PAutilities","RcppDynProg","rhoR","TransPhylo")

unexport.list <- c("abcADM","accelerometry","adeba","AGread","alphabetr","ambient","amt","anytime",
                   "aphid","aricode","autothresholdr","backbone","BalancedSampling","BAMBI","BoostMLR",
                   "bsearchtools","bsplinePsd","CARBayes","carSurv","castor",
                   "CatReg","ClinicalTrialSummary","cgAUC","clogitboost","clogitL1","CMF",
                   "credsetmat","corrcoverage","cort","dslice","CPAT",
                   "dng","energy","equateMultiple","exceedProb","eseis","ESGtoolkit","expperm",
                   "factorcpt","fastAdaboost","fbroc","FastGP","ffstream","finity","flying","forecastSNSTS","grainscape","graphlayouts","HDLSSkST","hetGP","hierarchicalSets",
                   "highfrequency","humaniformat","humanleague","humaniformat","iCellR",
                   "icensmis","icRSF","immer","imagerExtra","IntegratedMRF","ipft",
                   "kcpRS","kmer","LassoNet","lsbclust","lutz","metacart","metadynminer3d",
                   "meteoland","minimaxdesign","mixR","mlr3proba","mobsim","ModelMetrics",
                   "mosum","mousetrap","multicool","MPBoost","NAM","NHMM","nmixgof","oce","offlineChange",
                   "olctools","OwenQ","padr","PanelCount","PanelMatch","particles","parzer",
                   "PAutilities","pcIRT","Phase12Compare","phylobase","pinbasic",
                   "PLMIX","PP","PPRL","ProjectionBasedClustering","propr","Qtools",
                   "quantregRanger","QuantTools","rankdist","RcppDynProg","RGeode",
                   "rhoR","RMPSH","RJafroc","robFitConGraph","robmixglm","robustSingleCell",
                   "rrecsys","Rrelperm","rres","rbscCI","RTransferEntropy","Rvoterdistance",
                   "segmenTier","signalHsmm","signnet","simPop","simstudy","SpatialEpi",
                   "SpecsVerification","Speedloop","stocks","surveysd","tagcloud",
                   "timma","tidyxl","TransPhylo","Umatrix","windfarmGA","wk","wkutils")

names(unexport.list) <-c("abcADM","accelerometry","adeba","AGread","alphabetr","ambient","amt","anytime",
                         "aphid","aricode","autothresholdr","backbone","BalancedSampling","BAMBI","BoostMLR",
                         "bsearchtools","bsplinePsd","CARBayes","carSurv","castor",
                         "CatReg","ClinicalTrialSummary","cgAUC","clogitboost","clogitL1","CMF",
                         "credsetmat","corrcoverage","cort","CPAT",
                         "dng","energy","equateMultiple","exceedProb","eseis","ESGtoolkit","expperm",
                         "factorcpt","fastAdaboost","fbroc","FastGP","ffstream","finity","flying","forecastSNSTS","grainscape","graphlayouts","HDLSSkST","hetGP","hierarchicalSets",
                         "highfrequency","humaniformat","humanleague","humaniformat","iCellR",
                         "icensmis","icRSF","immer","imagerExtra","IntegratedMRF","ipft",
                         "kcpRS","kmer","LassoNet","lsbclust","lutz","metacart","metadynminer3d",
                         "meteoland","minimaxdesign","mixR","mlr3proba","mobsim","ModelMetrics",
                         "mosum","mousetrap","multicool","MPBoost","NAM","NHMM","nmixgof","oce","offlineChange",
                         "olctools","OwenQ","padr","PanelCount","PanelMatch","particles","parzer",
                         "PAutilities","pcIRT","Phase12Compare","phylobase","pinbasic",
                         "PLMIX","PP","PPRL","ProjectionBasedClustering","propr","Qtools",
                         "quantregRanger","QuantTools","rankdist","RcppDynProg","RGeode",
                         "rhoR","RMPSH","RJafroc","robFitConGraph","robmixglm","robustSingleCell",
                         "rrecsys","Rrelperm","rres","rbscCI","RTransferEntropy","Rvoterdistance",
                         "segmenTier","signalHsmm","signnet","simPop","simstudy","SpatialEpi",
                         "SpecsVerification","Speedloop","stocks","surveysd","tagcloud",
                         "timma","tidyxl","TransPhylo","Umatrix","windfarmGA","wk","wkutils")

export.lis <- paste(sprintf('<li><a href="%s.html">%s</a></li>',gsub(" ", "_", names(export.list)),names(export.list)),collapse="\n")

unexport.lis <- paste(sprintf('<li><a href="%s.html">%s</a></li>',gsub(" ", "_", names(unexport.list)),names(unexport.list)),collapse="\n")
    
# list of packages with no testfiles
path <- "~/R/x86_64-pc-linux-gnu-library/3.6/RcppDeepState/extdata/issuestests"
packages <- Sys.glob(file.path(path,"*"))
notestfiles <- list()
for(pkg.i in packages){
  testpath <- file.path(pkg.i,"inst/testfiles")
  testfuns <- Sys.glob(file.path(testpath,"*"))
  if(length(testfuns) <= 0){
    notestfiles <- c(notestfiles,basename(pkg.i))
  }
}
binary.files.extract <- function(bin.files){
  binary.files <- if(length(grep("log_",bin.files,value=TRUE)) > 0){
    log.files <- grep("log_",bin.files,value=TRUE)
    sort(c(log.files[!log.files%in%bin.files],bin.files[!bin.files%in%log.files]))
  }  
}
log.files.extract <- function(bin.files){
  log.files <- list()
  for(log.i in bin.files){
    log.files <- if(length(grep("log_",basename(log.i))) > 0){
    c(log.files,log.i)
  }  
  }
  return(log.files)
}

PackageURL <- function(pkg){
  ahref(pkg, paste0("https://github.com/akhikolla/RcppDeepStateTest/tree/master/issuestests/", pkg))
}
ahref <- function(content, u){
  sprintf('<a href="%s">%s</a>', u, content)
}
getNamespaceExports_fun <- function(pkg.i){
funnamespace = readLines(file.path(pkg.i,"NAMESPACE"),warn = FALSE)
namespace.list <- nc::capture_all_str(funnamespace,
                                      status=".*",
                                      "\\(",
                                      fun=".*",
                                      "\\)")
export_list <- namespace.list[status == "export", fun]
return(export_list)
}

list.package.fun.issues <- function(packages){
  final.package.list <- list()
  package.funs.list <- list()
  major.template <- readLines("figure-common-major-template.html")
   url <- "https://github.com/akhikolla/RcppDeepStateTest/tree/master/issuestests"
for(pkg.i in packages){
  path <- system.file("issuestests", package = "RcppDeepStateTests")
  package.path <- file.path(path,basename(pkg.i))
  package.funs.list <- list()
  sprintf("Package name - %s\n",basename(pkg.i))
  testpath <- file.path(pkg.i,"inst/testfiles")
  testfuns <- Sys.glob(file.path(testpath,"*"))
  for(fun.i in testfuns){
    fun_name <- basename(fun.i)
    fun_output <- file.path(fun.i,paste0(fun_name,"_output"))
    sprintf("fun_name - %s\n\n",fun_name)
    log.files <- log.files.extract(Sys.glob(file.path(fun_output,"*")))
    flag = 0
    log.path = ""
    for(log.i in log.files){
      valgrind_log <- file.path(log.i,"valgrind_log")
      data.result <- RcppDeepState::deepstate_read_valgrind_xml(valgrind_log)
      if(!is.null(data.result) && nrow(data.result) > 0){
        flag = 1
        log.path = log.i
        result = data.result;
      }
    }
    if(flag == 1){
      inputs <- grep("*.qs",Sys.glob(file.path(log.path,"*")),value=TRUE)
      inputs.list<- list()
      for(input.i in inputs){
        inputs.list[[gsub("*.qs","",basename(input.i))]] <- paste0(url,"/",basename(pkg.i),"/inst/testfiles/",
                                                                   fun_name,"/inputs/",basename(input.i))
      }
      major.lis <- paste(
        sprintf(
          '<a href="%s">%s</a>',
          gsub(" ", "_", inputs.list),
          names(inputs.list)),
        collapse="\n")
      
      #print(major.lis)
      
       if(fun_name %in% getNamespaceExports_fun(pkg.i)){symbol <-"::"}else{symbol <-":::"}
      package.funs.list[[paste0(basename(pkg.i),"-",fun_name)]] <- data.table(name=paste0(basename(pkg.i),symbol,fun_name), 
                                                  inputs=major.lis,
                                                  message = result$message[1],
                                                  file.line =result$file.line[1])
      }else{
        if(fun_name %in% getNamespaceExports_fun(pkg.i)){symbol <-"::"}else{symbol <-":::"}
      package.funs.list[[fun_name]] <-data.table(name=paste0(basename(pkg.i),symbol,fun_name),inputs=character(), message=character(), file.line=character())
    }
  }
  #print("before")
  #print(package.funs.list)
  package.funs <- do.call(rbind, package.funs.list)
  xt <- xtable::xtable(package.funs)
  old.align <- xtable::align(xt)
  xtable::align(xt) <- rep("r", length(old.align))
  major.html <- print(
    xt,
    include.rownames=FALSE,
    type="html",
    sanitize.text.function=identity,
    file="/dev/null")
  major.under <- gsub(" ", "_", basename(pkg.i))
  major.under.html <- paste0(major.under, ".html")
  major.template.filled <- gsub("PACKAGE", PackageURL(basename(pkg.i)), major.template)
  cat(major.template.filled,
      gsub("<td", '<td valign="top"', major.html), 
      file=file.path("package-html-folders", major.under.html))
  #line.num.dt<-unique(line.num.dt, incomparables = FALSE)
  #print("after")
  #print(package.funs.list)
}
  #final.package.list[[pkg.i]] <- package.funs.list
   #print("final package list")
   #print(final.package.list)
  
}

