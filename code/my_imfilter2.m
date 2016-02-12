function output = my_imfilter2(image, filter)
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
[f_w]=size(filter,2);
[f_h]=size(filter,1);
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
      x_incre = (f_w-1)/2;  %f_w is the width of filter matrix
      y_incre = (f_h-1)/2;  %f_h is the height of filter matrix
      x_n=flip(image(:,1:x_incre),2); 
      x_p=flip(image(:,i_w-x_incre+1:i_w),2); % increased bounding on width direction
      im_bound1=[x_n,image,x_p];
      y_p=flip(im_bound1(1:y_incre,:),1);
      y_n=flip(im_bound1(i_h-y_incre+1:i_h,:),1); %incresed bounding on height direction
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
          for y_out=1:1:i_h % x_out and y_out is the coordinate of current pixel.
              x_cor=x_min+x_out;
              y_cor=y_min+y_out;
              scope=im_bond(x_cor-x_incre:x_cor+x_incre,y_cor-y_incre:y_cor+y_incre);
              %scope is the segmented part of image matrix(with padding)within the range of filter 
              value=sum(sum(scope.*filter));
              %use dot product instead of two for loop
              out_im(y_out,x_out)=value;  %% final out come of this session
          end %i_h is the hight of origin image(without padding)
      end % i_w is the width of origin image(without padding)
    
else %channel=3
    %first split the channels
    R_ori=squeeze(image(:,:,1));
    G_ori=squeeze(image(:,:,2));
    B_ori=squeeze(image(:,:,3));
    
    %decide measure for edges
    if B_method ==1 %channel 3 method 1
      %% initial zero pad boundary
      x_incre = (f_w-1)/2;
      y_incre = (f_h-1)/2;
      x_n=zeros(x_incre,i_h)';
      x_p=zeros(x_incre,i_h)';
      y_n=zeros(i_w+2*x_incre,y_incre)';
      y_p=zeros(i_w+2*x_incre,y_incre)';
      
      rm_bound1=[x_n,R_ori,x_p];
      rm_bond=[y_p;rm_bound1;y_n]; %the origin image+bond
            
      gm_bound1=[x_n,G_ori,x_p];
      gm_bond=[y_p;gm_bound1;y_n]; %the origin image+bond
      
      bm_bound1=[x_n,B_ori,x_p];
      bm_bond=[y_p;bm_bound1;y_n]; %the origin image+bond
      
    else % method=2 & channel=3
      x_incre = (f_w-1)/2;
      y_incre = (f_h-1)/2;
      
      x_r_n=flip(R_ori(:,1:x_incre),2);
      x_r_p=flip(R_ori(:,i_w-x_incre+1:i_w),2);
      rm_bound1=[x_r_n,R_ori,x_r_p];
      y_r_p=flip(rm_bound1(1:y_incre,:),1);
      y_r_n=flip(rm_bound1(i_h-y_incre+1:i_h,:),1);
      rm_bond=[y_r_p;rm_bound1;y_r_n];     % mirror for red 
      
      x_g_n=flip(G_ori(:,1:x_incre),2);
      x_g_p=flip(G_ori(:,i_w-x_incre+1:i_w),2);
      gm_bound1=[x_g_n,G_ori,x_g_p];
      y_g_p=flip(gm_bound1(1:y_incre,:),1);
      y_g_n=flip(gm_bound1(i_h-y_incre+1:i_h,:),1);
      gm_bond=[y_g_p;gm_bound1;y_g_n];     % mirror for green 
      
      x_b_n=flip(B_ori(:,1:x_incre),2);
      x_b_p=flip(B_ori(:,i_w-x_incre+1:i_w),2);
      bm_bound1=[x_b_n,B_ori,x_b_p];
      y_b_p=flip(bm_bound1(1:y_incre,:),1);
      y_b_n=flip(bm_bound1(i_h-y_incre+1:i_h,:),1);
      bm_bond=[y_b_p;bm_bound1;y_b_n];     % mirror for blue
   end 
      
      %% For RED channel
      x_min=x_incre; %the range to exhert filter center
      y_min=y_incre;
      %x_max=x_incre+i_w;
      %y_max=y_incre+i_h;
      
      %start filtering
      out_rm=zeros(i_w,i_h)';%resulting image for RED channel
      
      for x_out=1:1:i_w       
          for y_out=1:1:i_h
              %deal with each filter scope
              x_cor=x_min+x_out;
              y_cor=y_min+y_out;
              scope=rm_bond(y_cor-y_incre:y_cor+y_incre,x_cor-x_incre:x_cor+x_incre);
              value=sum(sum(scope.*filter));
              out_rm(y_out,x_out)=value;
          end  
      end 
      % RED channel END
      
      %% for GREEN channel
               
      x_min=x_incre; %the range to exhert filter center
      y_min=y_incre;
      %x_max=x_incre+i_w;
      %y_max=y_incre+i_h;
      
      %start filtering
      out_gm=zeros(i_w,i_h)';%resulting image for RED channel
      
      for x_out=1:1:i_w       
          for y_out=1:1:i_h
              %deal with each filter scope
              x_cor=x_min+x_out;
              y_cor=y_min+y_out;
              scope=gm_bond(y_cor-y_incre:y_cor+y_incre,x_cor-x_incre:x_cor+x_incre);
              value=sum(sum(scope.*filter));
              out_gm(y_out,x_out)=value;
          end  
      end 
      % GREEN channel END
      
      %% for BLUE channel
            
      x_min=x_incre; %the range to exhert filter center
      y_min=y_incre;
      %x_max=x_incre+i_w;
      %y_max=y_incre+i_h;
      
      %start filtering
      out_bm=zeros(i_w,i_h)';%resulting image for RED channel
      
      for x_out=1:1:i_w       
          for y_out=1:1:i_h
              %deal with each filter scope
              x_cor=x_min+x_out;
              y_cor=y_min+y_out;
              scope=bm_bond(y_cor-y_incre:y_cor+y_incre,x_cor-x_incre:x_cor+x_incre);
              value=sum(sum(scope.*filter));
              out_bm(y_out,x_out)=value;
          end  
      end 
      % BLUE channel END
      %% merge the three channels together.
      out_im(:,:,1)=out_rm;
      out_im(:,:,2)=out_gm;
      out_im(:,:,3)=out_bm;
      %end for method1 channel 3
      
end
output=out_im;
%%%%%%%%%%%%%%%%





