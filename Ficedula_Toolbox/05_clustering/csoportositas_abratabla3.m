function [P3 P3_2]=csoportositas_abratabla3(data,matrix,sylls,row)
%clear
%clc
%sylls=1:10;
%load data
%load matrix

data=data(sylls);
matrix=matrix(sylls,:);

%row=2;
[u1, u2, u3]=unique([data.rows]);
%if u1>2
%specrow=max(u1);
%end
specrow=data(1).rows(1);

syllnum=length(data);
n=0;
P0=[];
n1=0;
P3=[];%zeros(specrow*row,50);
P3_2=[];%zeros(specrow*row,50);
while n<syllnum
    
    %     clear s1
    %     for i=1:row
    %         if n+i-1<syllnum
    %             s1(i,1:2)=size(data(n+i).P);
    %         end
    %         s=max(s1,1);
    %         P2=zeros(sum(s(:,1)),s(2));
    %     end
    clear P2
    clear P2_2
    P2=zeros(specrow*row,1);
    P2_2=zeros(specrow*row,1);
    
    %r1=0;
    r1=(row-1)*specrow;
    for i=1:row
        
        if n+i-1<syllnum
            
            n1=n1+1;
            P1=data(n1).P;
            P1_2=ones(size(P1))*n1;
            
            P2(1+r1:r1+size(P1,1),1:size(P1,2))=P1;
            P2_2(1+r1:r1+size(P1,1),1:size(P1,2))=P1_2;
            
            %si(n1)=size(P1,2);
            %ti(n1)=matrix(n1,4);
           % r1
            r1=r1-size(P1,1);
            
            %size(P1,1)
            %specrow
            %imagesc(P2)
        end
        
        %size(P2)
        
    end
    %size(P3)
    %size(P2)
    P3=[P3  P2 zeros(specrow*row,5)];
    P3_2=[P3_2  P2_2 zeros(specrow*row,5)];
    n=n+row;
end
P3(P3==0)=NaN;
P3_2(P3_2==0)=NaN;

end