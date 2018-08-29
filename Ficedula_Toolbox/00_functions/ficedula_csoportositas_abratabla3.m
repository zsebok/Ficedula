function [P3,P3_2]=ficedula_csoportositas_abratabla3(data,sylls,row)

data=data(sylls);


[u1, u2, u3]=unique([data.rows]);

specrow=data(1).rows(1);

syllnum=length(data);
n=0;
P0=[];
n1=0;
P3=[];
P3_2=[];
while n<syllnum
   
    clear P2
    clear P2_2
    P2=zeros(specrow*row,1);
    P2_2=zeros(specrow*row,1);
   
    r1=(row-1)*specrow;
    for i=1:row
        
        if n+i-1<syllnum
            
            n1=n1+1;
            P1=data(n1).P;
            P1_2=ones(size(P1))*n1;
            
            P2(1+r1:r1+size(P1,1),1:size(P1,2))=P1;
            P2_2(1+r1:r1+size(P1,1),1:size(P1,2))=P1_2;
            
            r1=r1-size(P1,1);
            
        end
        
        
    end
    
    P3=[P3  P2 zeros(specrow*row,50)];
    P3_2=[P3_2  P2_2 zeros(specrow*row,50)];
    n=n+row;
end
P3(P3==0)=NaN;
P3_2(P3_2==0)=NaN;

end