library(R.matlab);
library(ggplot2);
library(tikzDevice);
options(tz="CA");
options(tikzDocumentDeclaration = "\\documentclass[12pt]{article}");


fn = sprintf("../experiments/experiment_L1RR.mat");

res = readMat(fn);

num_iters = seq(from=5, to=50, by=5);

num=10;

errors_IRLSp = res$mean.errors.IRLSp[1,1:num];

errors_vanilla001 = res$mean.errors.vanilla.001[1,1:num];
errors_vanilla01 = res$mean.errors.vanilla.01[1,1:num];
errors_vanilla1 = res$mean.errors.vanilla.1[1,1:num];

errors_DDFG2010 = res$mean.errors.DDFG2010[1,1:num];

errors_MGJK2019 = res$mean.errors.MGJK2019[1,1:num];

errors = c(errors_IRLSp, errors_vanilla001, errors_vanilla01, errors_vanilla1,
           errors_DDFG2010, errors_MGJK2019);

xbreaks=c(5, 10, 20, 30, 40, 50);
xlabels=c("$5$","$10$","$20$", "$30$", "$40$", "$50$");


name_IRLSp = "\\cite{Kummerle-NeurIPS2021} (\\ref{eq:update-Kummerle})"

name_vanilla001 = "IRLS ($\\epsilon$=1E-5)"
name_vanilla01 = "IRLS ($\\epsilon$=1E-10)"
name_vanilla1 = "IRLS ($\\epsilon$=1E-15)"

name_DDFG2010 = "\\cite{Daubechies-CPAM2010} (\\ref{eq:update-Daubechies})"

name_MGJK2019 = "\\cite{Mukhoty-AISTATS2019}"

groups = factor(c(rep(name_IRLSp, num),
                  rep(name_vanilla001, num), rep(name_vanilla01, num), rep(name_vanilla1, num),
                  rep(name_DDFG2010, num),
                  rep(name_MGJK2019, num)),
                  levels=c(name_MGJK2019, name_DDFG2010,
                   name_IRLSp, name_vanilla001, name_vanilla01, name_vanilla1));

linewidth = c(rep(c(0.5, 0.5, 0.5, 0.5, 0.5, 0.5), num));
fill_values = c("gray", "steelblue", "red", "gray", "steelblue", "steelblue");
shape_values = c(21, 24, 22, 0, 1, 2);
size_values = c(rep(c(rel(1.3), rel(1.3), rel(1.3), rel(0.9),  rel(0.9), rel(2.05)), num));

tex_path = sprintf("../../61f87e85d1b475ca03d2c008/figures/experimentL1RR.tex");


dat = data.frame(num_iters, errors, groups);

tikz(file=tex_path, height=1.55, width=1.85);

p = ggplot(data=dat, mapping=aes(x=num_iters,y=errors, fill=groups,shape=groups)) +

     geom_line(size=linewidth) +
     geom_point(mapping=aes(size=groups)) +

     scale_shape_manual(values=shape_values) +
     scale_fill_manual(values=fill_values) +
     scale_size_manual(values=size_values) +

     # scale_y_continuous(breaks=c(0, 0.25, 0.5, 0.75, 1), labels=c("$0\\%$", "$25\\%$", "$50\\%$", "$75\\%$", "$100\\%$")) +
     scale_y_continuous(trans="log10", breaks=c(1, 1e-2, 1e-5, 1e-16),
                                       labels=c("1", "$10^{-2}$", "$10^{-5}$", "$10^{-16}$") ) +

     # scale_y_continuous(trans="log10", breaks=scales::trans_breaks('log10', function(x) 10^x),
     #                                   labels=scales::trans_format('log10', scales::math_format(10^.x))) +
     scale_x_continuous(breaks = xbreaks, labels = xlabels) +

     labs(x="Number of Iterations",y="Relative Error") +

     theme(axis.text=element_text(face="plain", size=rel(0.8), color='gray10'),
         legend.text=element_text(face="plain",size=rel(0.75), family="mono"),
         # legend.text=element_blank(),
         plot.title=element_blank(),
         title=element_text(face="plain",size=rel(0.75), color='gray10'),
         axis.title.y=element_text(face="plain",size=rel(1.23), color='gray10'),
         axis.title.x=element_text(face="plain",size=rel(1.23), color='gray10'),
         panel.border = element_blank(),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         legend.background=element_blank(),
         legend.key=element_blank(),
         legend.margin = margin(0.4,2,0.4,1),
         legend.title=element_blank(),
         legend.position=c(0.13,0.42), # legend.position = "none",
         legend.spacing.x=unit(rel(0.18),"lines"), legend.key.size = unit(rel(0.07), 'lines')
      )

print(p)
