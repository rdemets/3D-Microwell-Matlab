clc;
clear all;
close all;


pathin='/Academic/Academics/Epithelial Polarity/Data/140326 E-Cad edge-Analyzed/130326 Wall/2h_E-cad ProA_024-1_a10.tif'; 
dx = 24.61;

a = imread(pathin);
% a_corr = abs(a - 1.2293e+04);
[p q] = size(a);
b = mean(a')/2;
c = max(b);
[i j] = max(b);
final = p - j;
height = final/dx;






