args = commandArgs()
basename = sub(".R$", "", sub("^--file=(.*/)?", "", args[grep("^--file=", args)]))
if (length(basename) != 0)
    pdf(file=paste0(basename, "_tmp.pdf"), colormodel="gray", width=8, height=3)
par(family="Palatino")
par(mgp=c(1.8,0.5,0)) # title and axis margins. default: c(3,1,0)
par(mar=c(3,3,1,1)+0.1) # bottom, left, top, right margins. default: c(5,4,4,2)+0.1

pkg = "metafor"
if (!require(pkg, character.only=TRUE)) {
    install.packages(pkg)
    library(pkg, character.only=TRUE)
}

es = escalc(measure="AS", ai=tpos, bi=tneg, ci=cpos, di=cneg, data=dat.bcg)
ydata = es$yi
s2data = es$vi
set.seed(12345678)            # 乱数の初期化
n = length(ydata)             # データの個数
s2bar = 1 / mean(1/s2data)    # 平均の誤差分散
logpost = function(m, u) {    # 事後分布の対数
  t2 = exp(u) - s2bar
  if (t2 < 0) return(-Inf)
  (log(sum(1/(t2+s2data)^2)) - sum((ydata-m)^2/(t2+s2data))
                             - sum(log(t2+s2data))) / 2 + u
}
m = mean(ydata)               # 適当な初期値
u = log(var(ydata) + s2bar)   # 適当な初期値
msd = sqrt(var(ydata)/n)
usd = sqrt(2/n)
lp = logpost(m, u)            # 事後分布の対数
N = 1e6                       # 繰返し数
utrace = mtrace  = numeric(N) # 足跡を格納する配列
for (i in 1:N) {
  mnew = rnorm(1, m, msd)     # 次の候補
  unew = rnorm(1, u, usd)     # 次の候補
  lq = logpost(mnew, unew)    # 次の候補の事後分布
  if (lp - lq < rexp(1)) {    # メトロポリスの更新（対数版）
    m = mnew
    u = unew
    lp = lq
  }
  mtrace[i] = m               # 配列に格納
  utrace[i] = u               # 配列に格納
}

par(mfrow=c(1,2))

hist(mtrace, freq=FALSE, col=gray(0.9), breaks=seq(-0.5,0.5,0.005), xlim=c(-0.15,0.05),
     xlab=expression(italic(mu)), main="")

hist(sqrt(exp(utrace)-s2bar), freq=FALSE, breaks=seq(0,1,0.002), xlim=c(0.02,0.14),
     col=gray(0.9), xlab=expression(italic(tau)), main="")

dev.off()
embedFonts(paste0(basename, "_tmp.pdf"), outfile=paste0(basename, ".pdf"),
           options="-c \"<</NeverEmbed []>> setdistillerparams\" -f ")
