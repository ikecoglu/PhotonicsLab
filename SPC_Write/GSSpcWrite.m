function GSSpcWrite (filename, spectra, axis, logtxt, logbin, options)
%GSSpcWrite v0.4.3
%
%This function will export a spectrum from data MATLAB-environment into an
%spc-file. The universal design of the spc-file format permits
%the use of spectra from different spectroscopic sources containing a wide
%range of spectra and information. The current function is able to export
%single-spectra spc-files. Currently multi-spectra spc-files aren't
%supported because of a lack of them during test-fase of GSSpcRead.
%
%Syntax:
%    GSSpcWrite (filename, spectra, axis, logtxt, logbin, options)
%    GSSpcWrite (filename, spectra, axis, logtxt, logbin)
%    GSSpcWrite (filename, spectra, axis, logtxt)
%    GSSpcWrite (filename, spectra, axis)
%
%Input parameters:
%    - filename: the name of the file in which the spectrum will be
%       written, path included
%    - spectra: (double array) the spectral data itself. Spectral data are in
%       a matrix, where one row represents one spectrum.
%    - axis: (cell array), the xaxis of the spectra.
%    - logtxt: (char array or cellstring array) logtext to save with the spectra
%    - logbin: (uint8 data) binary data to save with the data
%    - options: optional parameter: structure: possible fields:
%        fcmnt: string: file comment
%        fexper: integer: experimental technique: see SPC file format
%            description (0 = general)
%        fsource: string: instrument source
%        fmethod: string: used methods, instrumental techniques, ...
%        xunit: integer: type of x-units: see SPC file format
%            description (0 = general)
%        yunit: integer: type of y-units: see SPC file format
%            description (0 = general)
%        SaveHighPrecision: spectra are stored in float32 format as
%            standard (as should be the case). When higher precision is
%            needed, however, the spectra will be processed and stored as
%            integer values. To use the highest precision, set this value
%            to 1.
%
%Syntax 2:
%    GSSpcWrite (filename, spectrum)
%
%Input parameters:
%    - filename: same as above
%    - spectrum: structure that either contains the fields
%        spectra, axis and options (see above) or is equal to a structure
%        as produced by GSSpcRead
%
%Example:
%        (with X a structure containing a spectrum and the xaxis)
%    GSSpcWrite ('d:\test.spc', test.spectrum, test.xaxis)
%
%Example 2:
%        (with X a matrix that contains two spectra)
%    axis{1} = xaxis;
%    axis{2} = 1:2;
%    GSSpcWrite ('d:\test.spc', X, axis)

%Technical data about the SPC-fileformat is freely avaiable and obtained
%from Galactic Industries Corp: see gspc_udf.pdf available at:
%    https://ftirsearch.com/features/converters/SPCFileFormat.htm
%

%This software package is dual licensed. You can use it according to the term
%of either the GPLv3 or the BSD license.
%
%GSTools: a set of MATLAB functions to read, write and work with SPC spectra in MATLAB
%
%C 2005-2008, Kris De Gussem, Raman Spectroscopy Research Group, Department
%of analytical chemistry, Ghent University
%C2009 Kris De Gussem
%
%This file is part of GSTools.
%
%GSTools is free software: you can redistribute it and/or modify
%it under the terms of the GNU General Public License as published by
%the Free Software Foundation, either version 3 of the License, or
%(at your option) any later version.
%
%GSTools is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.
%
%You should have received a copy of the GNU General Public License
%along with GSTools.  If not, see <http://www.gnu.org/licenses/>.

%Copyright (c) 2004-2009, Kris De Gussem
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without 
%modification, are permitted provided that the following conditions are 
%met:
%
%    * Redistributions of source code must retain the above copyright 
%      notice, this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above copyright 
%      notice, this list of conditions and the following disclaimer in 
%      the documentation and/or other materials provided with the distribution
%    * Neither the name of Raman Spectroscopy Research Group, Department of
%	  analytical chemistry, Ghent University nor the names 
%      of its contributors may be used to endorse or promote products derived 
%      from this software without specific prior written permission.
%      
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%POSSIBILITY OF SUCH DAMAGE.

%History:
%   v0.1:
%      - initial release
%   v0.2:
%      - now correctly interpretes flags in SPC-header, which previously
%      lead to negative peaks, ...
%      - corrected determination whether data are evenly spaced
%   v0.3:
%      - small bugfixes
%      - custom information about the spectrum given by the user, can now
%        be written using a new options parameter
%      - logtxt now supports a cellstring array
%   v0.4:
%      - support for multi-file spc-spectra: due to the nature of MATLAB
%        (more precisely working sith matrices in which each column has a
%        fixed x-value) only multi-dimensional spectra for which the x-axis
%        is the same for all spectra can be written to an SPC-file
%      - spectra in a GSSpcRead structure can be saved 
%   v0.4.1:
%      - some bugfixes related to saving spectra as integers
%      - spectra are now save in float32 format as standard (as is
%        recommended for conversion routines). An extra option is added now
%        to alter this behaviour (only syntax 1).

