ccc

[Track_data,Track_titles]=xlsread('Cleansed_radio_track_data.xlsx');
[Roost_data,Roost_titles]=xlsread('radiotrack_roosts.csv');
[Sunrise_set_data,Sunrise_set_titles]=xlsread('Sunrise_set_Exeter.csv');

Bats=unique(Track_data(:,1));
Days=unique(Track_data(:,3));
l=1;
n=0;
for i=Bats'
    
    for j=Days'
        
        Index=(Track_data(:,1)==i)&(Track_data(:,3)==j);
        
        if sum(Index)>0
            Index2=(Roost_data(:,1)==i)&(Roost_data(:,2)==j);
            Roost_x=Roost_data(Index2,3);
            Roost_y=Roost_data(Index2,4);
            
            x=Track_data(Index,4)-Roost_x;
            y=Track_data(Index,5)-Roost_y;
            
            
            hold on
            subplot(2,ceil(length(Bats)/2),l)
            plot(x,y)
            axis equal
            axis tight
            n=n+1;
        end
    end
    title(num2str(i))
    l=l+1;
end


%%
ccc
figure('position',[0 0 2/3 1/2])
[Track_data,Track_titles]=xlsread('Cleansed_radio_track_data.xlsx');
[Roost_data,Roost_titles]=xlsread('radiotrack_roosts.csv');
[Sunrise_set_data,Sunrise_set_titles]=xlsread('Sunrise_set_Exeter.csv');

Bats=unique(Track_data(:,1));
Days=unique(Track_data(:,3));

Sunset_times=datetime(Sunrise_set_data(:,6), 'ConvertFrom','excel', 'Format','HH:mm:ss');
Detection_times=datetime(Track_data(:,2), 'ConvertFrom','excel', 'Format','HH:mm:ss');
Study_day=Track_data(:,3);

Sunset_on_day=Sunset_times(Study_day);
Detection_times_sec=seconds(timeofday(Detection_times));
Corrected_detector_times=Detection_times_sec+24*60*60*(Detection_times_sec<12*60*60)-seconds(timeofday(Sunset_on_day));



l=1;




for i=7
    
    for j=[6 8];Days';
        
        Index=(Track_data(:,1)==i)&(Track_data(:,3)==j);
        
        if sum(Index)>0
            Index2=(Roost_data(:,1)==i)&(Roost_data(:,2)==j);
            Roost_x=Roost_data(Index2,3);
            Roost_y=Roost_data(Index2,4);
            j;
            x=Track_data(Index,4)-Roost_x;
            y=Track_data(Index,5)-Roost_y;
            
            
            [c,ic,ia]=unique( [x,y],'stable', 'rows');
            Times=num2str(round(hours(seconds(Corrected_detector_times(Index))),2));
            hold on
            p(l)={['Day ', num2str(j)]};
            subplot(1,2,l)
            l=l+1;
            if l==2
                zz=iterator((1:length(c))');
            else
                zz=iterator(-(1:length(c))');
            end
            
            plot(c(:,1),c(:,2),'o--')
            text(c(:,1)+zz(:,1)*20,c(:,2)+zz(:,2)*50,Times(ic,:),'fontsize',20)
            axis equal
            xlabel('Distance from roost in m')
            ylabel('Distance from roost in m')
            %             axis tight
            
        end
    end
    
    l=l+1;
end
export_fig('../Pictures/Example_trajectories.png','-r300')

function zz=iterator(j)

z=exp(1i*j*2*pi/6);
zz=[real(z) imag(z)];
end