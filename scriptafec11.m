% Given power
P = 10e3;           % Power in watts

% Assumed and given voltages
Vbat = 800;         % Battery voltage (V)
Vll = 400;          % Grid voltage (V)
Vdcref = 757;       % DC reference voltage for modulation index m = 0.826

% Large capacitance to minimize voltage ripple
C1 = 750e-6;        % Capacitance in Farads

% Battery resistance calculation based on power and voltage differences
Rbat = (P / Vdcref) * (Vbat - Vdcref); % Battery resistance

% Angular frequency for a balanced 50Hz grid
w = 2 * pi * 50;    % Grid angular frequency (rad/s)

% Parameters for inductive reactance
l = 4.8e-3;           % Inductance in Henrys
r = 0.0045;          % Resistance in Ohms

% Gain factor for controlling d-axis current (based on Vdcref)
ka = Vdcref / 2;

% Precharge time, PLL time, and controller start times
t_precharge = 1;  % Precharge time in seconds
t_pll = 1.3;        % Time when PLL starts (in seconds)
t_c = 1.5;          % Time when current controller starts (in seconds)
t_v = 1.75;         % Time when voltage controller starts (in seconds)

% q-axis voltage for control
Vq = 1.5 * sqrt(2) * Vll / sqrt(3); % q-axis reference voltage

% Switching frequency and filter time constant
fsw = 5e3;        % Switching frequency (Hz)
tau_fl = 1 / 200;   % Filter time constant (seconds)

%% Current controller - d-axis current control loop parameters
% Set frequency for current controller, 1/10 of switching frequency
fbi = fsw/ 25;           % Frequency for current controller feedback
ka=Vdcref/2;
% Proportional and integral gains for the d-axis current controller
kii_1 = 2*pi*fbi*r/ka;              % Proportional gain for d-axis current controller
kpi_1 = 2*pi*fbi*l/ka;                % Integral gain for d-axis current controller

% Time constant for d-axis current controller, based on resistance and gain
tau_il = r / ka / kii_1;    % Time constant for d-axis current controller

%% Voltage Controller - Parameters for voltage control loop
% Voltage control loop gain (ratio of q-axis voltage to reference DC voltage)
kl = Vq / Vdcref;             % Voltage control loop gain

% Total time constant for voltage controller, including filter and current control
tau_1l = tau_fl + tau_il;     % Total time constant for voltage controller

% Desired phase margin for the voltage controller (converted to radians)
PM = pi * 75 / 180;           % Phase margin (75 degrees in radians)

% Lead-lag controller parameter for voltage control
a_l = tan(PM) + sqrt((tan(PM))^2 + 1);  % Lead-lag parameter for voltage loop

% Proportional gain for voltage controller based on capacitance and time constant
% Integral gain for voltage controller, derived from lead-lag design
% Adjusted proportional gain for voltage controller, considering time constant and lead-lag design
kpw_1 =C1 / kl / a_l / tau_1l;   % Adjusted proportional gain for voltage controller
% Adjusted integral gain for voltage controller, considering the time constant and lead-lag design
kiw_1 =kpw_1 / (a_l^2 * tau_1l);     % Adjusted integral gain for voltage controller

%% PLL Controller
% PLL controller gain for phase-locked loop control
pll_gain = 1.75;               % PLL controller gain (value assumed)

% End of parameter setup