%Note to the developer:
%This routine is very complex, because of the different input formats that
%are to be considered. The routine is therefore split in different
%subroutines that create and write the different data blocks in the spc
%file (cfr. SPC file format description). Also, some of these subroutines
%are doubled: once for the case that the data are supplied in matrices 
%(syntax 1) and once for the case when the data are supplied in structures
%(see also the name of the subroutines).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%check input
switch nargin
    case 2
        logtxt = [];
        logbin = [];
        options = [];
    case 3
        logtxt = [];
        logbin = [];
        options = [];
    case 4
        logbin = [];
        options = [];
    case 5
        options = [];
    case 6
    otherwise
        error ('GSTools:msg', 'Wrong number of input parameters. See help GSSpcWrite.');
end

if iscellstr(filename)
    filename = filename{1};
end
if ischar (filename) == false
    error ('GSTools:msg', 'GSSpcWrite requires a string containing the spectral filename...');
end

%open the spc-file
[f,msg] = fopen(filename, 'wb', 'l'); %create and open the file for write access, overwrite file if it is present
if f==-1
   disp(msg);
   disp(filename);
   error('GSTools:msg', 'Error creating file...');
end
clear msg;

if nargin > 2
    CreateSPCFileFromMatrices (f, spectra, axis, logtxt, logbin, options);
else
    %we have a structure that contains the spectrum
    CreateSPCFileFromStructure (f, spectra, options);
end

fclose (f);
GSToolsAbout


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CreateSPCFileFromMatrices (f, spectra, axis, logtxt, logbin, options)
%check whether the axis parameter is correctly entered
if iscell (axis) == false
    if isnumeric (axis)
        axis = MakeVector (axis, 'The axis should be a cell-vector...')';
        tmp = axis; clear axis;
        axis{1} = tmp;
        clear tmp
    else
        error ('GSTools:msg', 'The axis parameter must be a cell containing a vector with the axis'' values');
    end
else
    axis{1} = MakeVector (axis{1}, 'Axis should be a cell-vector. The first element contains a row vector with the x-axis values, whereas the second element is the z-axis.')';
end

%check length of axis and spectra
if size (spectra,2) ~= size (axis{1},2)
    error ('GSTools:msg', 'Length of axis and number of spectral channels do not correspond.');
end
if numel(spectra) ~= (sum(size(spectra))-1) %single spectrum?
    if size (spectra,1) ~= size (axis{2},2)
        error ('GSTools:msg', 'Length of axis and number of spectral channels do not correspond.');
    end
end

%now the input parameters should be OK, start with the real work...

%write the spc-header of the spectrum
ThisSpcHdr = CreateSpcHeader (spectra, axis{1}, logtxt, logbin, options);
WriteSpcHeader (f, ThisSpcHdr);

WriteSpectraAndAxis (f, ThisSpcHdr, spectra, axis, options);

%log
if ThisSpcHdr.flogoff
    %if not NULL: then there's a log
    if isempty(logtxt) == false
        if iscellstr (logtxt)
            tmp = [];
            for i=1:length(logtxt)
                tmp = [tmp logtxt{i} '\n'];
            end
            logtxt = tmp;
            clear tmp;
        end
    end
    ThisLogstcHdr = CreateLogstcHeader (logtxt, logbin);
    WriteLogstcHeader (f, ThisLogstcHdr);
    fwrite(f,logbin,'uint8');
    fwrite(f,logtxt,'char');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CreateSPCFileFromStructure (f, spectra, options)
%write the spc-header of the spectrum
[ThisSpcHdr, data, axis] = CreateSpcHeaderFromStructure (spectra, options);
WriteSpcHeader (f, ThisSpcHdr);

WriteSpectraAndAxis (f, ThisSpcHdr, data, axis, options);

logtxt = spectra.log.txt;
if ThisSpcHdr.flogoff
    %if not NULL: then there's a log
    if isempty(logtxt) == false
        if iscellstr (logtxt)
            tmp = [];
            for i=1:length(logtxt)
                tmp = [tmp logtxt{i} '\n']; %sprintf('%s%s\n', tmp, logtxt{i});
            end
            logtxt = tmp;
            clear tmp;
        end
    end
    ThisLogstcHdr = CreateLogstcHeader (logtxt, spectra.log.bin);
    WriteLogstcHeader (f, ThisLogstcHdr);
    fwrite(f,spectra.log.bin,'uint8');
    fwrite(f,logtxt,'char');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ThisSpcHdr = CreateSpcHeader (spectra, axis, logtxt, logbin, options)
%This subfunction will create an spc-header
%f is the file-pointer to the spc-file.
%
%An spc-header has the following structure (extract of the Cpp header file
%of Galactic Industries Corp.): see gspc_udf.pdf for more
%information and technical data. 

[dummy1,dummy2,endian] = computer; %#ok<ASGLU>
clear dummy1 dummy2;

