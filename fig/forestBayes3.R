args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=3)
par(family="Palatino")
par(mgp=c(2,0.5,0)) # title and axis margins. default: c(3,1,0)
# par(mar=c(4,3,3,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

pkg = "metafor"
if (!require(pkg, character.only=TRUE)) {
    install.packages(pkg)
    library(pkg, character.only=TRUE)
}
pkg = "bayesmeta"
if (!require(pkg, character.only=TRUE)) {
    install.packages(pkg)
    library(pkg, character.only=TRUE)
}

a = data.frame(y=c(14,12,11,23,8,14,6,1),
               n=c(41967,50761,17958,54928,16904,47505,25870,18326))
es = escalc("PAS", xi=a$y, mi=a$n)
r = bayesmeta(es, tau.prior="Jeffreys")
forestplot(r)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
