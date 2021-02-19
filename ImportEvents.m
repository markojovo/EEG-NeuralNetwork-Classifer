function EEGevent = ImportEvents(EventFileNoEventSuffix,EEG)
sampleRate = EEG.srate;

% Columns go: Tcode number, Sample Location, Duration, Index, Time
% TODO: Add extra labeler to signify which run this is (check dataset site)
try
    eventLabels = Eventread('',EventFileNoEventSuffix);
catch
    EEGevent = -1;
    return
end
    
    
if isempty(eventLabels)
    eventLabels = 0;
end
EEGevent = rmfield(EEG.event,'type');
EEGevent = cell2mat(struct2cell(EEGevent));
[x,~,y] = size(EEGevent);
EEGevent = reshape(EEGevent,[x,y])';
if length(EEG.event) == length(eventLabels)
    EEGevent(:,1) = eventLabels; 
else
    EEGevent = -1;
    return
end

EEGevent = [EEGevent EEGevent(:,2)./sampleRate];
end

