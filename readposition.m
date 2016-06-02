%Matlab????????

fd=fopen('POSCAR');
i=0;
a=[];
b=[];
while ~feof(fd)
    i=i+1;
    aline=fgetl(fd);
    if ((i>=9)&(i<=27)) 
      a=[a;str2num(aline)];
    end
    if(i==5)
        c=str2num(aline);c=c(3);
    end
end;
fclose(fd);

b=a(:,3);[b1,I]=sort(b);a(I(1:size(a,1)),:)

b=sort(a(:,3))'*c;
cha=b(2:size(b,2))-b(1:size(b,2)-1);
cha(1:2:length(cha))+cha(2:2:length(cha))