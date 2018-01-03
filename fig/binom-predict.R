args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=3)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,3,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1
# x = rbeta(10000000, 2.5, 8.5)
# z = sapply(0:10, function(r) mean(dbinom(r, 10, x)))
z = c(0.1593056405, 0.2275594124, 0.2171949113, 0.1681326536, 0.1115948884, 0.0644719485, 0.0322315126, 0.0136091891, 0.0046147581, 0.0011322288, 0.0001528566)
barplot(z, names.arg=0:10)
dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
