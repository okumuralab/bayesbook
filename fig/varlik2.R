args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=3)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
plot(NULL, xlim=c(-5,10), ylim=c(0,0.25),
     xlab=expression(italic(x) * " = log " * italic(sigma)^2 * " = 2 log " * italic(sigma)),
     ylab="", yaxs="i", axes=FALSE)
axis(1)
curve(1/sqrt(2*pi*exp(x))*exp(-1/(2*exp(x))), lwd=2, add=TRUE)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
