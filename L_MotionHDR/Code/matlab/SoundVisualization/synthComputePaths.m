function [ particleListPath ] = synthComputePaths( particleList, t, soundFunction, amp)


    for k = 1:size(particleList,2)
        
       [~, path2] = ode113(soundFunction, t, [particleList(1,k) particleList(2,k)]);
       path2 = bsxfun(@plus, amp*bsxfun(@minus,path2,path2(1,:)), path2(1,:));
       particleListPath(:,:,k) = path2;
       
    end
end