ftflgs = false(1,8);   %BYTE: flags about type of spc-file (see main-function): single-spectrum, multi-spectrum, nr. of bits for an integer, ...
ftflgs(1) = false;     %TSPREC: we want 32 bit precision %Y data blocks are 16 bit integer (only if fexp is NOT 0x80h): 1 = 16 bit integer
ftflgs2.TSPREC = ftflgs(1);
ftflgs(2) = false;     %TCGRAM: normally this flag is not used %Enables fexper in older software (not used)
ftflgs2.TCGRAM = ftflgs(2);

if size (spectra, 1) > 1
    ftflgs(3) = true;  %TMULTI: Multifile data format (more than one subfile)
else
    ftflgs(3) = false; %TMULTI: Multifile data format (more than one subfile)
end
ftflgs2.TMULTI = ftflgs(3);

ftflgs(4) = false;     %TRANDM: If TMULTI and TRANDM then Z values in SUBHDR structures are in random order (not used)
ftflgs2.TRANDM = ftflgs(4);
ftflgs(5) = true;      %TORDRD: If TMULTI and TORDRD then Z values are in ascending or descending ordered but not evenly spaced. Z values readv from individual SUBHDR structures.
ftflgs2.TORDRD = ftflgs(5);
ftflgs(6) = false;     %%std%% %TALABS: Axis label text stored in fcatxt separated by nulls. Ignore fxtype, fytype, fztype corresponding to non-null text in fcatxt.
ftflgs2.TALABS = ftflgs(6);
ftflgs(7) = false;     %TXYXYS: Each subfile has unique X array; can only be used if TXVALS is also used. Used exclusively to flag as MS data for drawing as “sticks” rather than connected lines.
ftflgs2.TXYXYS = ftflgs(7);

%check whether data are evenly spaced
nr = length (axis);
ind = 2:1:nr;
ind2 = 1:1:nr-1;
diff = axis(ind) - axis(ind2);
if range(diff) > 1E-8 %if not evenly spaced then intervals will be higher than 0 (or higher than a very low number due to CPU-precision)
    ftflgs(8) = 1; %TXVALS: Non-evenly spaced X data. File has X value array preceding Y data block(s).
else
    ftflgs(8) = 0;
end
ftflgs2.TXVALS = ftflgs(8);
clear diff EvenlySpaced;

if endian == 'B' %needs to be checked!
    ftflgs = flipud(ftflgs);
end

ThisSpcHdr.ftflgs = ftflgs; clear ftflgs
ThisSpcHdr.ftflgs2 = ftflgs2; clear ftflgs2

ThisSpcHdr.fversn = 75;              % BYTE: version of the spc file: currently two versions exists, only the newer is supported
if isfield (options, 'fexper')
    ThisSpcHdr.fexper = options.fexper;
else
    ThisSpcHdr.fexper = 11;              %%std%% %type of experiment: 11: Raman spectrum: see SPC-file formate description for meanings.
end
if isfield (options,'SaveHighPrecision')
    if options.SaveHighPrecision == 1
        SaveAsFloats = 0;
    else
        SaveAsFloats = 1;
    end
else
    SaveAsFloats = 1;
end
if SaveAsFloats
    ThisSpcHdr.fexp = 128;
else
    ThisSpcHdr.fexp = OptimalPower (spectra(1,:)); % char: Fraction scaling exponent integer (80h = 128 decimal => spec values are float variables)
end
ThisSpcHdr.fnpts = nr;               % DWORD: number of points
ThisSpcHdr.ffirst = axis(1);         % double: Floating X coordinate of first point
ThisSpcHdr.flast = axis(nr);         % double: Floating X coordinate of last point
ThisSpcHdr.fnsub = size(spectra, 1); % DWORD: Integer number of subfiles (1 if not TMULTI)

if isfield (options, 'xunit')
    ThisSpcHdr.fxtype = options.xunit;              %%std%%%BYTE: Type of X units
else
    ThisSpcHdr.fxtype = 13;              %%std%%%BYTE: Type of X units
end
if isfield (options, 'yunit')
    ThisSpcHdr.fytype = options.yunit;              %%std%%%BYTE: Type of Y units
else
    ThisSpcHdr.fytype = 0;               %%std%%%BYTE: Type of Y units
end
if isfield (options, 'zunit')
    ThisSpcHdr.fztype = options.zunit;              %%std%%%BYTE: Type of z units
else
    ThisSpcHdr.fztype = 0;               %%std%%%BYTE: Type of Z units
end
ThisSpcHdr.fpost = 0;                % BYTE   fpost;  /* Posting disposition (see GRAMSDDE.H) */
ThisSpcHdr.fdate = CalcSpecDateTime; % DWORD  fdate;  /* Date/Time LSB: min=6b,hour=5b,day=5b,month=4b,year=12b */


tmp = zeros(1,9);
tmp(1:8) = uint8('Math det');
ThisSpcHdr.fres = tmp;               % char fres[9]; /* Resolution description text (null terminated) */
clear tmp;

