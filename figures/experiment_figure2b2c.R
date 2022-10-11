library(R.matlab);
library(ggplot2);
library(tikzDevice);
options(tz="CA");
options(tikzDocumentDeclaration = "\\documentclass[12pt]{article}");

fn = sprintf("../experiments/experiment_SLR_time_error_m.mat");

res = readMat(fn);

ms = seq(from=1000, to=9000, by=1000);

num = 9;

errors_IRLS1 = res$mean.errors.IRLS1[1,1:num];
errors_IRLSp = res$mean.errors.IRLSp[1,1:num];

errors_Gurobi = res$mean.errors.Gurobi[1,1:num];
errors_PDHG = res$mean.errors.PDHG[1,1:num];
errors_proximal = res$mean.errors.proximal[1,1:num];

errors = c(errors_IRLS1, errors_IRLSp, errors_Gurobi, errors_PDHG, errors_proximal);

times_IRLS1 = res$mean.times.IRLS1[1,1:num];
times_IRLSp = res$mean.times.IRLSp[1,1:num];

times_Gurobi = res$mean.times.Gurobi[1,1:num];
times_PDHG = res$mean.times.PDHG[1,1:num];
times_proximal = res$mean.times.proximal[1,1:num];


times = c(times_IRLS1, times_IRLSp, times_Gurobi, times_PDHG, times_proximal);

xbreaks=c(1000, 3000, 5000, 7000, 9000);
xlabels=c("$1000$", "$3000$", "$5000$", "$7000$", "$9000$");

name_IRLS1 = "$\\texttt{IRLS}_1$"
name_IRLSp = "$\\texttt{IRLS}_{0.1}$"
name_Gurobi = "Gurobi"
name_PDHG = "PDHG \\cite{Applegate-NeurIPS2021}"
name_proximal = "Subgradient Descent \\cite{Beck-OMS2019}"


groups = factor(c(rep(name_IRLS1, num), rep(name_IRLSp, num),
                  rep(name_Gurobi, num), rep(name_PDHG, num), rep(name_proximal, num)),
                  levels=c(name_IRLS1, name_IRLSp, name_Gurobi, name_PDHG, name_proximal));


linewidth = c(rep(c(0.5, 0.5, 0.5, 0.5, 0.5), num));
fill_values = c("red", "red", "red", "red", "red");
shape_values = c(22, 21, 0, 1, 2);
size_values = c(rep(c(rel(1.3), rel(1.3), rel(1.3), rel(1.3), rel(1.3)), num));

tex_path = sprintf("../../61f87e85d1b475ca03d2c008/figures/experiment_SLR_error_m.tex");

dat = data.frame(ms, errors, groups);

tikz(file=tex_path, height=1.5, width=1.7);

p = ggplot(data=dat, mapping=aes(x=ms,y=errors, fill=groups,shape=groups)) +

     geom_line(size=linewidth) +
     geom_point(mapping=aes(size=groups)) +

     scale_shape_manual(values=shape_values) +
     scale_fill_manual(values=fill_values) +
     scale_size_manual(values=size_values) +

     # scale_y_continuous(breaks=c(0, 0.1, 0.2, 0.3, 0.37), labels=c("$0$", "$0.1$", "$0.2$", "$0.3$", "$0.37$")) +
     # scale_y_continuous(trans="log10", breaks=c(1, 1e-2, 1e-6, 1e-16),
     #                                   labels=c("1", "$10^{-2}$", "$10^{-6}$", "$10^{-16}$") ) +

     scale_y_continuous(trans="log10", breaks=c(1, 1e-2, 1e-6, 1e-15),
                                       labels=c("1", "$10^{-2}$", "$10^{-6}$", "$10^{-15}$") ) +

     scale_x_continuous(breaks = xbreaks, labels = xlabels) +

     labs(x="$m$",y="Relative Error") +

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
         legend.position=c(0.3,0.42), # legend.position = "none",
         legend.spacing.x=unit(rel(0.18),"lines"), legend.key.size = unit(rel(0.07), 'lines')
      )

print(p)





tex_path = sprintf("../../61f87e85d1b475ca03d2c008/figures/experiment_SLR_time_m.tex");

dat = data.frame(ms, times, groups);

tikz(file=tex_path, height=1.5, width=1.7);


p = ggplot(data=dat, mapping=aes(x=ms,y=times, fill=groups,shape=groups)) +

     geom_line(size=linewidth) +
     geom_point(mapping=aes(size=groups)) +

     scale_shape_manual(values=shape_values) +
     scale_fill_manual(values=fill_values) +
     scale_size_manual(values=size_values) +

     # scale_y_continuous(breaks=c(0, 0.25, 0.5, 0.75), labels=c("$0$", "$\\frac{1}{4}$", "$\\frac{2}{4}$", "$\\frac{3}{4}$")) +
     scale_y_continuous(trans="log10", breaks=c(7, 2, 1e-1, 2e-2, 5e-3),
                                       labels=c("$7$", "$2$", "$0.1$", "$0.02$", "$0.005$") ) +

     # scale_y_continuous(trans="log10", breaks=scales::trans_breaks('log10', function(x) 10^x),
     #                                   labels=scales::trans_format('log10', scales::math_format(10^.x))) +
     scale_x_continuous(breaks = xbreaks, labels = xlabels) +

     labs(x="$m$",y="Time (Seconds)") +

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
         # legend.position=c(0.55,0.55),
         legend.position = "none",
         # legend.spacing.x=unit(rel(0.18),"lines"), legend.key.size = unit(rel(0.07), 'lines')
      )

print(p)
