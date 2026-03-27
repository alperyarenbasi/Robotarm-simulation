m = 1.0;     % [kg]    Masse av arm         
l = 0.5;     % [m]     Lengde av arm        
d = 0.1;     % [s^-1]  Dempeparameter       
g = 9.81;    % [m/s^2] Gravitasjon          

% PID-parametere 
Kp = 5.5;
Ki = 5;
Kd = 1.5;

%Referanse vinkel/theta
% Ønsket vinkel robotarmen skal reguleres til.
theta_ref = pi/4;   


% Scenario-flagg (0 = av, 1 = på) - overstyres i run_simulation.m
enable_disturbance = 0;
enable_noise       = 0;

% Forstyrrelse v
dist_time = 6;    % så systemet rekker å stabilisere seg først

% dist_amp velgt som ish 40% av steady-state moment. Stadt state moment
% (u_ss) er moment vi trenger for å holde armen i ro på theta_ref mot
% tyngdekraft
% (u_ss = m*g*l*sin(theta_ref) = 1*9.81*0.5*sin(pi/4) =(ish) 3.5 Nm)
% Stor nok til tydelig utslag i plottet.
dist_amp  = 1.5; 

% noise_power er effekten (variansen) til støyen w.
% std.avvik på støyen = sqrt(noise_power / Ts)
% 1e-6 -> std.avvik = sqrt(1e-6/0.01) = 0.01 rad
% std = 0.01 rad. Tilsvarer ish 1.3% av theta_rad 
% støy i u = Kd * N * std = 1.5 * 20 * 0.01 = 0.3 Nm
% er ish 10% av steady state (u_ss). Det er vel håndterbart av PID. 
noise_power = 1e-6;
noise_seed  = 23;   % Tilfeldig seed (for reproduserbarhet)
Ts          = 0.01; % [s] Sampletid for støyblokk. trenger høy Hz for å simulere realistisk støy her.
