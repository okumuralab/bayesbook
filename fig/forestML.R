args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=4)
par(family="Palatino")
par(mgp=c(1.5,0.3,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

pkg = "metafor"
if (!require(pkg, character.only=TRUE)) {
    install.packages(pkg)
    library(pkg, character.only=TRUE)
}

es = escalc(measure="AS", ai=tpos, bi=tneg, ci=cpos, di=cneg, data=dat.bcg)
r = rma(yi, vi, data=es, method="ML")
forest(r, slab=paste(es$author,es$year,sep=", "), # xlab="", 
       xlim=c(-1.6,0.5), # at=log(c(0.05,0.25,1,4)), # atransf=exp,
       ilab=cbind(es$tpos,es$tneg,es$cpos,es$cneg),
       ilab.xpos=c(-0.95,-0.8,-0.6,-0.45)+0.07, ilab.pos=c(2,2,2,2),
       cex=0.75)
par(cex=0.75, font=2)
text(c(-0.95,-0.8,-0.6,-0.45), 15, c("TB+","TB-","TB+","TB-"))
text(c(-0.875,-0.525), 16, c("Vaccinated","Control"))
text(-1.6, 15, "Author(s) and Year", pos=4)
text(0.5, 15, "Effect Size [95% CI]", pos=2)

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
