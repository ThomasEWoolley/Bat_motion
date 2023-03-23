ccc


[Track_data,Track_titles]=xlsread('./Cleansed_radio_track_data.xlsx');

[Roost_data,Roost_titles]=xlsread('radiotrack_roosts.csv');
[Sunrise_set_data,Sunrise_set_titles]=xlsread('Sunrise_set_Exeter.csv');

%% Correct times
Sunset_times=datetime(Sunrise_set_data(:,6), 'ConvertFrom','excel', 'Format','HH:mm:ss');
Detection_times=datetime(Track_data(:,2), 'ConvertFrom','excel', 'Format','HH:mm:ss');
Study_day=Track_data(:,3);

Sunset_on_day=Sunset_times(Study_day);
Detection_times_sec=seconds(timeofday(Detection_times));
Corrected_detector_times=Detection_times_sec+24*60*60*(Detection_times_sec<12*60*60)-seconds(timeofday(Sunset_on_day));

% %%
How_many_bat_nights=length(unique( Track_data(:,[1 3]), 'rows'))


%% Normalise tracks


for i=unique(Track_data(:,1))'
    
    for j=unique(Track_data(Track_data(:,1)==i,3))'
        Index1=(Roost_data(:,1)==i)&(Roost_data(:,2)==j);
        Roost_x=Roost_data(Index1,3);
        Roost_y=Roost_data(Index1,4);
        if ~isempty(Roost_x)
            Index2=(Track_data(:,1)==i)&(Track_data(:,3)==j);
            x_displacement(Index2,1)=Track_data(Index2,4)-Roost_x;
            y_displacement(Index2,1)=Track_data(Index2,5)-Roost_y;
            C_d_times(Index2,1)=Corrected_detector_times(Index2,1)
        end
        
    end
end
Corrected_detector_times=C_d_times;


%%

Times=0:200:8*60^2;
l=1;
for i=unique(Track_data(:,1))'
    
    for j=unique(Track_data(Track_data(:,1)==i,3))'
        Index1=(Roost_data(:,1)==i)&(Roost_data(:,2)==j);
        Roost_x=Roost_data(Index1,3);
        if ~isempty(Roost_x)
            Indices=(Track_data(:,1)==i)&(Track_data(:,3)==j);
            [c,a]=unique(Corrected_detector_times(Indices));
            x=x_displacement(Indices);
            y=y_displacement(Indices);
            x=x(a);
            y=y(a);
            
            x_interpolated(:,l)=interp1(c,x,Times');
            y_interpolated(:,l)=interp1(c,y,Times');
            l=l+1;
        end
    end
end

%%
close all
r=x_interpolated.^2+y_interpolated.^2;
rmean=mean(r,2,'omitnan')
rvar=var(r,1,2,'omitnan')
N=sum(~isnan(r),2);
SE=sqrt(rvar./N);


confplot2(Times'/60^2,rmean,SE,'r',0.3);

xlabel('Hours after sunset')
ylabel('MSD in m$^2$')
ylim([0,2e6])
export_fig('../Pictures/Matlab_MSD','-r300')