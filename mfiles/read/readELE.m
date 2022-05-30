function [o,o2] = readELE(varargin)
  % readELE reads ELE file   
  %
  % INPUT
  %   filename     -- if file is named as 'abc.ele', a filename='abc'
  %                   is required
  %   outputnumber -- number of result extracted, this is useful when
  %                   output file is huge
  %   outputstart  -- (not implimented yet) the start of the result
  %
  % OUTPUT
  % o  -- a struct the same size as the number of output.
  % o2 -- a struct extracting headers with the extraction inf
  %
  % Example:
  % [eledata,elehead]=readELE('project','outputnumber',3);
  %    Purpose: parsing 'project.ele' (or 'project.ELE')
  %            only the first three result gets extracted

  % a string storing the caller functions
  caller = dbstack('-completenames'); caller = caller.name;

  o2.varargin       = varargin;
  [fname, varargin] = getNext(varargin,'char','');
  % an option to see whether use inp contents to guide the reading process
  % a hard reading process will be conducted if left empty
  [output_no,  varargin]   = getProp(varargin,'outputnumber',0);
  [output_from,  varargin] = getProp(varargin,'outputfrom',0);
  %[inpObj,  varargin]      = getProp(varargin,'inpObj',[]);
  o2.output_no             = output_no;
  fn                       = fopen([fname,'.ELE']);
  fname_actual=[fname,'.ELE'];
  if fn==-1 
    fprintf(1,'%s : Trying to open %s .ele\n',caller,fname);
    fname_actual=[fname,'.ele'];
    fn=fopen([fname,'.ele']);
    if fn==-1
      fprintf('%s: file ele found!!\n',caller,fname);
      o=-1;o2=-1;
      return
    end
  end
  
  o2.title1 = getNextLine(fn,'criterion',...
                         'with','keyword','## ','operation','delete');
  o2.title2 = getNextLine(fn,'criterion',...
                         'with','keyword','## ','operation','delete');
 
  % ---------------- Parsing the line with node, element info-----------------
  o2.MeshInfo =getNextLine(fn,'criterion','equal','keyword','## ');
  o2.MeshInfo(1)
  if strcmpi(o2.MeshInfo(4:6),'2-D')
    tmp=regexprep(o2.MeshInfo,{'#','(',')','\,','*','='},{'','','','','',''});
    tmp=textscan(tmp,'%s %s %s %f %f %f %*s %f %*s');
    % how to realize this by one-liner
    %  [o2.mshtyp{1} o2.mshtyp{2} ] = deal(tmp{1:2}{1});
    o2.mshtyp{1}                    = tmp{1}{1};
    o2.mshtyp{2}                    = tmp{2}{1};
    [o2.nn1,o2.nn2,o2.ne,o2.nn ]    = deal(tmp{4:7});
  elseif strcmpi(o2.MeshInfo(4:6),'3-D')
    tmp=regexprep(o2.MeshInfo,{'#','(',')','\,','*','='},{'','','','','',''});
    tmp2=textscan(tmp,'%s %s %s %f %f %f %f %*s %f %*s');
    o2.mshtyp{1}                    = tmp2{1}{1};
    o2.mshtyp{2}                    = tmp2{2}{1};
    [o2.nn1,o2.nn2,o2.nn3,o2.ne,o2.nn ]    = deal(tmp2{4:8});    
  end
      
      
  % ---------------- parsing the number of results    ------------------------
  tmp = getNextLine(fn,'criterion','with','keyword',...
                 '## VELOCITY RESULTS','operation','delete');
  tmp           = textscan(tmp,'%f ');
  o2.ktprn      = tmp{1};  % expected no. time steps
  if output_no ~= 0
    output_no   = min(o2.ktprn,output_no);
  else
    output_no = o2.ktprn;
  end

  % ---------------- parsing expected results    ----------------------------
  % Refering to OUTELE.......19900
  tmp       = getNextLine(fn,'criterion','with','keyword','##   --');
  tmp_table = textscan(fn,'##  %f %f %s %f %s %f %s %f ',o2.ktprn);
  [o2.itt,o2.tt,o2.cpvx,o2.isvx,o2.cpvy,o2.isvy,o2.cpvz,o2.isvz]=...
    deal(tmp_table{:});



  %% ---jumping results when started point is not the first output TO190308----
  if output_from>1
     
     fprintf(1,'Jumping and starting to read from %d th output\n which is %d th time step, actual time %d\n',output_from,o2.itt(output_from),o2.tt(output_from));
     if ispc 
         % this has been found to use out of memories 
         tic
         textscan(fn,'%s', output_from*(o2.ne+5));  %300s s for ilja case and
         %the location is wrong
         %textscan(fn,'%[^\n]', output_from*(o2.nn+5));  %
         toc
         % below is too slow
         %textscan(fn,'', output_from*(o2.nn+5));
         % this is slower but would not use out of memories
         %textscan(fn,'%s',1,'headerLines' , output_from*(o2.nn+5)-1);
     else  % extract from middle
         fprintf(1,'creat temp nod file nod_')
         %https://stackoverflow.com/questions/83329/how-can-i-extract-a-predetermined-range-of-lines-from-a-text-file-on-unix
         start_output_line_number= o2.ktprn + output_from*(o2.ne+5)+12;
         end_output_line_number=o2.ktprn + (output_from+output_no)*(o2.ne+5)+12;
         exit_line_number=end_output_line_number+1;
         %sed -n '16224,16482p;16483q' filename > newfile
         %command_string=['sed -n ''',fprintf('%d',start_output_line_number), ',',fprintf('%d',end_output_line_number),'p,',fprintf('%d',end_output_line_number),'q, ',fname_actual];
         tic
         command_string=sprintf('sed -n ''%d,%dp;%dq'' %s > ele_  ',start_output_line_number,end_output_line_number,exit_line_number,fname_actual);
         system(command_string);
         toc
         fclose(fn);
           fn                       = fopen('ele_');
     end
  elseif output_from<0  % output from the last few
      % !tail -n 50000 PART6.nod > nod__
      
      tic
      command_string=sprintf('tail -n %d   %s > ele_ ', abs(output_from)*(o2.ne+5)+10,fname_actual   );
      fprintf(1,'creat temp nod file nod_ by %s\n', command_string);
      system(command_string);
      toc
         fclose(fn);
           fn                       = fopen('ele_');      
           output_no=abs(output_from);
  end
  



  % ---------------- Parsing simulation results -----------------------------
  fprintf(1,'%s is parsing the %g of %g outputs\n', caller,output_no,o2.ktprn);
  for n=1:output_no
    fprintf('.');
    if rem(n,50)==0; fprintf('%d\n',n);   end
    tmp       = getNextLine(fn,'criterion','with','keyword','## TIME STEP');
    if tmp  ~= -1
      tmp = regexprep(tmp,{'## TIME STEP','Duration:','sec','Time:'}...
                    ,{'','','',''});
      tmp   = textscan(tmp,'%f %f %f');
      [ o(n).itout,o(n).durn,o(n).tout] = deal(tmp{:});


                
      tmp = getNextLine(fn,'criterion','without'...
                    ,'keyword','## ==');                
      % remove '## ' at the beginning
      tmp=tmp(4:end);
