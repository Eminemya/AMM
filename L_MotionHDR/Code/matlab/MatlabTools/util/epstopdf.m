function epstopdf(fileName)
% Assumes epstopdf in PATH

cmd = ['epstopdf --nocompress --gsopt="-dPDFSETTINGS=/prepress -dSubsetFonts=true -dEmbedAllFonts=true" ' fileName];
system(cmd);
