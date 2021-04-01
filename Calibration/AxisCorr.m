function [AxisCorrX,AxisCorrInt] = AxisCorr(dataSize,input)
wn1 = -87; wn2 = 2763;

for a=1:dataSize
    clc;
    disp(strcat("Axis correction: ",int2str((a/dataSize)*100),"%"));
    inp(:,2)=input(a,:,2);
    inp(:,1)=input(a,:,1);
    
    vm = inp(:,1);
    intensity = inp(:,2:size(inp,2));
    [n,p] = size(intensity);
    
    % start = min(vm(1,:)); start = round(start);
    start = wn1;
    % fin = max(vm(size(vm,1),:));
    fin = wn2;
    im =(start:fin)';
    
    
    [k,~] = size(im);
    t = intensity';
    
    for i=1:k
        dist = (vm-(repmat(im(i,:),n,1))).^2;
        [sortval, sortpos] = sort(dist,'ascend');
        xDist(:,i) = sqrt(sortval(1:2));
        s(:,i) = sortpos(1:2,:);
        prop(:,i) = xDist(1,i)/(xDist(2,i)+xDist(1,i));
    end
    
    for j= 1:p
        for i=1:k
            newInt(j,i) = prop(i)*(t(j,s(2,i))-t(j,s(1,i)))+t(j,s(1,i));
        end
    end
    
    
    [w1,~] = find(im == wn1); [w2, ~] =  find(im == wn2);
    AxisCorrInt(a,:) = newInt(:,w1:w2);
    AxisCorrX(a,:) = im(w1:w2,:)';
end