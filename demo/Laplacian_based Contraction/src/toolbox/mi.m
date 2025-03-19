function I=mi(X,Y,varargin) 
%MI Determines the mutual information of two images or signals
%
%   I=mi(X,Y)   Mutual information of A and B, using 256 bins for
%   histograms
%   I=mi(X,Y,Bin_count) Mutual information of A and B, using L bins for histograms
%
%   Assumption: 0*log(0)=0
%
%   See also ENTROPY.

%   jfd, 15-11-2006
%        01-09-2009, added case of non-double images
%        24-08-2011, speed improvements by Andrew Hill
%        18-04-2024, corrected by Qingmeng Wen

if nargin>=3
    Bin_count=varargin{1};
else
    Bin_count=round(length(X)/10);
    if Bin_count<10
        Bin_count=10;
    end
end

X=double(X(:)); 
Y=double(Y(:)); 
     
Nx = hist(X,Bin_count); 
Px = Nx/sum(Nx);
Hx=get_entropy(Px);

Ny = hist(Y,Bin_count); 
Py = Ny/sum(Ny);
Hy=get_entropy(Py);

Nxy = hist3([X,Y],'nbins',[Bin_count,Bin_count]); 
Nxy=Nxy(:);
Pxy = Nxy/sum(Nxy);
Hxy=get_entropy(Pxy);
% standard mutual information
I=Hx+Hy-Hxy;
% Normilised mutual information
I=2*I/(Hx+Hy);


% -----------------------

function y=get_entropy(p)
p=p(p>eps); % function support 
y=-sum(p.*log2(p));
