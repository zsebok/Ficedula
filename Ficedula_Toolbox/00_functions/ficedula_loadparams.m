function params=ficedula_loadparams()

try
    load('lastpath_songcut.mat')
    params.lastpath_songcut=lastpath;
catch
    params.lastpath_songcut=[];
end

try
    load('lastpath_segment.mat')
    params.lastpath_segment=lastpath;
catch
    params.lastpath_segment=[];
end

try
    load('lastpath_data.mat')
    params.lastpath_data=lastpath;
catch
        params.lastpath_data=[];
end     
