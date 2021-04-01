function [list] = tripleOutlierFinderFunc(data,dataSize,Length,Point1,Point2,Point3,trs1,trs2,trs3)
list=[];
peak1=find(data(1,:,1)==Point1);
peak2=find(data(1,:,1)==Point2);
peak3=find(data(1,:,1)==Point3);

i=0;b=0;counter=0;Gx=0;Gy=0;
if data(1,peak1,2)<trs1
    list(end +1)= 1;
    img(Gy+1,Gx+1)=0;
elseif data(1,peak2,2)<trs2
    list(end +1)= 1;
    img(Gy+1,Gx+1)=0;
elseif data(1,peak3,2)<trs3
    list(end +1)= 1;
    img(Gy+1,Gx+1)=0;
else
    img(Gy+1,Gx+1)=data(1,peak1,2);
end

while i<dataSize
    a=mod(b,4);
    if(a==0)
        for i=counter*(Length+1)+2:(counter+1)*(Length+1)
            Gx=Gx+1;
            if data(i,peak1,2)<trs1
                list(end +1)= i;
                img(Gy+1,Gx+1)=0;
            elseif data(i,peak2,2)<trs2
                list(end +1)= i;
                img(Gy+1,Gx+1)=0;
            elseif data(i,peak3,2)<trs3
                list(end +1)= i;
                img(Gy+1,Gx+1)=0;
            else
                img(Gy+1,Gx+1)=data(i,peak1,2);
            end
        end
        b=b+1;counter=counter+1;
    end
    if(a==1||a==3)
        i=counter*(Length+1)+1;
        Gy=Gy+1;
        if data(i,peak1,2)<trs1
            list(end +1)= i;
            img(Gy+1,Gx+1)=0;
        elseif data(i,peak2,2)<trs2
                list(end +1)= i;
                img(Gy+1,Gx+1)=0;
        elseif data(i,peak3,2)<trs3
                list(end +1)= i;
                img(Gy+1,Gx+1)=0;        
        else
            img(Gy+1,Gx+1)=data(i,peak1,2);
        end
        b=b+1;
    end
    if(a==2)
        for i=counter*(Length+1)+2:(counter+1)*(Length+1)
            Gx=Gx-1;
            if data(i,peak1,2)<trs1
                list(end +1)= i;
                img(Gy+1,Gx+1)=0;
            elseif data(i,peak2,2)<trs2
                list(end +1)= i;
                img(Gy+1,Gx+1)=0; 
            elseif data(i,peak3,2)<trs3
                list(end +1)= i;
                img(Gy+1,Gx+1)=0; 
            else
                img(Gy+1,Gx+1)=data(i,peak1,2);
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