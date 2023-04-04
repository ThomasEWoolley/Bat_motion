ccc
[Track_data,Track_titles]=xlsread('Cleansed_radio_track_data.xlsx');
[Roost_data,Roost_titles]=xlsread('radiotrack_roosts.csv');
[Sunrise_set_data,Sunrise_set_titles]=xlsread('Sunrise_set_Exeter.csv');


Sunset_times=datetime(Sunrise_set_data(:,6), 'ConvertFrom','excel', 'Format','HH:mm:ss');
Detection_times=datetime(Track_data(:,2), 'ConvertFrom','excel', 'Format','HH:mm:ss');
Study_day=Track_data(:,3);

Sunset_on_day=Sunset_times(Study_day);
Detection_times_sec=seconds(timeofday(Detection_times));
Corrected_detector_times=Detection_times_sec+24*60*60*(Detection_times_sec<12*60*60)-seconds(timeofday(Sunset_on_day));

Bats=unique(Track_data(:,1));
Days=unique(Track_data(:,3));
Intervals_vec=[];
for i=Bats'
    
    for j=Days'
        
        Index=(Track_data(:,1)==i)&(Track_data(:,3)==j);
        
        if sum(Index)>0
            
            Times=Corrected_detector_times(Index);
            Intervals=diff([0;Times]);
            Intervals_vec=[Intervals_vec;Intervals];
        end
    end
    
end

%%
close all
histogram(Intervals_vec,[0:200:7200,max(Intervals_vec)],'Normalization','count')
axis([0 7200 0 50])
xlabel('Time interval in seconds')
ylabel('Count')
export_fig('../Pictures/Time_intervals.png','-r300')