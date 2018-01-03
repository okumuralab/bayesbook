args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=4)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,3,2,2)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

## n1 = 10
## n2 = 30
## fun = function() {
##   y1 = rnorm(n1, mean=0, sd=1.5)
##   y2 = rnorm(n2, mean=0, sd=1.0)
##   m1 = mean(y1)
##   m2 = mean(y2)
##   s1 = sqrt(var(y1) / n1)
##   s2 = sqrt(var(y2) / n2)
##   f = function(x) pt((x-m1)/s1, n1-1) * dt((x-m2)/s2, n2-1) / s2
##   integrate(f, -Inf, Inf)$value
## }
## p = replicate(10000000, fun())

p = rep((1:50)/50-1/100, c(
184367,191581,194075,196044,196914,197652,199415,199605,199571,200897,
201583,200629,201638,202198,201826,202810,202505,202890,203630,203753,
202582,203529,204067,203434,203580,203283,203599,203144,203796,203609,
204022,202568,202750,202320,202166,202197,201779,202090,200804,200821,
200286,200317,199290,199948,197981,196562,196598,193666,191372,184257))

hist(p, freq=FALSE, breaks=50,
     col=gray(0.9), main="", xlab=expression(italic(p)), ylab="")

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
