args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=2.5)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

f = function(x) dbeta(x, 3, 9)
pb = function(x) (2/pi)*asin(sqrt(x))
qb = function(z) (sin(pi*z/2))^2
curve(f(qb(x)), 0, 1, ylim=c(0, 1.01*f(0.2)),
      xlab=expression(italic(x)), ylab="", yaxs="i", axes=FALSE)
axis(1, at=pb(0:5/5), 0:5/5)
segments(pb(0.2), 0, pb(0.2), f(0.2), lty=2)

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
