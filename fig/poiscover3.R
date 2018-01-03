args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=3)
par(family="Palatino")
par(mgp=c(2,0.8,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,3,2,2)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

CI = sapply(0:30, function(y) qgamma(c(0.025,0.975), y+0.5))
CI[,1] = qgamma(c(0,0.95), 0.5)
f = function(x) {
    p = dpois(0:30, x)
    sum(p * (CI[1,] <= x & x <= CI[2,]))
}
vf = Vectorize(f)
pb = function(x) (2/pi)*asin(sqrt(x))
qb = function(z) (sin(pi*z/2))^2
curve(pb(vf(x^2)), n=10001, xlab="", ylab="", xaxt="n", yaxt="n",
      xlim=c(0,sqrt(20)), ylim=c(0.72,1))
abline(h=pb(0.95), lty=3)
t = c(0,1,2,3,4,5,10,15,20)
axis(1, at=sqrt(t), labels=t)
axis(2, at=pb(seq(0.85,1,0.05)), labels=seq(0.85,1,0.05), las=1)

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
