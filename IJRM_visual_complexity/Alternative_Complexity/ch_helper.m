function CH = ch_helper(color1, color2)

a1 = color1(2);
b1 = color1(3);
a2 = color2(2);
b2 = color2(3);
L1 = color1(1);
L2 = color2(1);

angle1 = atand(b1/a1);
angle2 = atand(b2/a2);

C1 = sqrt(a1^2+b1^2);
C2 = sqrt(a2^2+b2^2);

delta_Cab = abs(C1-C2);
delta_Hab = abs(angle1-angle2);
delta_L = abs(L1-L2);
Lsum = L1+L2;



delta_C = sqrt(delta_Hab^2 + (delta_Cab/1.46)^2);
HC = 0.04 + 0.53 *tanh(0.8-0.045*delta_C);


HLsum = 0.28+0.54*tanh(-3.88+0.029*Lsum);
Hdelta_L = 0.14+0.15*tanh(-2+0.2*delta_L);
HL = HLsum + Hdelta_L;

EC1 = 0.5+0.5*tanh(-2+0.5*C1);
EC2 = 0.5+0.5*tanh(-2+0.5*C2);

HS1 = -0.08-0.14*sin(angle1+50)-0.07*sin(2*angle1+90);
HS2= -0.08-0.14*sin(angle2+50)-0.07*sin(2*angle2+90);

Ey1 = (0.22*L1-12.8)/10 * exp((90-angle1)/10-exp((90-angle1)/10));
Ey2 = (0.22*L1-12.8)/10 * exp((90-angle2)/10-exp((90-angle2)/10));

HSY1 = EC1*(HS1+Ey1);
HSY2 = EC2*(HS2+Ey2);

HH = HSY1+HSY2;

CH = HC+HL+HH;