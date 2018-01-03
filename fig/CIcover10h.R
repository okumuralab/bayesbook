args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=3)
par(family="Palatino")
par(mgp=c(2,0.8,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,3,2,2)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

pb = function(x) (2/pi)*asin(sqrt(x))  # pbeta(x,0.5,0.5)
qb = function(z) (sin(pi*z/2))^2       # qbeta(z,0.5,0.5)
binomHPD = function(n, y) {
  a = y + 0.5
  b = n - y + 0.5
  f = function(x) pb(qbeta(x+0.95,a,b))-pb(qbeta(x,a,b))
  x = optimize(f, c(0,0.05), tol=1e-8)$minimum
  qbeta(c(x,x+0.95), a, b)
}
HPD = sapply(0:10, function(y) binomHPD(10,y))
HPD[1,1] = 0
f = function(x) {
  p = dbinom(0:10, 10, x)
  sum(p * (HPD[1,] <= x & x <= HPD[2,]))
}
vf = Vectorize(f)
curve(pb(vf(qb(x))), n=10001, xlab="", ylab="", xaxt="n", yaxt="n", ylim=c(0.72,1))
abline(h=pb(0.95), lty=3)
axis(1, at=pb((0:10)/10), labels=(0:10)/10)
axis(2, at=pb(seq(0.85,1,0.05)), labels=seq(0.85,1,0.05), las=1)

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