%        % a mask matrix for tmp indicating blank space ' '(i.e., white space)
%        tmp_blank_mask=tmp==' ';
% %       % a mask matrix indicating the location of a blank whose both
% %       % neighbours are alphabetics. such effort is to change a pattern
% %       % 'X origin' to 'X_origin'
% %       % if not, 
% %       tmp_singleblank_mask=strfind(tmp_blank_mask,[0 1 0])+1;
% %       
% %       tmp(tmp_singleblank_mask)='_';
% %       tmp        = textscan(tmp,'%s'   );
%        %       o(n).string=tmp;    
%        % I also have tried the following 
%        tmp_blanks_mask=find(tmp_blank_mask(1:end-1)+tmp_blank_mask(2:end)==2);
%        tmp(tmp_blanks_mask)='#';
% 
% 
%        % tmp=regexprep(tmp,' +','#');
%        % tmp2(cc)='_'
%        % but there is a problem where all words starts with a space
%        % a mask matrix for tmp indicating blank space ' '(i.e., white space)
%        %  tmp_blank_mask=tmp==' ';
%        
%        %find(tmp_blank_mask(1:end-1)==1 && tmp_blank_mask(2:end)==1)
%        tmp        = textscan(tmp,'%s','delimiter','#'   );       
% 
%       % http://au.mathworks.com/matlabcentral/answers/27042-how-to-remove-empty-cell-array-contents
%       tmp=tmp{1}';
%       o(n).label = tmp(~cellfun('isempty',tmp))  ;
      o(n).label = getOutputLabelName( tmp );
      fmt        = repmat('%f ',1, length(o(n).label));
      o(n).terms = textscan(fn,fmt,o2.ne);
    else
      fprintf(1,['WARNING FROM %s: Simulation is not completed\n %g'...
             'out of %g outputs extracted\n'],caller,n,o2.ktprn);
      return
    end % if condition
  end  % n loops
  fprintf('%s: Parsed %g of %g outputs\n', caller,output_no,o2.ktprn);
