function u = calcInput(q ,u, W_goal)
global C;
T = transl2(q(1),q(2)) * trot2(q(3));
T_goal = T \ [W_goal;1];
eY = T_goal(2);
u(1) = atan( 2*eY*C.L / C.Ld^2 );
u(2) = C.Vmax;

end