tmp = zeros(1,9);
if isfield(options, 'fsource')
    le = length(options.fsource);
    if le > 9
        warning ('GSTools:msg', 'instrument source string is to long, it will be cut...')
        options.fsource = options.fsource(1:9);
        le = 9;
    end
    tmp(1:le) = uint8(options.fsource);
else
    tmp(1:5) = uint8('GSSpc');
end
ThisSpcHdr.fsource = tmp;            % char fsource[9]; /* Source instrument description text (null terminated) */
clear tmp;

ThisSpcHdr.fpeakpt = 0;              % WORD fpeakpt; /* Peak point number for interferograms (0=not known) */
ThisSpcHdr.fspare = zeros (1,8);     % float fspare[8]; /* Used for Array Basic storage */
tmp = zeros (1,130);    % char fcmnt[130]; /* Null terminated comment ASCII text string */
if isfield (options, 'fcmnt')
    le = length(options.fcmnt);
    if le > 130
        warning ('GSTools:msg', 'file comment string is to long, it will be cut...')
        options.fcmnt = options.fcmnt(1:130);
        le = 130;
    end
    tmp(1:le) = options.fcmnt;
else
    tmp(1:28) = uint8('Created by GSSpcWrite v0.4.1') ;
end
ThisSpcHdr.fcmnt = tmp;

ThisSpcHdr.fcatxt = zeros (1,30);

if isempty (logtxt) && isempty (logbin)
    ThisSpcHdr.flogoff = 0; % DWORD flogoff; /* File offset to log block or 0 (see above) */
else
    %offset= size (SPC-header) + size (xaxis) + nr_spec (size(sub-header) + size(spectrum)
    offset = 512 + (ThisSpcHdr.ftflgs2.TXVALS * 4 * length (axis)) + size (spectra, 1) * (32 + 4 * length (axis));
    ThisSpcHdr.flogoff = offset;
end

ThisSpcHdr.fmods = 0;   % DWORD fmods; /* File Modification Flags (see below: 1=A,2=B,4=C,8=D..) */
ThisSpcHdr.fprocs = 0;  % BYTE fprocs; /* Processing code (see GRAMSDDE.H) */
ThisSpcHdr.flevel = 1;  % BYTE flevel; /* Calibration level plus one (1 = not calibration data) */
ThisSpcHdr.fsampin = 1; % WORD fsampin; /* Sub-method sample injection number (1 = first or only ) */
ThisSpcHdr.ffactor = 1; % float ffactor; /* Floating data multiplier concentration factor (IEEE-32) */
tmp = zeros(1,48);  % char fmethod[48]; /* Method/program/data filename w/extensions comma list */
if isfield (options, 'fmethod')
    le = length(options.fmethod);
    if le > 48
        warning ('GSTools:msg', 'Program string is to long, it will be cut...')
        options.fmethod = options.fmethod(1:48);
        le = 48;
    end
    tmp(1:le) = options.fmethod;
else
    tmp(1:28) = uint8('Created by GSSpcWrite v0.4.1') ;
end
ThisSpcHdr.fmethod = tmp;
clear tmp;
ThisSpcHdr.fzinc = 0;  % float fzinc; /* Z subfile increment (0 = use 1st subnext-subfirst) */
ThisSpcHdr.fwplanes = 0;% DWORD fwplanes; /* Number of planes for 4D with W dimension (0=normal) */
ThisSpcHdr.fwinc = 0;  % float fwinc; /* W plane increment (only if fwplanes is not 0) */
ThisSpcHdr.fwtype = 0;    % BYTE fwtype; /* Type of W axis units (see definitions below) */
ThisSpcHdr.freserv = zeros(1,187); % char freserv[187]; /* Reserved (must be set to zero) */


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ThisSpcHdr, data, axis2] = CreateSpcHeaderFromStructure (spectra, options)
%This subfunction will create an spc-header
%f is the file-pointer to the spc-file.
%
%An spc-header has the following structure (extract of the Cpp header file
%of Galactic Industries Corp.): see gspc_udf.pdf for more
%information and technical data. 

[dummy1,dummy2,endian] = computer; %#ok<ASGLU>
clear dummy1 dummy2;

ftflgs = false(1,8);   %BYTE: flags about type of spc-file (see main-function): single-spectrum, multi-spectrum, nr. of bits for an integer, ...
ftflgs(1) = false;     %TSPREC: we want 32 bit precision %Y data blocks are 16 bit integer (only if fexp is NOT 0x80h): 1 = 16 bit integer
ftflgs2.TSPREC = ftflgs(1);
ftflgs(2) = false;     %TCGRAM: normally this flag is not used %Enables fexper in older software (not used)
ftflgs2.TCGRAM = ftflgs(2);

%determine the xaxis
axis = [];
if isfield(spectra, 'xaxis')
    if isempty(spectra.xaxis) == false
        axis{1} = spectra.xaxis;
    end
end
if isempty (axis)
    if isfield(spectra, 'axis')
        if isempty(spectra.axis) == false
            axis{1} = spectra.axis;
        end
    end
end

%determine where we can find the spectrum/spectra
data = [];
if isfield(spectra, 'data')
    if isempty(spectra.data) == false
        data = spectra.data;
    end
