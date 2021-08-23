classdef bcsObj <handle
  %
  properties

    uname = 'SUTRA.FIL'
    varargin cell;
    % NOTICE TO DEVELOPERS:
    %   please make sure that all decleared varables here are in accordance with 
    %    Original SUTRA code for the convinence of 1. better understanding of the 
    %    original code (input are in indat1 and indat2) and 2. make code consistent
    %   A comment can be made after the name declaration 
    %   k(1)=-1 means that inp file is not going to be printed
    transpose
    %mtx_transpose

    sw_read_from_file
    
    nnv


    nfb
    %IPBC1(NBCN1),PBC1(NBCN1),IUBC1(NBCN1),UBC1(NBCN1)


    % ---------------  DATASET 1 variable declaration--------------------
    terms=struct('bcssch','' ...
                ,'data', struct('bcsid','','nsop1',0,'nsou1',0,'npbc1',0,'nubc1',0) );

    

    
  end
  
  
 

  properties (Access=protected)
  c ,d
  end

  properties (Dependent=true,Access=public)
    %terms = struct('smy',term,'inp',term);
  % these values are only called when input are changed
  %   a, b, c ,d, e,
  %nns
  end

  methods    % seems that all functions in methods needs to be called.

    %function value = get.terms(o)
    %   value=o.terms;
    %end


    function o=bcsObj(varargin)
        %% a string storing the caller functions
        caller = dbstack('-completenames'); caller = caller.name;
        o2.varargin       = varargin;
      
        [inp,  varargin]      = getProp(varargin,'inpObj',[]);
        [o.sw_read_from_file,  varargin] = getProp(varargin,'read_from_file','yes');
        %o.ftstr= fieldnames(o.terms);
      
        if strcmpi(o.sw_read_from_file,'yes')
          frpintf('creating object by reading from SUTRA.FIL');
          fn=fopen(o.uname);

          
          temp = getNextLine(fn,'criterion','without','keyword','#');
          
          while temp~=-1
              temp = regexprep(temp,'''','');
              tmp=textscan(temp,'%s  %f  %s'); 
              %fprintf('%s\n',tmp{1});
              id = strcmp(o.ftstr,lower(tmp{1}));
              property_name= o.ftstr{id};
              %o.terms.(property_name).fname=tmp{3}{1};
              %o.terms.(property_name).fid=tmp{2};
              temp = getNextLine(fn,'criterion','without','keyword','#');
          end  % while
        
        end

      end % Function constructor

       function nnv=get.nnv(o)
         % it is working the same time as others, which is not a procedural way.
	 % everytime when o.a is changing, nnv is changing.
         nnv=o.a+1; 
       end

   end  % end methods

   methods

  %function mtx_transpose=get.mtx_transpose(o) 
  %if isempty(o.mtx_transpose) % give a initial result
  %    mtx_transpose='no';
  %else

  %mtx_transpose  = o.mtx_transpose; 
  %end
  %end
  %function o=set.mtx_transpose(o,varargin), o.mtx_transpose  = varargin{1}; end

   end % methods

  % http://stackoverflow.com/questions/27729618/define-method-in-a-separate-file-with-attributes-in-matlab
  methods (Access=private)
    opt=convert_2_mtx(o,varargin)
  end  % private methods
   methods(Static)
     function nns = nnns(o)
       % it is working the same time as others, which is not a procedural way.
       % everytime when o.a is changing, nnv is changing.
       %nns.nns = o.a+7;
     end % function
   end % methods (static)
end % classdef
