function o=export_to_file(o,varargin)
      %   bcs.export_to_file('file_name','abc');   %output to file abc.bcs
      %   bcs.export_to_file();  % output to file named [o.fname,'.bcs']
      % 
      % 
    
    %function o=get_dy_cell_mtx(o)
    % this subfunction gets the delta y, when meshtype is 2D and regular
    
    %[o.fname,  varargin] = getProp(varargin,'file_name',o.fname);
    
    fid = fopen(o.uname,'wt');
    
    fprintf('Writting to file %s\n', o.uname);
    fprintf(fid, '# creat bcs file using SUTRALAB \n');
    fprintf(fid, '# dataset 1: time steps \n');
    fprintf(fid, '# [BCSSCH] \n');
    fprintf(fid, '''%s'' \n',o.terms.bcssch);
    
    nsch=length(o.terms.data);
    fprintf('There are  %i time steps to be specificed in the bcs file ''%s''\n',nsch,o.uname );
    
    
    for i = 1:nsch
    
        fprintf(fid, '## Dataset 2-%i: identifier and counts \n',i);
        fprintf(fid, '## # [BCSID] [NSOP1]        [NSOU1]     [NPBC1]     [NUBC1]\n');
        fprintf(fid, '''%s''\t\t\t%i\t\t\t%i\t\t\t%i\t\t\t%i\n',o.terms.data(i).bcsid,o.terms.data(i).nsop1,o.terms.data(i).nsou1,o.terms.data(i).npbc1,o.terms.data(i).nubc1);
    
        if o.terms.data(i).nsop1 ~=0
            fprintf(fid, '# Dataset 3-%i: fluid sources/sinks\n',i);
            fprintf(fid, '## # [IQCP1] [QINC1]     [UINC1] \n');
    
            temp=[o.terms.data(i).iqcp1,o.terms.data(i).qinc1,o.terms.data(i).uinc1];
    
            dataset3_str=sprintf('\t%d\t\t%+E\t%+E\n',temp');
            dataset3_str=[dataset3_str,'00000000000000000000000000000000000000000000000000\n'];
            fprintf(fid, dataset3_str);
        end
    end
    fclose(fid);

end % function_export to file
