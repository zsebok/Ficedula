function results=ficedula_load_results_segmentation(path_data)

try
load([path_data 'results_segmentation.mat'])
catch
    results=[];
end