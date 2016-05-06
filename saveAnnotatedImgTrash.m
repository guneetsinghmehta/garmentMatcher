function annotated_img = saveAnnotatedImgTrash(fh)
figure(fh); 
set(fh, 'WindowStyle', 'normal');
img = getimage(fh);
truesize(fh, [size(img, 1), size(img, 2)]);
frame = getframe(fh);
frame = getframe(fh);
pause(0.5); 
annotated_img = frame.cdata;
end