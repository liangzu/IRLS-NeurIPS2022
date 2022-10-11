library(R.matlab);
library(ggplot2);
library(tikzDevice);
options(tz="CA");
options(tikzDocumentDeclaration = "\\documentclass[12pt]{article}");


fn = sprintf("../experiments/experiment_LpRR_convergence_noisy.mat");

res = readMat(fn);

num_iters = seq(from=1, to=10, by=1);

num= 10;

errors_IRLS1 = res$mean.errors.IRLS1[1,1:num];
errors_IRLS05 = res$mean.errors.IRLS05[1,1:num];
errors_IRLS01 = res$mean.errors.IRLS01[1,1:num];


errors = c(errors_IRLS1, errors_IRLS05, errors_IRLS01);


xbreaks=c(2, 4, 6, 8, 10);
xlabels=c("$2$","$4$","$6$", "$8$", "$10$");


name_IRLS1 = "$\\texttt{IRLS}_{1}$";
name_IRLS05 = "$\\texttt{IRLS}_{0.5}$";
name_IRLS01 = "$\\texttt{IRLS}_{0.1}$";


groups = factor(c(rep(name_IRLS1, num), rep(name_IRLS05, num), rep(name_IRLS01, num)),
                  levels=c(name_IRLS1, name_IRLS05, name_IRLS01));

linewidth = c(rep(c(0.5, 0.5, 0.5), num));
fill_values = c("red", "red", "red");
shape_values = c(22, 24, 21);
size_values = c(rep(c(rel(1.3), rel(1.3), rel(1.3)), num));

tex_path = sprintf("../../61f87e85d1b475ca03d2c008/figures/experimentLpRR_convergence_noisy.tex");


dat = data.frame(num_iters, errors, groups);

tikz(file=tex_path, height=1.55, width=1.85);

p = ggplot(data=dat, mapping=aes(x=num_iters,y=errors, fill=groups,shape=groups)) +

     geom_line(size=linewidth) +
     geom_point(mapping=aes(size=groups)) +

     scale_shape_manual(values=shape_values) +
     scale_fill_manual(values=fill_values) +
     scale_size_manual(values=size_values) +

     # scale_y_continuous(breaks=c(0, 0.25, 0.5, 0.75, 1), labels=c("$0\\%$", "$25\\%$", "$50\\%$", "$75\\%$", "$100\\%$")) +
     scale_y_continuous(trans="log10", breaks=c(1e-1, 1e-2, 1e-4, 5e-4),
                                       labels=c("1E-1", "1E-2", "1E-4", "5E-4") ) +

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
         legend.position=c(0.72,0.72), # legend.position = "none",
         legend.spacing.x=unit(rel(0.18),"lines"), legend.key.size = unit(rel(0.07), 'lines')
      )

print(p)
