function results=ficedula_load_database_syllables_measured(path_data)
try
load([path_data 'database_syllables_measured.mat'])
results=database_syllables_measured;
catch
    results=[];
end
