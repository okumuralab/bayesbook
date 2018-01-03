args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=5, height=3.5)
par(family="Palatino")
par(mgp=c(2,0.8,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

pkg = "gsl"
if (!require(pkg, character.only=TRUE)) {
    install.packages(pkg)
    library(pkg, character.only=TRUE)
}

x = c(1, 2, 3, 4, 5, 6)
y = c(1, 3, 2, 4, 3, 5)
n = length(x)
r = cor(x, y)

f = function(rho, r, n) {
  (1-rho^2)^((n-1)/2) * (1-r^2)^((n-4)/2) *
  (1-rho*r)^(3/2-n) * hyperg_2F1(0.5,0.5,n-0.5,(1+rho*r)/2)
}
# f = function(rho, r, n) {
#     (1-rho^2)^((n-1)/2) * (1-r^2)^((n-4)/2) *
#         integrate(function(w) (cosh(w) - rho * r)^(1-n), 0, Inf)$value
# }
area = integrate(function(z) Vectorize(f)(tanh(z), r, n), -Inf, Inf)$value
curve(Vectorize(f)(tanh(x), r, n) / area,
      lwd=2, xlab=expression(italic(rho)), ylab="", ylim=c(0,0.83), yaxs="i",
      axes=FALSE, xlim=atanh(c(-0.5,0.99)))
t = c(-0.5,0,0.5,0.8,0.9,0.95,0.99)
axis(1, atanh(t), t)
curve(dnorm(x, atanh(r), 1/sqrt(n-3)), add=TRUE, lty=2, lwd=2)
abline(v=atanh(r))

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
