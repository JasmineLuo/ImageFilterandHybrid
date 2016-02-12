function output = my_imfilter_fft(image,cutoff_frequency)
% This function is intended to behave like the built in function imfilter()
% See 'help imfilter' or 'help conv2'. While terms like "filtering" and
% "convolution" might be used interchangeably, and they are indeed nearly
% the same thing, there is a difference:
% from 'help filter2'
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should work for color images. Simply filter each color
% channel independently.

% Your function should work for filters of any width and height
% combination, as long as the width and height are odd (e.g. 1, 7, 9). This
% restriction makes it unambigious which pixel in the filter is the center
% pixel.

% Boundary handling can be tricky. The filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% you look at 'help conv2' and 'help imfilter' you see that they have
% several options to deal with boundaries. You should simply recreate the
% default behavior of imfilter -- pad the input image with zeros, and
% return a filtered image which matches the input resolution. A better
% approach is to mirror the image content over the boundaries for padding.

% % Uncomment if you want to simply call imfilter so you can see the desired
% % behavior. When you write your actual solution, you can't use imfilter,
% % filter2, conv2, etc. Simply loop over all the pixels and do the actual
% % computation. It might be slow.

%--------remember to delete!!!!!--------------
%output = imfilter(image, filter); 
%--------only for comparison-------------------

%%%%%%%%%%%%%%%%
% there would be a choice to deal with edge.
B_method=input('how do you need to deal with edge: 1: pad with zero; 2: mirror the image\n');
% find color or gray image.
C_number=size(image,3);
% find the size of filter & one chanel of the image.
[i_w]=size(image,2);
[i_h]=size(image,1);


% decide for intensity and color picture
if C_number == 1
   
   image=squeeze(image);
   % add the edges 
   if B_method ==1
      %% initial edge for zero pad
      x_incre = (f_w-1)/2;
      y_incre = (f_h-1)/2;
      x_n=zeros(x_incre,i_h)';
      x_p=zeros(x_incre,i_h)';
      y_n=zeros(i_w+2*x_incre,y_incre)';
      y_p=zeros(i_w+2*x_incre,y_incre)';
      im_bound1=[x_n,image,x_p];
      im_bond=[y_p;im_bound1;y_n]; %the origin image+bond
      
   else % method=2 & channel=1
       %% initial edge for mirror boundary
      x_incre = (f_w-1)/2;
      y_incre = (f_h-1)/2;
      x_n=flip(image(:,1:x_incre),2);
      x_p=flip(image(:,i_w-x_incre+1:i_w),2);
      im_bound1=[x_n,image,x_p];
      y_p=flip(im_bound1(1:y_incre,:),1);
      y_n=flip(im_bound1(i_h-y_incre+1:i_h,:),1);
      im_bond=[y_p;im_bound1;y_n];
        %input channel 1 method2
   end 
           
      x_min=x_incre; %the range to exhert filter center
      y_min=y_incre;
      %x_max=x_incre+i_w;
      %y_max=y_incre+i_h;
      
      %start filtering
      out_im=zeros(i_w,i_h)';%resulting image
      
      for x_out=1:1:i_w       
          for y_out=1:1:i_h
              %deal with each filter scope
              x_cor=x_min+x_out;
              y_cor=y_min+y_out;
              scope=im_bond(x_cor-x_incre:x_cor+x_incre,y_cor-y_incre:y_cor+y_incre);
              value=sum(sum(scope.*filter));
              out_im(y_out,x_out)=value;  %% final out come of this session
          end  
      end 
    
else %channel=3
    %first split the channels
    R_ori=squeeze(image(:,1:i_h,1));
    G_ori=squeeze(image(:,1:i_h,2));
    B_ori=squeeze(image(:,1:i_h,3));
    
    %% apply FFT to three channels;
    
    R_FFT=fftshift(fft2(R_ori,i_h,i_h));
    G_FFT=fftshift(fft2(G_ori,i_h,i_h));
    B_FFT=fftshift(fft2(B_ori,i_h,i_h));
    
    
    filter_FFT=fspecial('Gaussian',i_h,cutoff_frequency);%%it is a problem that the relationship Gaussians of different domain
%     Pe=max(max(mask));
%     filter_FFT=mask./Pe;
      
    output(:,:,1)=abs(ifft2(R_FFT.*filter_FFT,i_h,i_h));
    output(:,:,2)=abs(ifft2(G_FFT.*filter_FFT,i_h,i_h));
    output(:,:,3)=abs(ifft2(B_FFT.*filter_FFT,i_h,i_h));

end


