function [X, extKF] = ExtKalman(extKF, odo, X, y, u, t)

%%%%%%%%%%%%%%%%%%%%%%% Jacobian Matrices %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    A = [1, 0, -odo(1)*sin(X(3))
         0, 1, odo(1)*cos(X(3))
         0, 0, 1];
        
    E = [cos(X(3)), 0
         sin(X(3)), 0
         0, 1];
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     

    % Model Prediction
    extKF.xK = X + [(odo(1))*cos(X(3))
                     (odo(1))*sin(X(3))
                     odo(2)];
    extKF.P = A*extKF.P*A' + E*extKF.Q*E';
    
    if mod(t,extKF.DT) == 0
        Lk = extKF.P/(extKF.P+extKF.R);
        
        % Measurement Update
        X = extKF.xK + Lk*(y - extKF.xK);
        extKF.P = extKF.P - Lk*extKF.P;
        
    else
        X = extKF.xK;
    end     