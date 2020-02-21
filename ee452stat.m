%% EE 452 Statistical Analysis
%
% Author: Chase Timmins
% Create Date: 2/13/20
% Last Modified: 2/13/20
%
% Description:
%   This function operates on a two arrays of data, the first being time
%   domain data and the second being the dependent variable, usually
%   voltage. The function outputs three data sets, both their dependent and
%   independent variables: Probability Density Function (PDF), Power
%   Spectral Density (PSD), and Auto Correlation Function (ACF).
%
% Use: 
%   >> [acf,pdf,psd] = ee452stat(t,v);
%
% Inputs:
% -------------------------------------------------------------------------
% Name              Type            Description
% -------------------------------------------------------------------------
% t                 double[]        Double array of time data
%
% v                 double[]        Double array of voltage data
% -------------------------------------------------------------------------
%
% Outputs:
% -------------------------------------------------------------------------
% Name          Type                Description
% -------------------------------------------------------------------------
% pdrf          struct{dbl,dbl,dbl} Structure variable that contains two 
%                                   arrays of doubles: 'x' and 'y'
%
% acf           struct{dbl,dbl}     Structure variable that contains two
%                                   arrays of doubles: 'h' and 'n'
%
% psdx          struct{dbl,dbl}     Structure Variable that contains two
%                                   arrays of doubles: 'h' and 'f'
% -------------------------------------------------------------------------
%
% Change Log:
% 0.0 - Creation (CT, FEB.13.20)
function [acf, prdf, psdx] = ee452stat(t,v)
%% PSD
N = length(v);
v_fft = fft(v);
v_fft = v_fft(1:floor(N/2) + 1);

Fs = 1/(t(2) - t(1));

psd_h = (1/(N)*abs(v_fft)).^2/Fs;
psd_h(2:end-1) = 2*psd_h(2:end-1);
freq = 0:Fs/N:Fs/2;

% remove DC Offset
psd_h(1) = 0;
psdx.h = psd_h;
psdx.f = freq;

%% ACF
acf_h = xcorr(v);
acf_n = -1*(floor(length(acf_h)/2)):(floor(length(acf_h)/2));

acf.h = acf_h;
acf.n = acf_n;

%% PDF
max_v = max(v);
min_v = min(v);
n = 15;
span = (max_v - min_v)/(n - 1);

pdf_x = min_v:span:max_v;
pdf_y = zeros(size(pdf_x));

for ii = 1:length(pdf_x)
    for jj = 1:N
        if ((v(jj) > pdf_x(ii) - span/2) && (v(jj) <= pdf_x(ii) + span/2))
            pdf_y(ii) = pdf_y(ii) + 1;
        end
    end
end

prdf.x = pdf_x;
prdf.y = pdf_y/N;
end