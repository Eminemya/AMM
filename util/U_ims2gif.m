function U_ims2gif(volume,videoname,gframe,delaytime,resizeRate,height)

if exist('delaytime','var')~=1
    delaytime=0.3;
end
if exist('resizeRate','var')~=1
    resizeRate=1;
end
if exist('height','var')~=1
    height=0;
end
if exist('gframe','var')~=1
    gframe=0;
end
tmp_sz=size(volume);

nframes=tmp_sz(end);
volume(isnan(volume))=0;
for i=1:nframes
    if(numel(tmp_sz)==4)
        im=volume(:,:,:,i);
    else
        if gframe            
            clf
            imagesc(volume(:,:,i)),axis off,axis equal,axis tight
            if gframe==2
                colorbar
            end
            F=getframe;
            im=F.cdata;
        else
            im=volume(:,:,i);
        end
    end
    if height~=0
        [h,w,nchannels]=size(im);
        resizeRate=height/h;
    end
    if resizeRate<1
        im=imresize(imfilter(im,fspecial('gaussian',5,0.7),'same','replicate'),resizeRate,'bicubic');
    else if resizeRate>1
            im=imresize(im,resizeRate,'bicubic');
        end
    end
    
    if(numel(size(im))==3)
        [X,map]=rgb2ind(im,256);
    else
        [X,map]=gray2ind(im);
    end
    if i==1
        imwrite(X,map,videoname,'DelayTime',delaytime,'LoopCount',Inf);
    else
        imwrite(X,map,videoname,'WriteMode','append','DelayTime',delaytime);
    end
end
