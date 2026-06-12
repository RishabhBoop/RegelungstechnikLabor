m = 10e-3; % 10g in kg
ci = 0.01; % 0.01 N/A in N/A
cy = 1; % 0.01 N/cm in N/m
L = 0.1; % 0.1H in H
R = 5; % 5 Ohm in Ohm


% ------ P Regler ------
K_Rs = [500, 550, 560, 600, 607, 1000]; % P-Regler Verstärkungen
sat_upper_limit = 6; % upper limit for saturation in V; 6V
sat_lower_limit = -6; % lower limit for saturation in V; -6V
integrator_sat_upper = 5e-3; % 5mm upper limit
integrator_sat_lower = -5e-2; % -5cm lower limit
y0 = -1e-3; % initial position in m; 1mm

% ------ PD Regler ------
K_R = 4/1e-3; % P-Anteil Verstärkung in V/m; 4V/mm
T_Vs = [2e-2, 3e-2, 5e-2, 1e-1, 5e-1, 1]; % D-Anteil Zeitkonstanten in s; [0.01s, 0.05s, 0.1s, 0.5s, 1s]