% load parameters
params;
disp('Parameters loaded');

% simulate using simulink model
sim_outputs = sim('drehzahlregelung_pi_regler_stoerung', 'StopTime', '30');
disp('Simulation completed.');

% extract data from simulink
y_f = sim_outputs.logsout.get('Führungsgröße').Values; % Führungsgröße extrahieren
y_s = sim_outputs.logsout.get('Stellgröße').Values; % Stellgröße extrahieren
y_r = sim_outputs.logsout.get('Regelgröße').Values; % Regelgröße extrahieren
y_st = sim_outputs.logsout.get('Störung').Values; % Störung extrahieren

% change units
y_st.Data = y_st.Data * 1e3; % convert Nm to mNm


% plot results 
figure('Name', 'Simulation der pi-Regelung mit Störung');

subplot(2, 2, 1);
grid on;
plot(y_f.Time, y_f.Data, 'b', 'LineWidth', 1.5);
ylabel('Führungsgröße [rad/s]');
xlabel('Zeit [s]');
title('Führungsgröße');

subplot(2, 2, 2);
grid on;
plot(y_s.Time, y_s.Data, 'r', 'LineWidth', 1.5);
ylabel('Stellgröße [V]');
xlabel('Zeit [s]');
title('Stellgröße');

subplot(2, 2, 3);
grid on;
plot(y_r.Time, y_r.Data, 'g', 'LineWidth', 1.5);
ylabel('Regelgröße [rad/s]');
xlabel('Zeit [s]');
title('Regelgröße');

subplot(2, 2, 4);
grid on;
plot(y_st.Time, y_st.Data, 'm', 'LineWidth', 1.5);
ylabel('Störung [mNm]');
xlabel('Zeit [s]');
title('Störung');

exportgraphics(gcf, './lab3/images/a4_pi_regelung_sim_100rad_stoerung_seperate.png', 'Resolution', 300);


% plot results 
figure('Name', 'Simulation der pi-Regelung mit Störung');
hold on;
grid on;
plot(y_f.Time, y_f.Data, 'b', 'LineWidth', 1.5);
plot(y_s.Time, y_s.Data, 'r', 'LineWidth', 1.5);
plot(y_r.Time, y_r.Data, 'g', 'LineWidth', 1.5);
plot(y_st.Time, y_st.Data, 'm', 'LineWidth', 1.5);
ylabel('Werte');
xlabel('Zeit [s]');
legend('Führungsgröße [rad/s]', 'Stellgröße [V]', 'Regelgröße [rad/s]', 'Störung [mNm]', 'Location', 'best', 'FontSize', 14);
title('Simulationsergebnisse der pi-Regelung mit 100 rad/s Führungsgröße');
hold off;
set(gcf, 'Position', [100, 100, 1200, 800]);
exportgraphics(gcf, './lab3/images/a4_pi_regelung_sim_100rad_stoerung.png', 'Resolution', 300);