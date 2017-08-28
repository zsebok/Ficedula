function results=ficedula_load_results_cutting(path_data)

try
    load([path_data 'results_songcut.mat'])
    results=results_songcut;
catch
    results=[];
end