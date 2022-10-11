library(R.matlab);
library(ggplot2);
library(tikzDevice);
options(tz="CA");
options(tikzDocumentDeclaration = "\\documentclass[12pt]{article}");

fn = sprintf("../experiments/experiment_EYaleB.mat");

res = readMat(fn);

cs = seq(from=0.1, to=0.7, by=0.1);

num = 7;

errors_IRLSp = res$mean.errors.IRLSp[1,1:num];
errors_LS = res$mean.errors.LS[1,1:num];
errors_LS_gt = res$mean.errors.LS.gt[1,1:num];

errors_CVX = res$mean.errors.LS.GT[1,1:num];

errors = c(errors_LS_gt, errors_LS, errors_IRLSp);

xbreaks=c(0, 0.2, 0.4, 0.6);
xlabels=c("$0\\%$", "$20\\%$", "$40\\%$", "$60\\%$");

name_LS = "Least-Squares"
name_IRLSp = "$\\texttt{IRLS}_{0.1}$"
name_LS_gt = "Least-Squares$^*$"

groups = factor(c(rep(name_LS_gt, num), rep(name_LS, num), rep(name_IRLSp, num)),
                  levels=c(name_LS_gt, name_LS, name_IRLSp));


linewidth = c(rep(c(0.5, 0.5, 0.5), num));
fill_values = c("red", "red", "red");
shape_values = c(0, 1, 21);
size_values = c(rep(c(rel(1.3), rel(1.5), rel(1.5)), num));

tex_path = sprintf("../../61f87e85d1b475ca03d2c008/figures/experiment_EYaleB.tex");

dat = data.frame(cs, errors, groups);

tikz(file=tex_path, height=1.5, width=1.7);

p = ggplot(data=dat, mapping=aes(x=cs,y=errors, fill=groups,shape=groups)) +

     geom_line(size=linewidth) +
     geom_point(mapping=aes(size=groups)) +

     scale_shape_manual(values=shape_values) +
     scale_fill_manual(values=fill_values) +
     scale_size_manual(values=size_values) +

     scale_y_continuous(breaks=c(0, 0.1, 0.2, 0.3, 0.37), labels=c("$0$", "$0.1$", "$0.2$", "$0.3$", "$0.37$")) +
     # scale_y_continuous(trans="log10", breaks=c(1, 1e-2, 1e-4, 1e-16),
     #                                   labels=c("1", "$10^{-2}$", "$10^{-4}$", "$10^{-16}$") ) +

     # scale_y_continuous(trans="log10", breaks=scales::trans_breaks('log10', function(x) 10^x),
     #                                   labels=scales::trans_format('log10', scales::math_format(10^.x))) +
     scale_x_continuous(breaks = xbreaks, labels = xlabels) +

     labs(x="$k/m$",y="Relative Error") +

     theme(axis.text=element_text(face="plain", size=rel(0.8), color='gray10'),
         legend.text=element_text(face="plain",size=rel(0.75), family="mono"),
         # legend.text=element_blank(),
         plot.title=element_blank(),
         title=element_text(face="plain",size=rel(0.75), color='gray10'),
         axis.title.y=element_text(face="plain",size=rel(1.23), color='gray10'),
         axis.title.x=element_text(face="plain",size=rel(1.4), color='gray10'),
         panel.border = element_blank(),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background=element_blank(),
         legend.key=element_blank(),
         legend.margin = margin(0.4,2,0.4,1),
         legend.title=element_blank(),
         legend.position=c(0.4,0.8), # legend.position = "none",
         legend.spacing.x=unit(rel(0.18),"lines"), legend.key.size = unit(rel(0.07), 'lines')
      )

print(p)
