args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=4)
# par(family="HiraKakuProN-W3")
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
plot(NULL, xlim=c(0,sqrt(10)), ylim=c(0,2),
     xlab=expression(italic(x)), ylab="", yaxs="i", axes=FALSE)
axis(1, at=sqrt(0:10), labels=0:10)
polygon(c(0,sqrt(10),sqrt(10),0,0), c(0,0,sqrt(10)/5,sqrt(10)/5,0), col=gray(0.9))
segments(sqrt(0:10), 0, sqrt(0:10), sqrt(10)/5)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