end
if isempty (data)
    if isfield(spectra, 'spectra')
        if isempty(spectra.spectra) == false
            if isnumeric (spectra.spectra)
                data = spectra.spectra;
            else
                %Note to the developer: this can generate a bug: we only
                %consider data with the same xaxis
                le = length (spectra.spectra);
                data = zeros (le, size (spectra.spectra(1).data));
                zvalues = zeros (1,le);
                axis{1} = spectra.spectra(1).xaxis;
                for i=1:le
                    data(1,:) = spectra.spectra(i).data;
                    zvalues(i) = spectra.spectra(i).zvalue;
                end
                axis{2} = zvalues;
            end
        else
            error  ('GSTools:msg', 'Error: can not interprete the structure that contains the spectrum/spectra. Can not find a field data or spectra with appropriate data.');
        end
    end
end
axis2 = axis;
axis = axis{1};

if size (data, 1) > 1
    ftflgs(3) = true;  %TMULTI: Multifile data format (more than one subfile)
else
    ftflgs(3) = false; %TMULTI: Multifile data format (more than one subfile)
end
ftflgs2.TMULTI = ftflgs(3);

ftflgs(4) = false;     %TRANDM: If TMULTI and TRANDM then Z values in SUBHDR structures are in random order (not used)
ftflgs2.TRANDM = ftflgs(4);
ftflgs(5) = true;      %TORDRD: If TMULTI and TORDRD then Z values are in ascending or descending ordered but not evenly spaced. Z values readv from individual SUBHDR structures.
ftflgs2.TORDRD = ftflgs(5);
ftflgs(6) = false;     %%std%% %TALABS: Axis label text stored in fcatxt separated by nulls. Ignore fxtype, fytype, fztype corresponding to non-null text in fcatxt.
ftflgs2.TALABS = ftflgs(6);
ftflgs(7) = false;     %TXYXYS: Each subfile has unique X array; can only be used if TXVALS is also used. Used exclusively to flag as MS data for drawing as “sticks” rather than connected lines.
ftflgs2.TXYXYS = ftflgs(7);

%check whether data are evenly spaced
nr = length (axis);
ind = 2:1:nr;
ind2 = 1:1:nr-1;
diff = axis(ind) - axis(ind2);
if range (diff) > 1E-8 %if not evenly spaced then intervals will be higher than 0 (or higher than a very low number due to CPU-precision)
    ftflgs(8) = 1; %TXVALS: Non-evenly spaced X data. File has X value array preceding Y data block(s).
else
    ftflgs(8) = 0;
end
ftflgs2.TXVALS = ftflgs(8);
clear diff EvenlySpaced;

if endian == 'B'
    ftflgs = flipud(ftflgs);
end

ThisSpcHdr.ftflgs = ftflgs; clear ftflgs
ThisSpcHdr.ftflgs2 = ftflgs2; clear ftflgs2

ThisSpcHdr.fversn = 75;              % BYTE: version of the spc file: currently two versions exists, only the newer is supported
if isfield (spectra, 'TechniqueNr')
    ThisSpcHdr.fexper = spectra.TechniqueNr;
else
    ThisSpcHdr.fexper = 11;              %%std%% %type of experiment: 11: Raman spectrum: see SPC-file formate description for meanings.
end
if isfield (options,'SaveHighPrecision')
    if options.SaveHighPrecision == 1
        SaveAsFloats = 0;
    else
        SaveAsFloats = 1;
    end
else
    SaveAsFloats = 1;
end
if SaveAsFloats
    ThisSpcHdr.fexp = 128;
else
    ThisSpcHdr.fexp = OptimalPower (data(1,:)); % char: Fraction scaling exponent integer (80h = 128 decimal => spec values are float variables)
end
ThisSpcHdr.fnpts = nr;               % DWORD: number of points
ThisSpcHdr.ffirst = axis(1);         % double: Floating X coordinate of first point
ThisSpcHdr.flast = axis(nr);         % double: Floating X coordinate of last point
ThisSpcHdr.fnsub = size(spectra, 1); % DWORD: Integer number of subfiles (1 if not TMULTI)
Types = GetSPCAxisTypes(1);
if isfield (spectra, 'xtype')
    ThisSpcHdr.fxtype = LocateItem (spectra.xtype, Types.X, 2);              %%std%%%BYTE: Type of X units
else
    ThisSpcHdr.fxtype = 13;              %%std%%%BYTE: Type of X units
end
if isfield (spectra, 'ytype')
    ThisSpcHdr.fytype = LocateItem (spectra.ytype, Types.Y, 2);              %%std%%%BYTE: Type of Y units
else
    ThisSpcHdr.fytype = 0;               %%std%%%BYTE: Type of Y units
end
if isfield (spectra, 'ztype')
    ThisSpcHdr.fztype = LocateItem (spectra.ztype, Types.X, 2);              %%std%%%BYTE: Type of z units
else
    ThisSpcHdr.fztype = 0;               %%std%%%BYTE: Type of Z units
end

