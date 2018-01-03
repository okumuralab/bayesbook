args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=3)

pkg = "cubature"
if (!require(pkg, character.only=TRUE)) {
    install.packages(pkg)
    library(pkg, character.only=TRUE)
}

par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,1,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
y = diff(c(1498, 1605, 1707, 1854))
f = function(t,m,a2) sqrt(m/(2*pi*a2*t^3)) * exp(-(t-m)^2/(2*a2*m*t))
lik = function(m,a2) f(y[1],m,a2) * f(y[2],m,a2) * f(y[3],m,a2)
# f2 = function(t, m) {
#     integrate(function(x) f(t,m,exp(x)) * lik(m,exp(x)), -10, 10)$value
# }
# vf2 = Vectorize(f2)
# ytilde = function(t) {
#     integrate(function(m) vf2(t,m), 0, 1000)$value
# }
ff = function(t,m,v) f(t,m,exp(v)) * lik(m,exp(v))
ytilde = function(t) {
    adaptIntegrate(function(x) ff(t,x[1],x[2]), c(0,-10), c(1000,1))$integral
}
curve(Vectorize(ytilde)(x), 1, 200, ylim=c(0,2.5e-06),
      xlab="predictive distribution", ylab="", yaxs="i", axes=FALSE)
axis(1)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
