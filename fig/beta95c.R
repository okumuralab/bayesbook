args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=2.5)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
plot(NULL, xlim=c(0,1), ylim=c(0,dbeta(0.166667,2.5,8.5)+0.1),
     xlab=expression(italic(x)), ylab="", yaxs="i", axes=FALSE)
axis(1)
q = qbeta(c(0.025,0.975), 2.5, 8.5)
x = seq(q[1], q[2], length.out=100)
fy = function(x) { dbeta(x, 2.5, 8.5) }
y = sapply(x, fy)
polygon(c(x,x[length(x)],x[1]), c(y,0,0), col=gray(0.9))
curve(fy(x), 0, 1, add=TRUE)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
