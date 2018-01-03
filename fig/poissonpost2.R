args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=3)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
plot(NULL, xlim=c(0,sqrt(20)), ylim=c(0,dgamma(4.5,5.5)+0.01),
     xlab=expression(italic(x)), ylab="", yaxs="i", axes=FALSE)
t = c(0, 5, 10, 15, 20)
axis(1, sqrt(t), t)
curve(dgamma(x^2,6), lwd=2, add=TRUE)
segments(sqrt(5), 0, sqrt(5), dgamma(5,6), lty=2)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
