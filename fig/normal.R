args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=5, height=3)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
plot(NULL, xlim=c(-3.5,3.5), ylim=c(0,1.05*dnorm(0)),
     xlab="", ylab="", yaxs="i", axes=FALSE)
axis(1, seq(-3,3), rep("",7))
curve(dnorm(x), lwd=2, add=TRUE)
mtext(expression(italic(mu)), side=1, line=1, at=0)
mtext(expression(italic(mu)+italic(sigma)), side=1, line=1, at=1)
mtext(expression(italic(mu)+2*italic(sigma)), side=1, line=1, at=2)
mtext(expression(italic(mu)+3*italic(sigma)), side=1, line=1, at=3)
mtext(expression(italic(mu)-italic(sigma)), side=1, line=1, at=-1)
mtext(expression(italic(mu)-2*italic(sigma)), side=1, line=1, at=-2)
mtext(expression(italic(mu)-3*italic(sigma)), side=1, line=1, at=-3)
segments(c(3,-3), 0, c(3.5,-3.5), 0, xpd=TRUE)
# i = -3:3
# segments(i, 0, i, dnorm(i))
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
