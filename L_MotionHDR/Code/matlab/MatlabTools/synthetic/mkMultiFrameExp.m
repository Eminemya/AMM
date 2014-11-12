%wx has dimension mx1
%p has dimensions mxt where t is number of frames

function [ out] = mkMultiFrameExp( N,wx,wy,p )
    T = size(p,2);
    out = zeros(N,N,1,T);
   


    for frame = 1:T
       out(:,:,1,frame) = mkMultiExp(N,wx,wy,p(:,frame));
    end


end

