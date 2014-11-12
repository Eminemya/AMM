function [ particleListPath ] = synthComputePaths2( particleList, t, soundFunction, amp)


    for k = 1:size(particleList,2)
       for j = 1:numel(t)
           path2(:,j) = soundFunction(t(j), [particleList(1,k), particleList(2,k)]);
       end
       path2 = cumtrapz(t, path2, 2);
       for i = 1:2
           path2(i,:) = path2(i,:) + particleList(i,k);
       end
       
       path2 = bsxfun(@plus, amp*bsxfun(@minus,path2,path2(1,:)), path2(1,:));
       particleListPath(:,:,k) = path2';
       
    end
end