ThisSpcHdr.fpost = 0;                % BYTE   fpost;  /* Posting disposition (see GRAMSDDE.H) */
ThisSpcHdr.fdate = CalcSpecDateTime; % DWORD  fdate;  /* Date/Time LSB: min=6b,hour=5b,day=5b,month=4b,year=12b */

if isfield (spectra, 'Resolution')
    tmp = spectra.Resolution;
    ThisSpcHdr.fres = zeros(1,9);
    if length (tmp) > 8
        tmp = tmp(1:8);
    end
    ThisSpcHdr.fres(1:length(tmp)) = tmp;
else
    tmp = zeros(1,9);
    tmp(1:8) = uint8('Math det');
    ThisSpcHdr.fres = tmp;               % char fres[9]; /* Resolution description text (null terminated) */
    clear tmp;
end

tmp = zeros(1,9);
if isfield (spectra, 'InstrumentSource')
    le = length(spectra.InstrumentSource);
    if le > 9
        warning ('GSTools:msg', 'instrument source string is to long, it will be shortened...')
        spectra.InstrumentSource = spectra.InstrumentSource(1:9);
        le = 9;
    end
    tmp(1:le) = uint8(spectra.InstrumentSource);
else
    tmp(1:5) = uint8('GSSpc');
end
ThisSpcHdr.fsource = tmp;            % char fsource[9]; /* Source instrument description text (null terminated) */
clear tmp;

ThisSpcHdr.fpeakpt = 0;              % WORD fpeakpt; /* Peak point number for interferograms (0=not known) */
ThisSpcHdr.fspare = zeros (1,8);     % float fspare[8]; /* Used for Array Basic storage */

tmp = zeros(1,130);     % char fcmnt[130]; /* Null terminated comment ASCII text string */
if isfield (spectra, 'Comment')
    le = length(spectra.Comment);
    if le > 130
        warning ('GSTools:msg', 'file comment string is to long, it will be cut...')
        spectra.Comment = spectra.Comment(1:130);
        le = 130;
    end
    tmp(1:le) = spectra.Comment;
else
    tmp(1:26) = uint8('Created by GSSpcWrite v0.4') ;
end
ThisSpcHdr.fcmnt = tmp;

ThisSpcHdr.fcatxt = zeros (1,30);

if isempty (spectra.log.txt) && isempty (spectra.log.bin)
    ThisSpcHdr.flogoff = 0; % DWORD flogoff; /* File offset to log block or 0 (see above) */
