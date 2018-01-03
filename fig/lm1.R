args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray",
           width=13/4/25.4/0.664*15, height=13/4/25.4/0.664*15) # 15zw*15zw
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,3,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
x = c(1,2,3,4,5,6)
y = c(1,3,2,4,3,5)
plot(x, y, type="p", pch=16, xlim=c(0,7), ylim=c(0,6), asp=1,
     xlab=expression(italic(x)), ylab=expression(italic(y)))
abline(0.8, 0.6286)
text(c(1,3,5), c(1,2,3), pos=1, labels=c("(1,1)","(3,2)","(5,3)"))
text(c(2,4,6), c(3,4,5), pos=3, labels=c("(2,3)","(4,4)","(6,5)"))
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
