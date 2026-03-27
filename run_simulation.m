% Kjører alle scenariene og plotter resultatene.

clear;      % sletetr alle variabler
clc;        % tømmer terminal
close all;  % lukker alle vindu
params;     % kjører params.m 

%% Kjør scenariene

% NOMINELL
enable_disturbance = 0;
enable_noise       = 0;
out   = sim('robotarm_disturbance'); %Disturbanse uten noise = vanlig
x1{1} = out.x1_out;
u{1}  = out.u_out;

% FORSTYRRELSE
enable_disturbance = 1;
out   = sim('robotarm_disturbance');
x1{2} = out.x1_out;
u{2}  = out.u_out;

% STØY
enable_disturbance = 0;
enable_noise       = 1;
out   = sim('robotarm_noise');
x1{3} = out.x1_out;
u{3}  = out.u_out;

%% Plot alle scenariene
plot_scenario(x1{1}, u{1}, 'Nominell',          theta_ref);
%animate_arm(x1{1}, l, theta_ref, Ts, 'Nominell');
print_ytelse(x1{1}, 'Nominell' , theta_ref);
fprintf('\n')


plot_scenario(x1{2}, u{2}, 'Med forstyrrelse v', theta_ref);
%animate_arm(x1{2}, l, theta_ref,0.1, 'Med forstyrrelse v');
print_ytelse(x1{2}, 'Med forstyrrelse v', theta_ref);
fprintf('\n')


plot_scenario(x1{3}, u{3}, 'Med målestøy w',     theta_ref);
%animate_arm(x1{3}, l, theta_ref, Ts, 'Med målestøy w');
print_ytelse(x1{3}, 'Med målestøy w', theta_ref);
fprintf('\n')



%% Funksjoner

function plot_scenario(x1, u, tittel, theta_ref)
% HVA:    Plotter vinkel og styreinngang for ett scenario.
    figure('Color','white');

    ax1 = subplot(2,1,1);
    plot(x1.Time, x1.Data, 'b', ...
         x1.Time, theta_ref*ones(size(x1.Time)), 'r--', ...
         'LineWidth', 1.5);
    set(ax1, 'Color','white', 'XColor','black', 'YColor','black');
    ylabel('x_1 = \theta [rad]');
    title(tittel);
    legend('x_1(t)', '\theta_{ref}');
    grid on;

    ax2 = subplot(2,1,2);
    plot(u.Time, u.Data, 'r', 'LineWidth', 1.5);
    set(ax2, 'Color','white', 'XColor','black', 'YColor','black');
    ylabel('u = \tau [Nm]');
    xlabel('Tid [s]');
    ylim([min(u.Data)*1.1, max(u.Data)*1.1]);
    grid on;
end


function print_ytelse(x1, tittel, theta_ref)
% HVA:    Printer ytelsesmetrikker for ett scenario via stepinfo() fra
%         contol systems toolbox
    info = stepinfo(x1.Data, x1.Time, theta_ref);

    fprintf('\n--- %s ---\n', tittel);
    fprintf('  Stigetid (t_r):       %.3f s\n', info.RiseTime);
    fprintf('  Oversving:            %.1f %%\n', info.Overshoot);
    fprintf('  Innsvingstid (t_s):   %.3f s\n', info.SettlingTime);
    %bruker siste 10% av datatil å regne stasjonærfeilen
    e_ss = abs(mean(x1.Data(round(0.9*end):end)) - theta_ref);  
    fprintf('  Stasjonærfeil (e_ss): %.4f rad (%.2f %%)\n', e_ss, ...
        e_ss/theta_ref*100);
end


function animate_arm(x1, l, theta_ref, Ts, tittel)
% HVA:    Animerer robotarmen basert på simuleringsdata.
%         Brukt til debugging. Fikk hjelp av chatgpt på denne. Kan egt
%         slettes
    t_data  = x1.Time;
    x1_data = x1.Data;

    hfig = figure('Color','white');
    hax  = axes(hfig, 'Color','white', 'XColor','black', 'YColor','black');
    axis(hax, 'equal'); hold(hax, 'on'); grid(hax, 'on');
    xlim(hax, [-0.6 0.6]); ylim(hax, [-0.6 0.6]);
    xlabel(hax, 'x [m]'); ylabel(hax, 'y [m]');

    % Pivot
    plot(hax, 0, 0, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');

    % Referanseposisjon (stiplet)
    plot(hax, [0, l*sin(theta_ref)], [0, -l*cos(theta_ref)], 'r--', 'LineWidth', 1.5);

    % Arm og masse
    arm  = line(hax, [0 0], [0 -l], 'Color', 'b', 'LineWidth', 4);
    mass = plot(hax, 0, -l, 'bo', 'MarkerSize', 14, 'MarkerFaceColor', 'b');

    for k = 1:1:length(t_data)
        if ~ishandle(hfig), break; end  % stopp hvis vinduet er lukket
        theta_k = x1_data(k);
        ax_tip  = l * sin(theta_k);
        ay_tip  = -l * cos(theta_k);

        set(arm,  'XData', [0 ax_tip], 'YData', [0 ay_tip]);
        set(mass, 'XData', ax_tip,     'YData', ay_tip);
        title(hax, sprintf('%s  |  t = %.2f s', tittel, t_data(k)));
        drawnow;
        pause(Ts);
    end
end
