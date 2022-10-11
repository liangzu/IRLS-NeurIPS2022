library(R.matlab);
library(ggplot2);
library(tikzDevice);
options(tz="CA");
options(tikzDocumentDeclaration = "\\documentclass[12pt]{article}");

fn = sprintf("../experiments/experiment_RPR_minimum_samples.mat");

res = readMat(fn);

ks = seq(from=10, to=90, by=10);

num = 9;

errors_IRLSp = res$mean.errors.IRLSp[1,1:num]
errors_IRLS1 = res$mean.errors.IRLS1[1,1:num];

errors_Kaczmarz = res$mean.errors.Kaczmarz[1,1:num];
errors_PhaseLamp = res$mean.errors.PhaseLamp[1,1:num];
errors_TWF = res$mean.errors.TWF[1,1:num];
errors_CD = res$mean.errors.CD[1,1:num];

errors = c(errors_IRLSp, errors_IRLS1, errors_Kaczmarz, errors_PhaseLamp, errors_TWF, errors_CD);

xbreaks=c(10, 30, 50, 70, 90);
xlabels=c("$10$", "$30$", "$50$", "$70$", "$90$");

name_IRLSp = "$\\texttt{IRLS}_{0.1}$"
name_IRLS1 = "$\\texttt{IRLS}_{1}$"
name_Kaczmarz = "Kaczmarz \\cite{Wei-IP2015,Tan-AA-J-IMA2019}"
name_PhaseLamp = "PhaseLamp \\cite{Dhifallah-Allerton2017}"
name_TWF = "Truncated Wirtinger Flow \\cite{Chen-NIPS2015}"
name_CD = "Coordinate Descent \\cite{Zeng-arXiv2017}"

groups = factor(c(rep(name_IRLSp, num), rep(name_IRLS1, num),
                  rep(name_Kaczmarz, num), rep(name_PhaseLamp, num),
                  rep(name_TWF, num), rep(name_CD, num)),
                  levels=c(name_Kaczmarz, name_PhaseLamp, name_TWF, name_CD, name_IRLS1, name_IRLSp));

linewidth = c(rep(c(0.5, 0.5, 0.5, 0.5, 0.5, 0.5), num));
fill_values = c("red", "red", "red", "red", "red", "red");
shape_values = c(0,1,2,3,22, 21);
size_values = c(rep(c(rel(1.3), rel(1.3), rel(1.3), rel(1.3), rel(1.3), rel(1.3)), num));

tex_path = sprintf("../../61f87e85d1b475ca03d2c008/figures/experiment_RPR_minimum_samples.tex");

dat = data.frame(ks, errors, groups);

tikz(file=tex_path, height=1.5, width=1.73);

p = ggplot(data=dat, mapping=aes(x=ks,y=errors, fill=groups,shape=groups)) +

     geom_line(size=linewidth, linetype="dashed", position=position_dodge(width=10)) +
     geom_point(mapping=aes(size=groups), position=position_dodge(width=10)) +

     scale_shape_manual(values=shape_values) +
     scale_fill_manual(values=fill_values) +
     scale_size_manual(values=size_values) +

     # scale_y_continuous(breaks=c(0, 0.25, 0.5, 0.75, 1), labels=c("$0\\%$", "$25\\%$", "$50\\%$", "$75\\%$", "$100\\%$")) +
     scale_y_continuous(trans="log10", breaks=c(1, 1e-2,  1e-15),
                                       labels=c("1", "$10^{-2}$",  "$10^{-15}$") ) +

     # scale_y_continuous(trans="log10", breaks=scales::trans_breaks('log10', function(x) 10^x),
     #                                   labels=scales::trans_format('log10', scales::math_format(10^.x))) +
     scale_x_continuous(breaks = xbreaks, labels = xlabels) +

     labs(x="$|I^+|$",y="Relative Error") +

     theme(axis.text=element_text(face="plain", size=rel(0.8), color='gray10'),
         legend.text=element_text(face="plain",size=rel(0.75), family="mono"),
         # legend.text=element_blank(),
         plot.title=element_blank(),
         title=element_text(face="plain",size=rel(0.75), color='gray10'),
         axis.title.y=element_text(face="plain",size=rel(1.23), color='gray10'),
         axis.title.x=element_text(face="plain",size=rel(1.3), color='gray10'),
         panel.border = element_blank(),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background=element_blank(),
         legend.key=element_blank(),
         legend.margin = margin(0.4,2,0.4,1),
         legend.title=element_blank(),
         legend.position=c(0.5,0.5), # legend.position = "none",
         legend.spacing.x=unit(rel(0.18),"lines"), legend.key.size = unit(rel(0.07), 'lines')
      )

print(p)
