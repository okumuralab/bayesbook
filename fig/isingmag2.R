args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=6, height=4)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,3,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
x = read.csv("isingmag2.csv")
plot(x$kT, x$Magnetization, pch=x$Round, xlab=expression(italic(kT)), ylab="Magnetization")
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
