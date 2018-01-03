args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=4)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,3,2,2)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

set.seed(12345678)
y134 = 0.00470; s134 = 0.000803
y137 = 0.0469;  s137 = 0.00144
d = as.numeric(difftime(as.POSIXct("2017-08-21"),
                        as.POSIXct("2011-03-11")), units="days")
c = 2^((1/30.08 - 1/2.0652) * d / 365.2422)
x137 = rnorm(1000000, y137, s137)
x134 = rnorm(1000000, y134, s134)
r = x134 / (c * x137)
r = ifelse(r <= 1, r, NA)
hist(r, freq=FALSE, breaks=seq(0,1,0.02), col=gray(0.9),
     main="", xlab=expression(italic(r)), ylab="")

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
