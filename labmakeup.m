
Line = input('Enter the line.','s')
switch Line
    case 'A'
        disp('This train arrives every 24 minutes.')
    case 'B'
        disp('This train arrives every 18 minutes.')
    case 'C'
        disp('This train arrives every 12 minutes.')
    case 'D'
        disp('This train arrives every 18 minutes.')
    case 'E'
        disp('This train arrives every 30 minutes.')
    otherwise
        disp('This train is not in service.')
end