% ---------------- params for Regelstrecke ----------------
% step block parameters for Regelstrecke
init_value = 0; % initial value 0V
final_value = 10; % final value 10V
step_time = 1; % jump at 1s
sample_time = 0;

% motor parameters for Regelstrecke
K=30e-3; % in Nm/A; 30 mN*m/A
J=0.4e9; % in m^2; 4000
R=6; % in ohm; 6 Ohm
L=120e-6; % in H; 120µH

% ---------------- params for saturation block ----------------
sat_min = -10; % minimum value
sat_max = 10; % maximum value

% ---------------- params for p-Regler ----------------
Kr = 0.5; 

init_value_regler = 0; % initial value 0V
final_value_regler = 100; % final value 10V
step_time_regler = 1; % jump at 1s
sample_time_regler = 0;