function [objects, classes] = extract_obj_fun(file,N,n_objs)

objects = struct();
classes = {};
L = 4e8;

if n_objs == 1
    t_shift = N;
else
    t_shift = floor((L-N)/(n_objs - 1));
end

if t_shift > N
    t_shift = N;
end

if t_shift < 1 
    error('extract_obj_fun: Too large n_objs');
end

path_str = fileparts(file);
path_parts = regexp(path_str,filesep,'split');
cname = path_parts{end};

for n=1:n_objs
    objects(n).u1 = 1 + (n-1)*t_shift;
    objects(n).u2 = (n-1)*t_shift + N;
    classes{n} = cname;
end