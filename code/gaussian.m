%show frequency image of given filter
cutoff_frequency1=7;
filter1 = fspecial('Gaussian', cutoff_frequency1*4+1, cutoff_frequency1);
FFT1=abs(fftshift(fft2(filter1,100,100)));
figure(1); 
imshow(FFT1);
%imwrite('cutoff=7');

cutoff_frequency2=4;
filter2 = fspecial('Gaussian', cutoff_frequency2*4+1, cutoff_frequency2);
FFT2=abs(fftshift(fft2(filter2,100,100)));
figure(2); 
imshow(FFT2);
%imwrite('cutoff=4');

cutoff_frequency3=10;
filter3 = fspecial('Gaussian', cutoff_frequency3*4+1, cutoff_frequency3);
FFT3=abs(fftshift(fft2(filter3,100,100)));
figure(3); 
imshow(FFT3);
%imwrite('cutoff=10');

cutoff_frequency4=4.5;
filter4 = fspecial('Gaussian', cutoff_frequency4*4+1, cutoff_frequency4);
FFT4=abs(fftshift(fft2(filter4,100,100)));
figure(4); 
imshow(FFT4);
%imwrite('cutoff=4.5');

cutoff_frequency5=5;
filter5 = fspecial('Gaussian', cutoff_frequency5*4+1, cutoff_frequency5);
FFT5=abs(fftshift(fft2(filter5,100,100)));
figure(5); 
imshow(FFT5);
%imwrite('cutoff=5');