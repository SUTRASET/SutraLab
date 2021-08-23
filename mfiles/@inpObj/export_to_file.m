function o=export_to_file(o,varargin)
  %   inp.export_to_file('file_name','abc');   %output to file abc.inp
  %   inp.export_to_file();  % output to file named [o.fname,'.inp']
  % 
  % 

%function o=get_dy_cell_mtx(o)
% this subfunction gets the delta y, when meshtype is 2D and regular

[o.fname,  varargin] = getProp(varargin,'file_name',o.fname);

filename=[o.fname,'.inp'];
fid = fopen(filename,'wt');

%% title
fprintf(fid,'##  SUTRA MAIN INPUT FILE\n');
fprintf(fid,'##\n');
fprintf(fid,'##  DATASET 1:  OUTPUT HEADING\n');
fprintf(fid,'##    [TITLE1]\n');
fprintf(fid,'##    [TITLE2]\n');

fprintf(fid,'%s \n',o.title1 );
fprintf(fid,'%s \n',o.title2 );

fprintf(fid,'##  DATASET 2:  SIMULATION TYPE AND MESH STRUCTURE\n' );
fprintf(fid,'''SUTRA VERSION 2.2 SOLUTE TRANSPORT''\n' );
fprintf(fid,'''2D REGULAR MESH''\t%d\t%d\n',[o.nn1,o.nn2] );
fprintf(fid,'##\n' );
fprintf(fid,'##  DATASET 3:  SIMULATION CONTROL NUMBERS\n' );
fprintf(fid,'##      [NN]\t\t[NE]\t\t[NPBC]\t\t[NUBC]\t\t[NSOP]\t\t[NSOU]\t\t[NOBS]\n' );
fprintf(fid,'\t%d\t\t%d\t\t%d\t\t%d\t\t%d\t\t%d\t\t%d\t\n',o.nn,o.ne,o.npbc,o.nubc,o.nsop,o.nsou,o.nobs);

fprintf(fid,'##\n');
fprintf(fid,'##  DATASET 4:  SIMULATION MODE OPTIONS\n');
fprintf(fid,'##\t[CUNSAT]\t\t[CSSFLO]\t\t[CSSTRA]\t\t\t[CREAD]\t\t[ISTORE]\n');
fprintf(fid,'\t''%s''\t\t''%s''\t''%s''\t\t''%s''\t\t%d\n',o.cunsat, o.cssflo, o.csstra, o.cread, o.istore);

fprintf(fid,'##\n');
fprintf(fid,'##  DATASET 5:  NUMERICAL CONTROL PARAMETERS\n');
fprintf(fid,'##\t[UP]\t\t[GNUP]\t\t\t[GNUU]\n');
fprintf(fid,'\t%.4E\t\t%.4E\t\t%.4E\n',o.up,o.gnup,o.gnuu);


fprintf(fid,'##\n');
fprintf(fid,'##  DATASET 6:  TEMPORAL CONTROL AND SOLUTION CYCLING DATA\n');
fprintf(fid,'##\t[NSCH]\t\t[NPCYC]\t\t[NUCYC]\n');
fprintf(fid,'\t%d\t\t%d\t\t%d\n',o.nsch,o.npcyc,o.nucyc);
fprintf(fid,'## [SCHNAM]\t\t[SCHTYP]\t\t[CREFT]\t\t[SCALT]\t\t[NTMAX]\t\t[TIMEI]\t\t[TIMEL]\t\t[TIMEC]\t\t[NTCYC]\t\t[TCMULT]\t[TCMIN]\t[TCMAX]\n');
fprintf(fid,'''%s''\t''%s''\t''%s''\t%d\t\t%d\t\t%d\t\t%.4E\t%d\t\t%d\t\t%.4E\t%.4E\t%.4E\n',o.schnam,o.schtyp,o.creft,o.scalt,o.ntmax,o.timei,o.timel,o.timec,o.ntcyc,o.tcmult,o.tcmin,o.tcmax);
% second line of time schedule
if o.nsch==2
    if strcmpi(o.schtyp_2,'STEP LIST')
        islist_str=regexprep(num2str( o.islist_2  ),'\s+','     ');
        fprintf(fid,'## [SCHNAM]\t\t[SCHTYP]\t\t[CREFT]\t\t[NSLIST]\t\t[ISLIST]\n');
        fprintf(fid,' ''%s'' \t''%s''\t\t %d \t\t%s\n',o.schnam_2,o.schtyp_2,o.nslist_2,islist_str);
    end
end

fprintf(fid,'''-''\n');


fprintf(fid,'##\n');
fprintf(fid,'##  DATASET 7:  ITERATION AND MATRIX SOLVER CONTROLS\n');
fprintf(fid,'##\t[ITRMAX]\t[RPMAX]\t\t[RUMAX]\n');
fprintf(fid,'\t%d\t\t%.4E\t%.4E\n',o.itrmax,o.rpmax,o.rumax);

fprintf(fid,'##\t[CSOLVP]\t[ITRMXP]\t[TOLP]\n');
fprintf(fid,'\t%s\t%d\t\t%.4E\n',o.csolvp,o.itrmxp,o.tolp);

fprintf(fid,'##\t[CSOLVU]\t[ITRMXU]\t[TOLU]\n');
fprintf(fid,'\t%s\t%d\t\t%.4E\n',o.csolvu,o.itrmxu,o.tolu);


fprintf(fid,'##\n');
fprintf(fid,'##    DATASET 8:  OUTPUT CONTROLS AND OPTIONS\n');
fprintf(fid,'##  [NPRINT]\t[CNODAL]\t[CELMNT]\t[CINCID]\t[CPANDS]\t[CVEL]\t[CCORT]\t[CBUDG]\t[CSCRN]\t[CPAUSE]\n');
fprintf(fid,'\t%d\t''%s''\t\t''%s''\t\t''%s''\t\t''%s''\t\t''%s''\t''%s''\t''%s''\t''%s''\t''%s''\t\n'...
    ,o.nprint,o.cnodal,o.celmnt,o.cincid,o.cpands,o.cvel,o.ccort,o.cbudg,o.cscrn,o.cpause);
fprintf(fid,'## [NCOLPR]\t[NCOL]\n');
fprintf(fid,'%d\t',o.ncolpr);
str=sprintf('''%s'' ',o.ncol{:});
fprintf(fid,'%s\n',str);

fprintf(fid,'## [LCOLPR]\t[LCOL]\n');
fprintf(fid,'%d\t',o.lcolpr);
str=sprintf('''%s'' ',o.lcol{:});
fprintf(fid,'%s\n',str);
fprintf(fid,'## [NOBCYC]\t[INOB]\n');
fprintf(fid,'##\n');
fprintf(fid,'##  [NBCFPR]\t[NBCSPR]\t[NBCPPR]\t[NBCUPR]\t[CINACT]\n');
fprintf(fid,'%d\t\t%d\t\t%d\t\t%d\t\t''%s''\n',o.nbcfpr,o.nbcspr,o.nbcppr,o.nbcupr,o.cinact);



fprintf(fid,'##\n');
fprintf(fid,'##DATASET 9:  FLUID PROPERTIES\n');
fprintf(fid,'## [COMPFL]\t[CW]\t\t[SIGMAW]\t[RHOW0]\t\t[URHOW0]\t[DRWDU]\t\t[VISC0]\n');
fprintf(fid,' %.4E\t%.4E\t%.4E\t%.4E\t%.4E\t%.4E\t%.4E\n',o.compfl,o.cw,o.sigmaw,o.rhow0,o.urhow0,o.drwdu,o.visc0);



fprintf(fid,'##\n');
fprintf(fid,'##  DATASET 10:  SOLID MATRIX PROPERTIES\n');
fprintf(fid,'## [COMPMA]\t[CS]\t\t[SIGMAS]\t[RHOS]\n');
fprintf(fid,' %.4E\t%.4E\t%.4E\t%.4E\n',o.compma,o.cs,o.sigmas,o.rhos);



fprintf(fid,'##\n');
fprintf(fid,'##  DATASET 11:  ADSORPTION PARAMETERS\n');
fprintf(fid,'##  [ADSMOD]\t[CHI1]\t\t[CHI2]\n');
fprintf(fid,' ''%s''\t%.4E\t%.4E\n',o.adsmod,o.chi1,o.chi2);



fprintf(fid,'##\n');
fprintf(fid,'##  DATASET 12:  PRODUCTION OF ENERGY OR SOLUTE MASS\n');
fprintf(fid,'##  [PRODF0]\t[PRODS0]\t[PRODF1]\t[PRODS1]\n');
fprintf(fid,' %.4E\t%.4E\t%.4E\t%.4E\n',o.prodf0,o.prods0,o.prodf1,o.prods1);


fprintf(fid,'##\n');
fprintf(fid,'##  DATASET 13:  ORIENTATION OF COORDINATES TO GRAVITY\n');
fprintf(fid,'##  [GRAVX]\t[GRAVY]\t\t[GRAVZ]\n');
fprintf(fid,' %.4E\t%.4E\t%.4E\n',o.gravx,o.gravy,o.gravz);



% dataset 14

dataset14_str=sprintf('## DATASET 14: Nodewise DATA\n');
dataset14_str=[dataset14_str,sprintf('##                              [SCALX]         [SCALY]         [SCALZ]         [PORFAC]\n')];
dataset14_str=[dataset14_str,sprintf('''NODE''\t\t\t\t%+E\t%+E\t%+E\t%+E\n',o.scalx,o.scaly,o.scalz,o.porfac)];
dataset14_str=[dataset14_str,sprintf('##\t[II]\t[NREG(II)]\t[X(II)]\t\t[Y(II)]\t\t[Z(II)]\t\t[POR(II)]\n')];

fprintf(fid, dataset14_str);

tic
fprintf('Writting dataset 14\n')

temp=[o.ii,o.nreg,o.x,o.y,o.z,o.por];
dataset14_str= sprintf('\t%d\t%d\t\t%+E\t%+E\t%+E\t%+E\n', temp');


fprintf(fid, dataset14_str);
toc



fprintf('Writting dataset 15\n')
dataset15_str='##\n';
dataset15_str=[dataset15_str,'## DATASET 15 ELEMENT WISE INPUT\n'];
dataset15_str=[dataset15_str,'##                              [PMAXFA]        [PMINFA]        [ANGFAC]        [ALMAXF]        [ALMINF]        [ATMAXF]        [ATMINF]\n'];
dataset15_str=[dataset15_str,sprintf('''ELEMENT''\t\t\t%+E\t%+E\t%+E\t%+E\t%+E\t%+E\t%+E\n',o.pmaxfa,o.pminfa,o.angfac,o.almaxf,o.alminf,o.atmaxf,o.atminf)];
dataset15_str=[dataset15_str,sprintf('## [L]\t\t[LREG(L)]\t[PMAX(L)]\t[PMIN(L)]\t[ANGLEX(L)]\t[ALMAX(L)]\t[ALMIN(L)]\t[ATMAX(L)]\t[ATMIN(L)]\n')];

fprintf(fid, dataset15_str);



temp=[  o.l,o.lreg,o.pmax,o.pmin,o.anglex,o.almax,o.almin,o.atmax,o.atmin];

dataset15_str=sprintf('%d\t\t%d\t\t%+E\t%+E\t%+E\t%+E\t%+E\t%+E\t%+E\n', temp');

fprintf(fid, dataset15_str);


%% dataset 17
if o.nsop~=0
    fprintf('writting dataset 17\n')
    dataset17_str='';
    dataset17_str=[dataset17_str,'##\n'];
    dataset17_str=[dataset17_str,'##  DATASET 16:  (NOT USED)\n'];
    dataset17_str=[dataset17_str,'##  DATASET 17:  Data for Fluid Source and Sinks\n'];
    dataset17_str=[dataset17_str,'##  [IQCP]               [QINC]               [UINC]\n'];
    temp=[o.iqcp,o.qinc,o.uinc];
    
    dataset17_str=[dataset17_str,sprintf('\t%d\t\t%+E\t%+E\n',temp')];
    dataset17_str=[dataset17_str,'00000000000000000000000000000000000000000000000000\n'];
    fprintf(fid, dataset17_str);
end


%% dataset 19%% dataset 19%% dataset 19%% dataset 19%% dataset 19
if o.npbc~=0
    fprintf('writting dataset 19\n')
    dataset19_str='';
    dataset19_str=[dataset19_str,'##\n'];
    dataset19_str=[dataset19_str,'##  DATASET 19:  Data for Specified Pressure Nodes\n'];
    dataset19_str=[dataset19_str,'##  [IPBC]                [PBC]                [UBC]\n'];
    temp=[o.ipbc,o.pbc,o.ubc];
    
    dataset19_str=[dataset19_str,sprintf('\t%d\t\t%+E\t%+E\n',temp')];
    dataset19_str=[dataset19_str,'00000000000000000000000000000000000000000000000000\n'];
    fprintf(fid, dataset19_str);
end
    

% dataset 22
fprintf('writting dataset 22\n')
dataset22_str= sprintf('##  DATASET 22:  Element Incidence Data\n');
dataset22_str=[dataset22_str,sprintf('##    [LL]      [IIN(1)]        [IIN(2)]        [IIN(3)]        [IIN(4)]\n')];
dataset22_str=[dataset22_str,sprintf('''INCIDENCE''\n')];

temp=[o.l,o.iin1,o.iin2,o.iin3,o.iin4];
dataset22_str = [dataset22_str,sprintf('\t%d\t\t%d\t\t%d\t\t%d\t\t%d\n', temp')];


fprintf(fid, dataset22_str);


fprintf('Written to file name: %s \n',filename);
%
%%% dataset 19
%fprintf(fid, dataset19_str);
%
%
%%% dataset 22
%
%
%for i=1:ne_string_block
%    fprintf(fid, dataset22_str{i});
%end
fclose(fid);
end 
