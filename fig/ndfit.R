args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=4, height=4)
par(family="Palatino")
par(mgp=c(1.5,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,3,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

set.seed(12345678)             # 乱数の初期化
xdata = c(1, 2, 3, 4, 5, 6)
ydata = c(NA, NA, 3, 5, 4, 6)
iy = is.na(ydata)              # NA
jy = !iy                       # NA以外
ny = sum(jy)                   # NA以外の個数
logpost = function(a, b, t) {  # 事後分布の対数
  sum(ifelse(a*xdata+b >= 0, 0, -Inf)) +
  sum(pnorm(2, a*xdata[iy]+b, exp(t/2), log.p=TRUE)) -
  0.5 * (ny*t + sum((a*xdata[jy]+b-ydata[jy])^2)/exp(t))
}
a = 1;  b = t = 0     # 適当な初期値
lp = logpost(a, b, t) # 現在の事後分布の対数
N = 100000            # 繰返し数
atrace = btrace = ttrace = numeric(N)  # 足跡を格納する配列
for (i in 1:N) {
  anew = rnorm(1, a, 1) # 次の候補
  bnew = rnorm(1, b, 1) # 次の候補
  tnew = rnorm(1, t, 1) # 次の候補
  lq = logpost(anew, bnew, tnew)  # 次の候補の事後分布
  if (lp - lq < rexp(1)) {  # メトロポリスの更新（対数版）
    a = anew
    b = bnew
    t = tnew
    lp = lq
  }
  atrace[i] = a    # 配列に格納
  btrace[i] = b    # 配列に格納
  ttrace[i] = t    # 配列に格納
}

plot(xdata, ydata, ylim=c(0,6), pch=16, asp=1,
     xlab=expression(italic(x)), ylab=expression(italic(y)))
abline(mean(btrace), mean(atrace))
points(1:2, c(2,2), pch=1)
arrows(1,2, 1,0, length=0.1, angle=20)
arrows(2,2, 2,0, length=0.1, angle=20)
abline(lm(ydata ~ xdata), lty=2)

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
