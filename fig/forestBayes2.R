args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=7)
par(family="Palatino")
par(mgp=c(2,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(4,3,3,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

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

es = escalc(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, data=dat.bcg)
r = bayesmeta(as.numeric(es$yi), sqrt(es$vi), tau.prior="Jeffreys")
par(mfrow = c(2,2))
plot(r)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
