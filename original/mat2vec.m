function out = mat2vec(in, varargin)
%% Transform matrix into vector
%
% out = Mat2Vec(in, ...)
%
% Input parameters (required):
%
% in : Matrix to be transformed into a vector. (array)
%
% Input parameters (parameters):
%
% Parameters are either struct with the following fields and corresponding
% values or option/value pairs, where the option is specified as a string.
%
% -
%
% Input parameters (optional):
%
% The number of optional parameters is always at most one. If a function takes
% an optional parameter, it does not take any other parameters.
%
% scheme : How the entries will be labeled. If 'col' then the entries will be
% traversed column-wise. If 'row' the entries will be traversed row-wise.
% Default is the column-wise order (coincides with the standard Matlab
% ordering). (string)
%
% Output parameters:
%
% out : vector containing the entries of the input matrix.
%
% Output parameters (optional):
%
% -
%
% Description:
%
% Transforms a 2d array into a vector by running either column-wise or row-wise
% over all the entries.
%
% Example:
%
% X = [1 4 7 ; 2 5 8 ; 3 6 9 ];
% Mat2Vec(X,'col')
% Mat2Vec(X,'row')
%
% See also subsref, transpose, Vec2Mat

% Copyright 2013 Laurent Hoeltgen <laurent.hoeltgen@gmail.com>
%
% This program is free software; you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free Software
% Foundation; either version 3 of the License, or (at your option) any later
% version.
%
% This program is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
% details.
%
% You should have received a copy of the GNU General Public License along with
% this program; if not, write to the Free Software Foundation, Inc., 51 Franklin
% Street, Fifth Floor, Boston, MA 02110-1301, USA.

% Last revision on: 23.02.2013 17:23

%% Notes

%% Parse input and output.

narginchk(1, 2);
nargoutchk(0, 1);

parser = inputParser;
parser.FunctionName = mfilename;
parser.CaseSensitive = false;
parser.KeepUnmatched = true;
parser.StructExpand = true;

parser.addRequired('in', @(x) validateattributes(x, {'numeric'}, ...
    {'2d'}, mfilename, 'in'));

parser.addOptional('scheme', 'col', ...
    @(x) any(strcmpi(validatestring(x, {'col', 'row'}, mfilename), ...
    {'col', 'row'})));

parser.parse(in, varargin{:});
opts = parser.Results;

%% Run code.

switch opts.scheme
    case 'col'
        out = subsref(in,substruct('()',{':'}));
    case 'row'
        out = subsref(transpose(in),substruct('()',{':'}));
end

end