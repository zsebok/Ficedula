clear
load database_syllables

%%
pers={'bgy','lm','ng','zss','glzs'};
colors=[0 0 0; 0 1 0; 1 0 0; 0 0 1; 1 0.5 0];

path1='C:\Users\sandor\Documents\MATLAB\syllable_classification2_repeta\flycatcher_csoportositas\repeatibility\';
ind1='2013_25';

for i=1:5
    i
    load([path1 pers{i} '\' ind1 '.mat'])
    
    r(i)=summary1(ind1,database_syllables,cat);
end
return
%% repertoire size
figure

for i=1:5
    hold on
    bar(i,r(i).m_repsize,'facecolor',colors(i,:),'barwidth',[0.3])
end
grid on
legend(pers,'location','SouthOutside','orientation','horizontal')
title('repertoire size')
set(gca, 'xticklabel','')

%% group sizes
figure

for i=1:5


    hold on
    plot(1:length(r(i).cats_num2),r(i).cats_num2,'.-','color',colors(i,:))


end
grid on
set(gca,'xtick',1:1:30)
set(gca,'ytick',0:2:32)
xlabel('size of category')
ylabel('occurance')
xlim([1 21])
legend(pers,'location','SouthOutside','orientation','horizontal')
title('distribution of category sizes')



%% versatility
figure
table1=[];
for i=1:5
    
    table1=[table1; r(i).vers' repmat(i,length(r(i).vers),1)];
    
end
boxplot(table1(:,1),table1(:,2))
set(gca,'xtick',1:5)
set(gca,'xticklabel',pers)

title('versatility (medians and percentils)')
ylabel('number of syllable categories inside the songs')

%% parameter distribution

table2=[];
for i=1:4
    
    table2=[table2; r(i).coef_var repmat(i,size(r(i).coef_var,1),1)];
    
end

boxplot(table2(:,5),table2(:,6))
set(gca,'xtick',1:4)
set(gca,'xticklabel',pers)

title('versatility (medians and percentils)')
ylabel('number of syllable categories inside the songs')

%% t-range 
close all

figure
for i=1:5
    t1=histc(r(i).range_rel(:,1),0:0.05:1);
    t1=t1./repmat(sum(t1),size(t1,1),1);
    subplot(1,2,1)
    hold on
    
    plot(0:0.05:1,t1*100,'.-','color',colors(i,:))
    set(gca,'xtick',(0:0.05*2:1))
    set(gca,'xticklabel',(0:0.05*2:1))
    xlabel('range of relative duration')
    ylabel('occurance in percent')
    
    grid on

    subplot(1,2,2)
    hold on
    plot(0:0.05:1,cumsum(t1)*100,'color',colors(i,:))
    set(gca,'xtick',(0:0.05*2:1))
    set(gca,'xticklabel',(0:0.05*2:1))
    xlabel('range of relative duration')
    ylabel('cummulative occurance in percent')
    grid on

end
subplot(1,2,1)
hold on
legend(pers,'location','SouthOutside','orientation','horizontal')
subplot(1,2,2)

hold on
ylim([0 105])
legend(pers,'location','SouthOutside','orientation','horizontal')

%%% f-mean-range


figure
for i=1:5
    t1=histc(r(i).range_rel(:,2),0:0.05:1);
    t1=t1./repmat(sum(t1),size(t1,1),1);
    subplot(1,2,1)
    hold on
    
    plot(0:0.05:1,t1*100,'.-','color',colors(i,:))
    set(gca,'xtick',(0:0.05*2:1))
    set(gca,'xticklabel',(0:0.05*2:1))
    xlabel('range of relative mean frequency')
    ylabel('occurance in percent')
    
    grid on

    subplot(1,2,2)
    hold on
    plot(0:0.05:1,cumsum(t1)*100,'color',colors(i,:))
    set(gca,'xtick',(0:0.05*2:1))
    set(gca,'xticklabel',(0:0.05*2:1))
    xlabel('range of relative mean frequency')
    ylabel('cummulative occurance in percent')
    grid on
% legend(pers,'location','SouthOutside','orientation','horizontal')
end
subplot(1,2,1)
hold on
legend(pers,'location','SouthOutside','orientation','horizontal')
subplot(1,2,2)

hold on
ylim([0 105])
legend(pers,'location','SouthOutside','orientation','horizontal')
