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

es = escalc(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, data=dat.bcg)
r = rma(yi, vi, data=es, method="FE")
forest(r, xlab="", slab=paste(es$author,es$year,sep=", "),
       xlim=c(-16,6), at=log(c(0.05,0.25,1,4)), atransf=exp,
       ilab=cbind(es$tpos,es$tneg,es$cpos,es$cneg),
       ilab.xpos=c(-9.5,-8,-6,-4.5)+0.7, ilab.pos=c(2,2,2,2),
       cex=0.75)
par(cex=0.75, font=2)
text(c(-9.5,-8,-6,-4.5), 15, c("TB+","TB-","TB+","TB-"))
text(c(-8.75,-5.25), 16, c("Vaccinated","Control"))
text(-16, 15, "Author(s) and Year", pos=4)
text(6, 15, "Odds Ratio [95% CI]", pos=2)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
