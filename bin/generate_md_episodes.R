generate_md_episodes <- function() {

    library("methods")
    
    if (require("knitr") && packageVersion("knitr") < '1.9.19')
        stop("knitr must be version 1.9.20 or higher")

    if (!require("stringr"))
        stop("The package stringr is required for generating the lessons.")

    if (require("checkpoint") && packageVersion("checkpoint") >=  '0.4.0') {
        required_pkgs <-
             checkpoint:::scanForPackages(project = "_episodes_rmd",
                                          verbose=FALSE, use.knitr = TRUE)$pkgs
    } else {
        stop("The checkpoint package (>= 0.4.0) is required to build the lessons.")
    }

    missing_pkgs <- required_pkgs[!(required_pkgs %in% rownames(installed.packages()))]

    if (length(missing_pkgs)) {
        message("Installing missing required packages: ",
                paste(missing_pkgs, collapse=", "))
        install.packages(missing_pkgs)
    }

    ## get the Rmd file to process from the command line, and generate the path for their respective outputs
    args  <- commandArgs(trailingOnly = TRUE)

    if(length(args) == 1){
	       src_rmd  <- args[1]
	       dest_md  <- paste0("_episodes/",
				  basename(tools::file_path_sans_ext(src_rmd)),
				  ".md")

    }
    else if(length(args) == 2){
	    src_rmd <- args[1]
	    dest_md <- args[2] 
    }else{
	    stop("input [and output] file must be passed to the script")
    }

    ## knit the Rmd into markdown
    knitr::knit(src_rmd, output = dest_md)

}

generate_md_episodes()
