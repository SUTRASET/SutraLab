classdef ConstantObj <handle
% the handle is important as it updates the values when modified
% http://au.mathworks.com/help/matlab/matlab_oop/comparing-handle-and-value-classes.html
  properties
    second2day
    ms2mmday
    mm2m
    m2mm
    kelvin
    rhow_pure_water
    g
    kg2g
    g2kg
    psim_log_range
    mol_weight_water
    R
    mol_weight_nacl_kgPmol
    mol_weight_water_kgPmol
    gPkg
    density_solid_nacl_kgPm3
    psych
    molecular_weight_water
    air_density_kgPm3
    heat_capacity_air_JPkgPK
    mmPm
    mPmm
    kgPg
    msPmmday
    psychrometric_paPK
    mPkm
    kmPm
    minutePday
    secPmsec
    msecPsec
    secPday
    dayPsec
  end
  
  
  properties (Access=protected)
  c ,d
  end

  properties (Dependent=true)
  % these values are only called when input are changed
  %   a, b, c ,d, e,
  %nns
  end

  methods    % seems that all functions in methods needs to be called.
    function o=ConstantObj(varargin)
    o.ms2mmday=3600*24*1000.;
    o.kelvin=273.15;
    o.mm2m=0.001;
    o.m2mm=1000.;
    o.rhow_pure_water=1000.;
    o.g=9.81;
    o.second2day=1./3600/24;
    o.kg2g=1000.;
    o.g2kg=0.001;
    o.psim_log_range=-[0.0001:0.0001:0.001,0.002:0.001:0.01,0.02:0.01:0.1,0.2:0.1:1,2:1:10,20:10:100,200:100:1000,2000:1000:10000,20000:10000:1e5...
    	,2e5:1e5:1e6,2e6:1e6:9e6,1e7:1e7:9e7,1e8:1e8:9e8];
    o.mol_weight_water=0.018; %kg/mol
    o.mol_weight_water_kgPmol=0.018;
    %o.mol_weight_nacl_kgPmol=0.0585;
    o.R =8.314;

    o.mol_weight_nacl_kgPmol=0.0585;
    o.density_solid_nacl_kgPm3=2160.;

    o.psych=62.2;  % pa/K  # https://en.wikipedia.org/wiki/Psychrometric_constant
    o.molecular_weight_water=0.018;
    o.air_density_kgPm3=1.27;
    o.heat_capacity_air_JPkgPK=1010.0;
    o.mmPm=1000.;
    o.mPmm=.001;
    o.gPkg = 1000.;
    o.kgPg = 0.001;
    o.msPmmday=3600.*24*1000;
    o.psychrometric_paPK=66.0;
    o.mPkm=1000;
    o.kmPm=0.001;
    o.minutePday=60.*24;
    o.secPmsec=1e-3;
    o.msecPsec=1000;
    o.secPday=86400;
    o.dayPsec=1/86400;

%!      TSK   -- TEMPERATURE AT THAT NODE
%!     TS   -- SOIL TEMPERATURE [CELSIUS]
%!     STM  -- MOLECULAR WEIGHT OF NACL [KG/MOL]
%!     WMW   -- MOLECULAR WEIGHT OF WATER [KG/MOL]
    
    end
   end  % end methods

   methods(Static)
     function nns = nnns(o)
       % it is working the same time as others, which is not a procedural way.
       % everytime when o.a is changing, nnv is changing.
       nns.nns = o.a+7;
     end % function
   end % methods (static)
end % classdef
