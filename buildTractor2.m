%% Building Tractor

function buildTractor2(len, width)
global tractor;
X = [ 0 len len 0];
Y = [ -width/2 -width/2 width/2 width/2];
%tractorplot = patch(X,Y,'red');
%set(tractorplot,'Visible','off');
tractor = [X;Y;ones(1,length(X))]; 
end