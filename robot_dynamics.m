function x2_dot = robot_dynamics(u, x1, x2, m, l, d, g)
% HVA:   Beregner vinkelakselerasjonen x2_dot for robotarmen.
%        Implementerer formel (11) fra modelleringsavsnittet
%
% INNGANG:
%   u   - påført moment [Nm]         (= tau,        formel (9))
%   x1  - vinkel [rad]               (= theta,      formel (9))
%   x2  - vinkelhastighet [rad/s]    (= theta_dot,  formel (9))
%   m, l, d, g - systemparametere    (se params.m)så
%
% UTGANG:
%   x2_dot - vinkelakselerasjon [rad/s^2] (formel 11 - tilstandsform)

x2_dot = -(g/l)*sin(x1) - d*x2 + (1/(m*l^2))*u;
end