else
    %offset= size (SPC-header) + size (xaxis) + nr_spec (size(sub-header) + size(spectrum)
    offset = 512 + (ThisSpcHdr.ftflgs2.TXVALS * 4 * length (axis)) + size (data, 1) * (32 + 4 * length (axis));
    ThisSpcHdr.flogoff = offset;
end

ThisSpcHdr.fmods = 0;   % DWORD fmods; /* File Modification Flags */
ThisSpcHdr.fprocs = 0;  % BYTE fprocs; /* Processing code (see GRAMSDDE.H) */
ThisSpcHdr.flevel = 1;  % BYTE flevel; /* Calibration level plus one (1 = not calibration data) */
if isfield(spectra, 'Injection')
    ThisSpcHdr.fsampin = spectra.Injection; % WORD fsampin; /* Sub-method sample injection number (1 = first or only ) */
end
if isfield(spectra, 'ConcentrationFactor')
    ThisSpcHdr.ffactor = spectra.ConcentrationFactor; % float ffactor; /* Floating data multiplier concentration factor (IEEE-32) */
end

tmp = zeros(1,48);  % char fmethod[48]; /* Method/program/data filename w/extensions comma list */
if isfield (spectra, 'Program')
    le = length(spectra.Program);
    if le > 48
        warning ('GSTools:msg', 'Program string is to long, it will be cut...')
        spectra.Program = spectra.Program(1:48);
        le = 48;
    end
    tmp(1:le) = spectra.Program;
else
    tmp(1:26) = uint8('Created by GSSpcWrite v0.4') ;
end
ThisSpcHdr.fmethod = tmp;
clear tmp;

ThisSpcHdr.fzinc = 0;  % float fzinc; /* Z subfile increment (0 = use 1st subnext-subfirst) */
ThisSpcHdr.fwplanes = 0;% DWORD fwplanes; /* Number of planes for 4D with W dimension (0=normal) */
ThisSpcHdr.fwinc = 0;  % float fwinc; /* W plane increment (only if fwplanes is not 0) */
ThisSpcHdr.fwtype = 0;    % BYTE fwtype; /* Type of W axis units (see definitions below) */
ThisSpcHdr.freserv = zeros(1,187); % char freserv[187]; /* Reserved (must be set to zero) */


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fdate = CalcSpecDateTime
% fdate is the date and time the data in the file was collected/stored. This
% is not the same as the date and time stamp put on the SPC file by the
% operating system when it is stored. The information is encoded as
% unsigned integers into a 32-bit value for compactness as follows (most
% significant bit is on the left):
% Minute (6bits) Hour (5 bits) Day (5 bits) Month (4 bits) Year (12 bits)

%it's the reverse way!
fdate = false (1, 32); %predefine 32bit array
date = clock;

Year   = Transform2Bits (date(1), 12);
Month  = Transform2Bits (date(2), 4);
Day    = Transform2Bits (date(3), 5);
Hour   = Transform2Bits (date(4), 5);
Minute = Transform2Bits (date(5), 6);

fdate (1:6)   = Minute;
fdate (7:11)  = Hour;
fdate (12:16) = Day;
fdate (17:20) = Month;
fdate (21:32) = Year;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nrb = Transform2Bits (number, nrbits)
factor = 1;
nrb = false (1,nrbits); %predefine matrix to store the right amount of bits

for i = 1:nrbits
    factor = factor * 2; % to calculate the remainder of respectively 2, 4, 8, ...
    bit = rem (number, factor); %the value of the bit i
    nrb (1,i) = (bit > 0);
    number = number - bit;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WriteSpcHeader (f, ThisSpcHdr)
fwrite(f, ThisSpcHdr.ftflgs, 'ubit1');
fwrite(f, char(ThisSpcHdr.fversn), 'char');
fwrite(f, uint8(ThisSpcHdr.fexper), 'uint8');
fwrite(f, uint8(ThisSpcHdr.fexp), 'uint8');
fwrite(f, uint32(ThisSpcHdr.fnpts), 'uint32');
fwrite(f, (ThisSpcHdr.ffirst), 'float64');
fwrite(f, (ThisSpcHdr.flast), 'float64');
fwrite(f, uint32(ThisSpcHdr.fnsub), 'uint32');
fwrite(f, uint8(ThisSpcHdr.fxtype), 'uint8');
fwrite(f, uint8(ThisSpcHdr.fytype), 'uint8');
fwrite(f, uint8(ThisSpcHdr.fztype), 'uint8');
fwrite(f, uint8(ThisSpcHdr.fpost), 'uint8');
fwrite(f, ThisSpcHdr.fdate, 'ubit1');
fwrite(f, char(ThisSpcHdr.fres), 'char');
fwrite(f, char(ThisSpcHdr.fsource), 'char');
fwrite(f, uint16(ThisSpcHdr.fpeakpt), 'uint16');
fwrite(f, (ThisSpcHdr.fspare), 'float32');
fwrite(f, char(ThisSpcHdr.fcmnt), 'char');
fwrite(f, char(ThisSpcHdr.fcatxt), 'char');
fwrite(f, uint32(ThisSpcHdr.flogoff), 'uint32');
fwrite(f, uint32(ThisSpcHdr.fmods), 'uint32');
fwrite(f, char(ThisSpcHdr.fprocs), 'char');
fwrite(f, char(ThisSpcHdr.flevel), 'char');
fwrite(f, uint16(ThisSpcHdr.fsampin), 'uint16');
fwrite(f, (ThisSpcHdr.ffactor), 'float32');
fwrite(f, char(ThisSpcHdr.fmethod), 'char');
fwrite(f, (ThisSpcHdr.fzinc), 'float32');
fwrite(f, uint32(ThisSpcHdr.fwplanes), 'uint32');
fwrite(f, (ThisSpcHdr.fwinc), 'float32');
fwrite(f, char(ThisSpcHdr.fwtype), 'char');
fwrite(f, char(ThisSpcHdr.freserv), 'char');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ThisSubHdr = CreateSubHeader(data, axis, nr, SaveAsFloats)
%This subfunction will write a sub-header for each spectrum in the
%spc-file. f is the file-pointer to the spc-file.
%
%An sub-header has the following structure (extract of the Cpp header file
%of Galactic Industries Corp.): see gspc_udf.pdf for more
%information and technical data. 

ThisSubHdr.subflgs = 0;                     %standard value for conversion routines   BYTE  subflgs;	/* Flags as defined below */
if SaveAsFloats
    ThisSubHdr.subexp = 128;
else
    ThisSubHdr.subexp = OptimalPower (data(nr+1,:)); %   char  subexp;	/* Exponent for sub-file's Y values (80h=>float) */
end
ThisSubHdr.subindx = nr;                    %   WORD  subindx;	/* Integer index number of trace subfile (0=first) */
if size(data,1) == 1
    ThisSubHdr.subtime = 0;                     %float subtime;	/* Floating time for trace (Z axis corrdinate) */
else
    tmp = axis{2};
    ThisSubHdr.subtime = tmp(nr+1);
end
ThisSubHdr.subnext = 0;                     %Z not yet implemented.   float subnext;	/* Floating time for next trace (May be same as beg) */
ThisSubHdr.subnois = 0;                     %not yet implemented   float subnois;	/* Floating peak pick noise level if high byte nonzero*/
ThisSubHdr.subnpts = 0;         %   DWORD subnpts;	/* Integer number of subfile points for TXYXYS type*/
ThisSubHdr.subscan = 0;                     %This is just or standard Raman collection!   DWORD subscan;	/*Integer number of co-added scans or 0 (for collect)*/
ThisSubHdr.subwlevel = 0;
ThisSubHdr.subresv = repmat (char(0), 1, 4);      %   char  subresv[8];	/* Reserved area (must be set to zero) */


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WriteSubHeader(f, ThisSubHdr)
fwrite(f,ThisSubHdr.subflgs,'uint8');
fwrite(f,ThisSubHdr.subexp,'uint8');
fwrite(f,ThisSubHdr.subindx,'uint16');
fwrite(f,ThisSubHdr.subtime,'float32');
fwrite(f,ThisSubHdr.subnext,'float32');
fwrite(f,ThisSubHdr.subnois,'float32');
fwrite(f,ThisSubHdr.subnpts,'uint32');
fwrite(f,ThisSubHdr.subscan,'uint32');
fwrite(f,ThisSubHdr.subwlevel,'float32');
fwrite(f,ThisSubHdr.subresv,'uchar');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WriteSpectraAndAxis (f, ThisSpcHdr, data, axis, options)
if ThisSpcHdr.ftflgs2.TXVALS == false
    %Evenly spaced X-data: the most common form of spc-files.
    %It is typically used to store data for a single spectrum or
    %chromatogram where the X axis data point spacing is evenly
    %throughout the data array.
else
    % Non-evenly spaced X data. File has X value array preceding Y data block(s).
    fwrite (f, axis{1}, 'float32');
end


%for all spectra in the matrix: write one subfile (header + values)
for i=1:size (data,1)
    %Write sub header of the current spectrum
    if isfield (options, 'SaveHighPrecision')
        if options.SaveHighPrecision
            ThisSubHdr = CreateSubHeader(data, axis, i-1, 0);
        else
            ThisSubHdr = CreateSubHeader(data, axis, i-1, 1);
        end
    else
        ThisSubHdr = CreateSubHeader(data, axis, i-1, 1);
    end
    WriteSubHeader(f, ThisSubHdr);
    
    %write spectrum
    if ThisSubHdr.subexp == 128
        %means spectral values are floating point variables instead of the
        %standard integers
        fwrite (f, data(i,:), 'float32');
    else
        if ThisSpcHdr.ftflgs2.TSPREC
            %Y data blocks are 16 bit integer (only if fexp is NOT 0x80h)
            tmp = data (i,:) .* (2^(16 - (ThisSubHdr.subexp)));
            fwrite (f, int16(tmp), 'int16');
        else
            tmp = data (i,:) .* (2^(32 - (ThisSubHdr.subexp)));
            fwrite (f, int32(tmp), 'int32');
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ThisLogstcHdr = CreateLogstcHeader (logtxt, logbin)
%This subfunction will load a LOGSTC-header in the spc-file.
%f is the file-pointer to the spc-file.
%
%An LOGSTC-header has the following structure (extract of the Cpp header file
%of Galactic Industries Corp.): see gspc_udf.pdf for more
%information and technical data. 

ThisLogstcHdr.logsizd = 64 + length (logtxt) + length (logbin);  % byte size of disk block
ThisLogstcHdr.logsizm = ceil (ThisLogstcHdr.logsizd /4096)*4096; % byte size of memory block
ThisLogstcHdr.logtxto = 64 + length (logbin);                    % byte offset to text
ThisLogstcHdr.logbins = length (logbin);                         % byte size of binary area (after logstc
ThisLogstcHdr.logdsks = 0;                                       % byte size of disk area (after logbins)
ThisLogstcHdr.logspar = repmat(0,1,44);                          % reserved (must be zero)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WriteLogstcHeader (f, ThisLogstcHdr)
fwrite(f,ThisLogstcHdr.logsizd,'uint32'); % byte size of disk block
fwrite(f,ThisLogstcHdr.logsizm,'uint32'); % byte size of memory block
fwrite(f,ThisLogstcHdr.logtxto,'uint32'); % byte offset to text
fwrite(f,ThisLogstcHdr.logbins,'uint32'); % byte size of binary area (after logstc
fwrite(f,ThisLogstcHdr.logdsks,'uint32'); % byte size of disk area (after logbins)
fwrite(f,ThisLogstcHdr.logspar,'char');  % reserved (must be zero)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opw = OptimalPower (spectrum)
%opw = 32 - double(int8(log2(2^32 / max(abs(spectrum (1,:))))))-1; %+1 for sign of integer: intensity values are signed integers
%---> incorrect

%for example if max = 0.1780, then according to the following formule, opw=-2
%thus, we need to make it an uint8 number (as defined by the spc header: char
%opw = 32 - floor(log2(2^32 / max(abs(spectrum (1,:)))))+1; %+1 for sign of integer: intensity values are signed integers
opw = 32 - floor(log2(2^31 / max(abs(spectrum (1,:))))); %equal formula: we should obtain 31 bits for the intensity, while bit 32 is for the sign of the integer
opw = uint8(opw);
opw = double (opw); %MATLAB requires doubles for subtracting values (is used in the functions that call OptimalPower)
