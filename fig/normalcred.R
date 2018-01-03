args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=2.5)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
plot(NULL, xlim=c(0,3.1), ylim=c(0,1.05*dnorm(0,-0.5,1)),
     xlab=expression(italic(mu)), ylab="", yaxs="i", axes=FALSE)
axis(1)
t = pnorm(0, -0.5, 1, lower.tail=FALSE)
q = uniroot(function(x) pnorm(x, -0.5, 1, lower.tail=FALSE) - 0.05 * t, c(0,3))$root
x = seq(0, q, length.out=100)
y = dnorm(x, -0.5, 1)
polygon(c(x,x[length(x)],x[1]), c(y,0,0), col=gray(0.9))
curve(dnorm(x, -0.5, 1), lwd=2, add=TRUE)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
