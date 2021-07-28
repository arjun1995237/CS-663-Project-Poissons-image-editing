function [edited_image,sourceOnlyOnTarget,sourcePlusDomegaOnTarget,maskSourceOnlyAllignedTarget]=preprocessing(image,source,iter=100,mix_grad=0);
  pkg load image;
  image=double(image)./255.0;
  source=double(source)./255.0;
  strel=[0 1 0;1 1 1;0 1 0];#structuring element for morphological erosion 
  [m_source,n_source,_]=size(source);
  [m_image,n_image,_]=size(image);
  sourcePlusDomegaOnTarget=zeros(size(image));
  if mod(m_source,2)==0
    new=zeros(m_source+1,n_source,3);
    new(1:m_source,1:n_source,:)=source;
    source=new;
    [m_source,n_source,_]=size(source);
  endif
  if mod(n_source,2)==0
    new2=zeros(m_source,n_source+1,3);
    new2(1:m_source,1:n_source,:)=source;
    source=new2;
    [m_source,n_source,_]=size(source);
  endif
  [m_source,n_source,_]=size(source);
  m_center=((m_source+1)/2);
  n_center=((n_source+1)/2);
  
  figure(1);
  imshow(image,[0 1]);
  title("Target image");
  figure(2);
  imshow(source,[0 1]);
  title("source image");
  figure(1);
  title("where do you want to place your object for seamless cloning??");
  [x,y,button]=ginput(1)
  y=round(y);
  x=round(x);
  
  sourcePlusDomegaOnTarget((y-m_center+1):(y+m_center-1),(x-n_center+1):(x+n_center-1),:)=source;#needed for computation
  sourceOnlyOnTarget=imerode(sourcePlusDomegaOnTarget,strel);
 disp("erosion_done");
  gray=rgb2gray(sourceOnlyOnTarget);
  maskSourceOnlyAllignedTarget=gray>0;
  ################
  gray2=rgb2gray(sourcePlusDomegaOnTarget);
  big_mask=gray2>0;
  d_omegaRegion=big_mask-maskSourceOnlyAllignedTarget;
  figure(4);
  imshow(d_omegaRegion);
  title("d_omega region");
  x=input("Press Enter to start");
  #################
  figure(5);
  imshow(maskSourceOnlyAllignedTarget);
  title("mask corresponding to omega");
  x=input("Press Enter to start");
  ####Ext
  maskBits_vector=maskSourceOnlyAllignedTarget(:);
  length_maskBitsVector=length(maskBits_vector)
  index=[1:length_maskBitsVector]';
  indexMaskedRegion=index.*maskBits_vector;
  indexMaskedRegion(indexMaskedRegion==0)=[];
  
  newLengthOfSourceIndex=length(indexMaskedRegion)
  x=input("Press Enter to start");
  A=zeros(newLengthOfSourceIndex,newLengthOfSourceIndex);
  X=zeros(newLengthOfSourceIndex,3);
  b=zeros(newLengthOfSourceIndex,3);
  x=input("Press Enter to start");
  for idx=1:newLengthOfSourceIndex#this loop considers elements within omega& neighbour can be in d_omega too
    index_val=indexMaskedRegion(idx,1);
    x_cord=floor(((index_val-1)/m_image)+1);
    y_cord=mod(index_val-1,m_image)+1;
    if mix_grad==0
    g1=double(4*sourcePlusDomegaOnTarget(y_cord,x_cord,1)-sourcePlusDomegaOnTarget(y_cord-1,x_cord,1)-sourcePlusDomegaOnTarget(y_cord+1,x_cord,1)-sourcePlusDomegaOnTarget(y_cord,x_cord-1,1)-sourcePlusDomegaOnTarget(y_cord,x_cord+1,1));
    g2=double(4*sourcePlusDomegaOnTarget(y_cord,x_cord,2)-sourcePlusDomegaOnTarget(y_cord-1,x_cord,2)-sourcePlusDomegaOnTarget(y_cord+1,x_cord,2)-sourcePlusDomegaOnTarget(y_cord,x_cord-1,2)-sourcePlusDomegaOnTarget(y_cord,x_cord+1,2));
    g3=double(4*sourcePlusDomegaOnTarget(y_cord,x_cord,3)-sourcePlusDomegaOnTarget(y_cord-1,x_cord,3)-sourcePlusDomegaOnTarget(y_cord+1,x_cord,3)-sourcePlusDomegaOnTarget(y_cord,x_cord-1,3)-sourcePlusDomegaOnTarget(y_cord,x_cord+1,3));
  elseif mix_grad==1 
    g_=[0 0 0]';
   for i=1:3
  
  if abs(sourcePlusDomegaOnTarget(y_cord,x_cord,i)-sourcePlusDomegaOnTarget(y_cord-1,x_cord,i))>abs(image(y_cord,x_cord,i)-image(y_cord-1,x_cord,i))
    g_(i,1)+=sourcePlusDomegaOnTarget(y_cord,x_cord,i)-sourcePlusDomegaOnTarget(y_cord-1,x_cord,i);
  else
    g_(i,1)+=image(y_cord,x_cord,i)-image(y_cord-1,x_cord,i);  
  endif
  if abs(sourcePlusDomegaOnTarget(y_cord,x_cord,i)-sourcePlusDomegaOnTarget(y_cord+1,x_cord,i))>abs(image(y_cord,x_cord,i)-image(y_cord+1,x_cord,i))
    g_(i,1)+=sourcePlusDomegaOnTarget(y_cord,x_cord,i)-sourcePlusDomegaOnTarget(y_cord+1,x_cord,i);
  else
    g_(i,1)+=image(y_cord,x_cord,i)-image(y_cord+1,x_cord,i);  
  endif
  
   if abs(sourcePlusDomegaOnTarget(y_cord,x_cord,i)-sourcePlusDomegaOnTarget(y_cord,x_cord-1,i))>abs(image(y_cord,x_cord,i)-image(y_cord,x_cord-1,i))
    g_(i,1)+=sourcePlusDomegaOnTarget(y_cord,x_cord,i)-sourcePlusDomegaOnTarget(y_cord,x_cord-1,i);
  else
    g_(i,1)+=image(y_cord,x_cord,i)-image(y_cord,x_cord-1,i);  
  endif
   if abs(sourcePlusDomegaOnTarget(y_cord,x_cord,i)-sourcePlusDomegaOnTarget(y_cord,x_cord+1,i))>abs(image(y_cord,x_cord,i)-image(y_cord,x_cord+1,i))
    g_(i,1)+=sourcePlusDomegaOnTarget(y_cord,x_cord,i)-sourcePlusDomegaOnTarget(y_cord,x_cord+1,i);
  else
    g_(i,1)+=image(y_cord,x_cord,i)-image(y_cord,x_cord+1,i);  
  endif
  endfor
  g1=g_(1,1);
  g2=g_(2,1);
  g3=g_(3,1);
