args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=4)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,3,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

y = diff(c(1498, 1605, 1707, 1854))
# f = function(t,m,a2) sqrt(m/(2*pi*a2*t^3)) * exp(-(t-m)^2/(2*a2*m*t))
# lik = function(m,a2) f(y[1],m,a2) * f(y[2],m,a2) * f(y[3],m,a2)
f = function(t,m,a2) (log(m/(a2*t^3)) - (t-m)^2/(a2*m*t)) / 2
llik = function(m,a2) f(y[1],m,a2) + f(y[2],m,a2) + f(y[3],m,a2)
x1 = seq(80, 180, length.out=100)
x2 = seq(-5, -1, length.out=100)
contour(x1, x2, outer(x1, x2, function(u,v) llik(u,exp(v))), yaxt="n", nlevels=50,
        xlab=expression(italic(mu)), ylab=expression(italic(alpha)^2))
t = c(0.005, 0.01, 0.02, 0.05, 0.1, 0.2)
axis(2, at=log(t), labels=t)

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
