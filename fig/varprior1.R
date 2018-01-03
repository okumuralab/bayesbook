args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=4)
# par(family="HiraKakuProN-W3")
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
plot(NULL, xlim=c(0.2,50), ylim=c(0,1), log="x",
     xlab=expression(italic(sigma)), ylab="", yaxs="i", axes=FALSE)
t = c(0.2, 0.5, 1, 2, 5, 10, 20, 50)
axis(1, at=t, labels=t)
polygon(c(t[1],tail(t,1),tail(t,1),t[1],t[1]), c(0,0,0.1,0.1,0), col=gray(0.9))
segments(t, 0, t, 0.1)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
