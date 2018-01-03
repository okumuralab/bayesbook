args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=5, height=3.5)
par(family="Palatino")
par(mgp=c(2,0.8,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

plot(NULL, xlim=c(0,35), ylim=c(0,0.11),
     xlab=expression(italic(mu)), ylab="", yaxs="i", axes=FALSE)
axis(1)
curve(dnorm(x, 20, 5), lty=2, lwd=2, add=TRUE)
a = integrate(function(x) pnorm(15, x, 5), 0, 35)$value
curve(pnorm(15, x, 5) / a, lty=2, lwd=2, add=TRUE)
p = function(x) dnorm(20, x, 5) * pnorm(15, x, 5)
a = integrate(p, 0, 35)$value
curve(p(x) / a, lwd=2, add=TRUE)

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
