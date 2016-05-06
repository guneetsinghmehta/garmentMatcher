function[]=genEg2Trash(acc1,string)
    figure;
    imagesc(acc1);
    title(string);
    xlabel('green->red');
    ylabel('blue->yellow');
    colorbar;
end