args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=4)
# par(family="Latin Modern Mono 10 Regular")
# par(family="HiraKakuProN-W3")
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,2,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

odds = function(n, a, b) {
  r = rbeta(n, a+0.5, b+0.5)
  r/(1 - r)
}
oddsratio = odds(1e7, 12, 6) / odds(1e7, 5, 12)
hist(oddsratio, breaks=seq(0,max(oddsratio)+1,0.5), xlim=c(0,50), freq=FALSE,
     col=gray(0.9), main="", xlab="odds ratio", ylab="")

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
