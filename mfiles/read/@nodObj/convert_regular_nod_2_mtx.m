function o=convert_regular_nod_2_mtx(o,varargin)
% A warning to this : if transpose is enabled, the sequence of the array
% is no longer in accordance with the nodal sequence!
% but the advantage is that the matrix is formed in a regular form
  % a string storing the caller functions
  caller = dbstack('-completenames'); caller = caller.name;

  o.varargin       = varargin;
  [o.transpose,  varargin]  = getProp(varargin,'transpose','no');
  [delete_terms,  varargin] = getProp(varargin,'delete_terms','no');
  [inpObj,  varargin]       = getProp(varargin,'inp',[]);
%  o2.output_no             = output_no;
  if strcmpi(o.transpose,'no')
    for i =1:length(o.data)
        for j=1:length(o.data(i).terms)
          o.data(i).terms_mtx{j}=reshape(o.data(i).terms{j},[o.nn1,o.nn2]);
        end
    end
  elseif strcmpi(o.transpose,'yes')
    for i =1:length(o.data)
        for j=1:length(o.data(i).terms)
          o.data(i).terms_mtx{j}=reshape(o.data(i).terms{j},[o.nn1,o.nn2])';
        end
    end
  end

  if strcmpi(delete_terms,'yes')
      o.delete_terms;
  end
