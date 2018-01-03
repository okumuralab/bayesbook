args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=3.5)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,2,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

varAS = function(n, x) {
  a = asin(sqrt((0:n)/n))  # 分散安定化変換
  d = dbinom(0:n, n, x)    # 2項分布
  m = sum(d * a)           # 平均
  sum(d * (a - m)^2)       # 分散
}

mv = function(a, b) {
  f = function(x) dbeta(x, a+0.5, b+0.5)
  m = integrate(function(x) asin(sqrt(x)) * f(x), 0, 1)$value
  v = integrate(function(x) (asin(sqrt(x)) - m)^2 * f(x), 0, 1)$value
  c(m, v)
}

# mv = function(a, b) {
#   f = function(z) dbeta((sin(z))^2, a+1, b+1)
#   area = integrate(f, 0, pi/2)$value
#   m = integrate(function(z) z * f(z) / area, 0, pi/2)$value
#   v = integrate(function(z) (z - m)^2 * f(z) / area, 0, pi/2)$value
#   c(m, v)
# }

n = 20
curve(Vectorize(varAS)(n, x), 0, 1, lwd=2, xlab=expression(italic(x)), ylab="")
v = sapply(0:n, function(i) mv(i, n-i)[2])
points(0:n/n, v, pch=16)
abline(h=1/(4*n))

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
