function [list] = outlierFinderFunc(data,dataSize,Length,Point,trs)
list=[];
peak=find(data(1,:,1)==Point);

i=0;b=0;counter=0;Gx=0;Gy=0;
img(Gy+1,Gx+1)=data(1,peak,2);
if data(1,peak,2)<trs
    list(end +1)= 1;
end

while i<dataSize
    a=mod(b,4);
    if(a==0)
        for i=counter*(Length+1)+2:(counter+1)*(Length+1)
            Gx=Gx+1;
            img(Gy+1,Gx+1)=data(i,peak,2);
            if data(i,peak,2)<trs
                list(end +1)= i;
            end
        end
        b=b+1;counter=counter+1;
    end
    if(a==1||a==3)
        i=counter*(Length+1)+1;
        Gy=Gy+1;
        img(Gy+1,Gx+1)=data(i,peak,2);
        b=b+1;
        if data(i,peak,2)<trs
            list(end + 1)= i;
        end
    end
    if(a==2)
        for i=counter*(Length+1)+2:(counter+1)*(Length+1)
            Gx=Gx-1;
            img(Gy+1,Gx+1)=data(i,peak,2);
            if data(i,peak,2)<trs
                list(end +1)= i;
            end
        end
        b=b+1;counter=counter+1;
    end
end
figure
colormap("gray")
imagesc(img);
figure,surf(1:size(img,1),1:size(img,2),img);

i=0;b=0;counter=0;Gx=0;Gy=0;
img(Gy+1,Gx+1)=data(1,peak,2);

while i<dataSize
    a=mod(b,4);
    if(a==0)
        for i=counter*(Length+1)+2:(counter+1)*(Length+1)
            Gx=Gx+1;
            if data(i,peak,2)<trs
                img(Gy+1,Gx+1)=0;
            else
                img(Gy+1,Gx+1)=data(i,peak,2);
            end
        end
        b=b+1;counter=counter+1;
    end
    if(a==1||a==3)
        i=counter*(Length+1)+1;
        Gy=Gy+1;
        if data(i,peak,2)<trs
            img(Gy+1,Gx+1)=0;
        else
            img(Gy+1,Gx+1)=data(i,peak,2);
        end
        b=b+1;
    end
    if(a==2)
        for i=counter*(Length+1)+2:(counter+1)*(Length+1)
            Gx=Gx-1;
            if data(i,peak,2)<trs
                img(Gy+1,Gx+1)=0;
            else
                img(Gy+1,Gx+1)=data(i,peak,2);
            end
        end
        b=b+1;counter=counter+1;
    end
end
figure
colormap("gray")
imagesc(img);
figure,surf(1:size(img,1),1:size(img,2),img);
end