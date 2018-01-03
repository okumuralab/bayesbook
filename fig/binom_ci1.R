args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=7, height=7)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,3,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

pb = function(x) (2/pi)*asin(sqrt(x))  # pbeta(x,0.5,0.5)
qb = function(z) (sin(pi*z/2))^2       # qbeta(z,0.5,0.5)
n = 100
plot(NULL, xlim=c(0,1), ylim=c(0,n), xlab=expression(italic(x)), ylab="", axes=FALSE)
axis(1, at=pb((0:10)/10), labels=(0:10)/10)
for (y in (0:10)*(n/10)) {
  text(-0.01, y, parse(text=paste0("italic(y) == ", y)), xpd=NA, pos=2)
  ci = binom.test(y, n)$conf.int
  arrows(pb(ci[1]), y-n/50, pb(ci[2]), y-n/50, length=0.03, angle=90, code=3)
  points(pb(y/n), y-n/50, pch=16)
  # a = y + 1
  # b = n - y + 1
  # x = optimize(function(x) qbeta(x+0.95,a,b)-qbeta(x,a,b), c(0,0.05), tol=1e-8)$minimum
  # bh = qbeta(c(x,x+0.95), a, b)
  # arrows(pb(bh[1]), y, pb(bh[2]), y, length=0.03, angle=90, code=3)
  # points(pb(y/n), y, pch=16)
  a = y + 0.5
  b = n - y + 0.5
  # if (y == 0) {
  #   bc = qbeta(c(0,0.95), a, b)
  # } else if (y == n) {
  #   bc = qbeta(c(0.05,1), a, b)
  # } else {
  #   bc = qbeta(c(0.025,0.975), a, b)
  # }
  bc = qbeta(c(0.025,0.5,0.975), a, b)
  arrows(pb(bc[1]), y, pb(bc[3]), y, length=0.03, angle=90, code=3)
  segments(pb(bc[2]), y-n/100, pb(bc[2]), y+n/100)
  # points(pb(y/n), y, pch=16)
  f = function(x) pb(qbeta(x+0.95,a,b))-pb(qbeta(x,a,b))
  x = optimize(f, c(0,0.05), tol=1e-8)$minimum
  bh = qbeta(c(x,x+0.95), a, b)
  arrows(pb(bh[1]), y+n/50, pb(bh[2]), y+n/50, length=0.03, angle=90, code=3)
  # points(pb(y/n), y+n/50, pch=16)
}

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
