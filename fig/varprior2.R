args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=4)
# par(family="HiraKakuProN-W3")
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
plot(NULL, xlim=c(0.2,50), ylim=c(0,1),
     xlab=expression(italic(sigma)), ylab="", yaxs="i", axes=FALSE)
t = c(0.2, 0.5, 1, 2, 5, 10, 20, 50)
axis(1, at=t[c(1,5:8)], labels=t[c(1,5:8)])
x = seq(0.2, 50, length.out=100)
y = 1/x
polygon(c(x,x[length(x)],x[1]), c(y,0,0), col=gray(0.9))
segments(t, 0, t, 1/t)
curve(1/x, add=TRUE)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
