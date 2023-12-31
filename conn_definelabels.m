function lfilename=conn_definelabels(filename)
[filename_path,filename_name,filename_ext]=fileparts(deblank(filename));
lfilename=conn_prepend('',filename,'.txt');
if conn_existfile(lfilename), return; end
lfilename=conn_prepend('',filename,'.csv');
if conn_existfile(lfilename), return; end
lfilename=conn_prepend('',filename,'.xls');
if conn_existfile(lfilename), return; end

[tvalues,tnames]=conn_rex(filename,filename,'summary_measure','mean','level','clusters','select_clusters',0,'output_type','none');
for n1=1:numel(tnames), if ~isempty(strmatch(filename_name,tnames{n1})), tnames{n1}=[tnames{n1}(numel(filename_name)+2:end)]; end; end
ut=unique(tvalues(:));
if ~any(rem(ut,1))&&isequal(size(tvalues),size(tnames))&&~(min(ut)==1&&max(ut)==numel(ut)), % create new .csv labels file
    lfilename=fullfile(filename_path,[filename_name,'.csv']);
    if conn_existfile(lfilename),
        answ=conn_questdlg(sprintf('Warning: labels file %s already exists. Overwrite?',lfilename),'Warning','Yes','No','No');
        if ~strcmp(answ,'Yes'), return; end
    end
    %fh=fopen(lfilename,'wt');
    fh={};
    fh{end+1}=sprintf('%s,%s\n','ROIname','ROIid');
    for n1=1:numel(tnames),
        fh{end+1}=sprintf('%s,%d\n',tnames{n1},tvalues(n1));
    end
    %fclose(fh);
    conn_fileutils('filewrite_raw',lfilename, fh);
    
else  % create new .txt labels file
    lfilename=fullfile(filename_path,[filename_name,'.txt']);
    if conn_existfile(lfilename),
        answ=conn_questdlg(sprintf('Warning: labels file %s already exists. Overwrite?',lfilename),'Warning','Yes','No','No');
        if ~strcmp(answ,'Yes'), return; end
    end
    conn_fileutils('filewrite', lfilename, tnames);
    %fh=fopen(lfilename,'wt');
    %for n1=1:numel(tnames),
    %    fprintf(fh,'%s\n',tnames{n1});
    %end
    %fclose(fh);
end
fprintf('Created labels file %s with default ROI labels. Edit this file to modify these labels\n',lfilename);
end
