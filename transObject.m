function transObject(robotObject,T)

T = [
    T(1,1), T(1,2), 0, T(1,3);
    T(2,1), T(2,2), 0, T(2,3);
    0 0 1 0;
    0 0 0 1
    ];

robotObject.Matrix = T;

end