else
  disp("error!!!!!!!!!!!!!");
  break;
endif  
  g=[g1 g2 g3];
   b(idx,:)=[0 0 0];#
    A(idx,idx)=4;
    if maskSourceOnlyAllignedTarget(y_cord,x_cord+1)==1
      pos=(x_cord)*m_image+y_cord;
      t=find(indexMaskedRegion==pos);
      A(idx,t)=-1;
    else
      b(idx,:)+=[image(y_cord,x_cord+1,1) image(y_cord,x_cord+1,2) image(y_cord,x_cord+1,3)];
       
  endif
  
  if maskSourceOnlyAllignedTarget(y_cord,x_cord-1)==1
      pos=(x_cord-2)*m_image+y_cord;
      t=find(indexMaskedRegion==pos);
      A(idx,t)=-1;
    else
      b(idx,:)+=[image(y_cord,x_cord-1,1) image(y_cord,x_cord-1,2) image(y_cord,x_cord-1,3)];
  endif
  
  if maskSourceOnlyAllignedTarget(y_cord+1,x_cord)==1
      pos=(x_cord-1)*m_image+y_cord+1;
      t=find(indexMaskedRegion==pos);
      A(idx,t)=-1;
    else
      b(idx,:)+=[image(y_cord+1,x_cord,1) image(y_cord+1,x_cord,2) image(y_cord+1,x_cord,3)];
  endif
  
  if maskSourceOnlyAllignedTarget(y_cord-1,x_cord)==1
      pos=(x_cord-1)*m_image+y_cord-1;
      t=find(indexMaskedRegion==pos);
      A(idx,t)=-1;
    else
       b(idx,:)+=[image(y_cord-1,x_cord,1) image(y_cord-1,x_cord,2) image(y_cord-1,x_cord,3)];
    endif
    
    
    b(idx,:)=b(idx,:)+g;
    disp("wait!");
  
endfor

#sloving linear equations
 disp("--------------------solving--------------------");
X(:,1)=pcg(A,b(:,1),0.000000001,iter);
 disp("--------------------solving--------------------");
X(:,2)=pcg(A,b(:,2),0.000000001,iter);
 disp("--------------------solving--------------------");
X(:,3)=pcg(A,b(:,3),0.000000001,iter);

edited_image=image;

 for idx=1:newLengthOfSourceIndex#this loop considers elements within omega& neighbour can be in d_omega too
    index_val=indexMaskedRegion(idx,1);
    x_cord=floor(((index_val-1)/m_image)+1);
    y_cord=mod(index_val-1,m_image)+1;
    edited_image(y_cord,x_cord,1)=X(idx,1);
    edited_image(y_cord,x_cord,2)=X(idx,2);
    edited_image(y_cord,x_cord,3)=X(idx,3);
   endfor
   figure(6);
   imshow(edited_image,[0 1]);
   title("edited image");

endfunction
