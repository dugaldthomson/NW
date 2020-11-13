A = rand(5000);
disp('Access jumping around in memory');
tic
for i=1:5000
    for j=1:5000
        A(i,j);
    end
end
toc
disp('Access in linear order');
tic
for j=1:5000
    for i=1:5000
        A(i,j);
    end
end
toc