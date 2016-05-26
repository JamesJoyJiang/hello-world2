clear;
N_MgO=3;  
d_MgO_Fe= 2.04; a_MgO=2.13; a_trans= 2.87; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%copyfile('POSCAR',strcat('POSCAR_',num2str(N_fe(1)),'_',num2str(N_fe(2))) );

for iN=14:2:14
N_fe=[iN,iN-11]; %N_fe(1)=even  N_fe(2)=odd

copyfile('POSCAR',strcat('POSCAR_',num2str(N_fe(1))) );
bL=1.4*(0:N_fe(1)-1); 
bM= a_MgO*(0:N_MgO-1)+(N_fe(1)-1)*1.4+  d_MgO_Fe;
bR= 1.4*(0:N_fe(2)-1) + (N_MgO-1) *a_MgO +(N_fe(1)-1)*1.4  + 2* d_MgO_Fe;
%bR= 1.4*(0:N_fe(2)-1) +max(bM)+ d_MgO_Fe;
c=max(bR)+ 1.4; c=1; %c=1 Cartesian Coordinate
bL=bL/c; bR=bR/c; bM=bM/c; 


b_Fe_L=zeros(N_fe(1),2);b_Fe_R=ones(N_fe(2),2)*0.5* a_trans;
b_Fe_L(2:2:N_fe(1),:)=kron(ones(size(2:2:N_fe(1),2),1),[0.5,0.5]* a_trans); b_Fe_L(:,3)=bL';
b_Fe_R(2:2:N_fe(2),:)=kron(ones(size(2:2:N_fe(2),2),1),[0,0]);  b_Fe_R(:,3)=bR';

b_Mg=zeros(N_MgO,2);  b_O=zeros(N_MgO,2);
b_Mg(2:2:N_MgO,:)=kron(ones(size(2:2:N_MgO,2),1),[0.5,0.5]* a_trans);  b_Mg(:,3)=bM';
b_O(1:2:N_MgO,:)=kron(ones(size(1:2:N_MgO,2),1),[0.5,0.5]* a_trans);  b_O(:,3)=bM';


fd1=fopen('POSCAR');
fd=fopen(strcat('POSCAR_',num2str(N_fe(1))) ,'w+');
i=0;

while ~feof(fd1)&(i<=7)
    i=i+1;
  aline=fgetl(fd1);
  if (i==1)
      aline=strcat('Fe',num2str(sum(N_fe)),'Mg',num2str(sum(N_MgO)),'O',num2str(sum(N_MgO)));
  end
  
  if (i==8)
      aline='Cartesian'
  end;
  if (i==5)
      astr=str2num(aline);astr(3)=max(bR)+ 1.4; aline=num2str(astr);
  end;
   if (i==6)
     aline=' Fe   Mg   O ';
  end;
  if (i==7)
      aline=num2str([sum(N_fe),N_MgO,N_MgO]); 
  end;
  
  fprintf(fd,strcat(aline,'\n'));
end;
fclose(fd1);

 for i=1:size(b_Fe_L,1); fprintf(fd,' %4.3f   %4.3f   %4.3f  %1s %1s %1s \n ',b_Fe_L(i,:),'F','F','T'); end;
  for i=1:size(b_Fe_R,1); fprintf(fd,' %4.3f   %4.3f   %4.3f  %1s %1s %1s \n ',b_Fe_R(i,:),'F','F','T'); end;
   for i=1:size(b_Mg,1); fprintf(fd,' %4.3f   %4.3f   %4.3f  %1s %1s %1s \n ',b_Mg(i,:),'F','F','T'); end;
    for i=1:size(b_O,1); fprintf(fd,' %4.3f   %4.3f   %4.3f  %1s %1s %1s \n ',b_O(i,:),'F','F','T'); end;
 
%    fprintf(fd,' %4.3f   %4.3f   %4.3f \n',b_Fe_R');
%      fprintf(fd,' %4.3f   %4.3f   %4.3f \n',b_Mg');
%       fprintf(fd,' %4.3f   %4.3f   %4.3f \n',b_O');
%       
%       fseek(fd,10,-1);     ftell(fd) 
%       i=0;
%       while ~feof(fd)
%     i=i+1;
%     aline=fgetl(fd);
%      if (i>=8)
%        %  fseek(fd,20,0); 
%            ftell(fd) 
%     end
%    
%         end;


fclose(fd)
end;

