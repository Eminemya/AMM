function B = fullpath(A)

[d f e] = fileparts(A);
if isempty(d)
    d = cd;
else
    d = cd(cd(d));
end
B = fullfile(d, [f e]);
