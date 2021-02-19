function fileName = getFileName(specNum,runNum)
% brainData = 'EEGdatasets\S003\S003R08.edf'; 
 specNumS = convertCharsToStrings(num2str(specNum));
 runNumS = convertCharsToStrings(num2str(runNum));

 while strlength(specNumS) < 3
      specNumS = '0'+ specNumS;
 end

 while strlength(runNumS) < 2
      runNumS = '0'+runNumS;
 end
 
fileName = char("..\EEGdatasets\"+"S"+specNumS+"\S"+specNumS+"R"+runNumS+".edf");
end

