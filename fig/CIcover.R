args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=3)
par(family="Palatino")
par(mgp=c(2,0.8,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,3,2,2)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

CI = sapply(0:10, function(y) binom.test(y,10)$conf.int)
f = function(x) {
  p = dbinom(0:10, 10, x)
  sum(p * (CI[1,] <= x & x <= CI[2,]))
}
vf = Vectorize(f)
pb = function(x) (2/pi)*asin(sqrt(x))
qb = function(z) (sin(pi*z/2))^2
curve(pb(vf(qb(x))), n=10001, ylim=c(pb(0.72),1), xlab="", ylab="", xaxt="n", yaxt="n")
abline(h=pb(0.95), lty=3)
axis(1, at=pb((0:10)/10), labels=(0:10)/10)
axis(2, at=pb(seq(0.85,1,0.05)), labels=seq(0.85,1,0.05), las=1)

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
