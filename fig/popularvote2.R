args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=2.5)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

plot(NULL, xlim=c(0,1), ylim=c(0,dbeta(36/(36+42),37,43)*1.01),
     xlab=expression(italic(x)), ylab="", yaxs="i", axes=FALSE)
axis(1)

curve(dbeta(x,35,35), lty=2, add=TRUE)
curve(dbeta(x,3,9), lty=2, add=TRUE)
curve(dbeta(x,37,43), add=TRUE)

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
