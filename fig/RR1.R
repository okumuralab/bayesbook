args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=2.5)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(2,2,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

rRR = function(n, a, b, c, d) {
  rbeta(n, a+0.5, b+0.5) / rbeta(n, c+0.5, d+0.5)
}
r = rRR(1e7, 12, 6, 5, 12)
hist(r, freq=FALSE, xlim=c(0,8), breaks=seq(0,max(r)+1,0.2), col=gray(0.9),
     main="", xlab="", ylab="")

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
