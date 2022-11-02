clc
pkg load symbolic
syms x y z
_to_Vector = @(z) [real(z),imag(z)]
matricula = [1,1,9,2,1,1,1,1,0]
X = sum(matricula)*j
porcentagem = (sum(matricula(5:8))/2)/100

f1 = 60
f2 = f1+f1*porcentagem

#Para o item 1 faça w2 = w1;
#Para o item 2 faça w2 = 2*pi*f2;
w1 = 2*pi*f1
w2 = 2*pi*f2;
R80_OHMS = 80;
R40_OHMS = 40;

Zj100_OHMS = j*100;
Zj50_OHMS = j*50;
Zj80_OHMS = j*80;
ZM1 = X;
ZM2 = j*50;
ZM3 = j*10;
ZC = 20/j

C = 1/((ZC)*w1*j)
L100 = Zj100_OHMS/(j*w1)
L50 = Zj50_OHMS/(j*w1)
L80 = Zj80_OHMS/(j*w1)
LM1 = ZM1/(j*w1)
LM2 = ZM2/(j*w1)
LM3 = ZM3/(j*w1)

_Zj100_OHMS = L100*j*w2
_Zj80_OHMS  =  L80*j*w2
_Zj50_OHMS  =  L50*j*w2
_ZM1 = LM1*j*w2
_ZM2 = LM2*j*w2
_ZM3 = LM3*j*w2
_ZC  =  1/(j*w2*C)


Eq1 = simplify( _Zj50_OHMS*(x-z) + _ZM1*(x-y) + _ZM2*z + _Zj80_OHMS*(x-y) + _ZM1*(x-z) + _ZM3*z )
Eq2 = simplify( (R40_OHMS + _ZC)*(y-z) - _Zj80_OHMS*(x-y) -  _ZM3*z - _ZM1*(x-z))
Eq3 = simplify( _Zj100_OHMS*z + _ZM2*(x-z) + _ZM3*(x-y) +  R80_OHMS*z - (R40_OHMS + _ZC)*(y-z) -_Zj50_OHMS*(x-z) - _ZM1*(x-y) - _ZM2*z )
V1 = 60;
V2 = 20*j;

A = [
     double(coeffs(Eq1,[z,y,x]));
     double(coeffs(Eq2,[z,y,x]));
     double(coeffs(Eq3,[z,y,x]));
     ];
A
B = [V1;-V2;0]

R = solve(Eq1 == B(1),Eq2 == B(2),Eq3 == B(3),[x,y,z]);
x = double(R.x)
y = double(R.y)
z = double(R.z)
printf("\n");
I1  = x
I2  = z
I3  = y
I4  =  x - z
I5  = x - y
I6  = y - z

printf("\nPotências das fontes\n");
S60V = -V1*conj(I1);
S20V = V2*conj(I3);
printf("\nS60V = %.3f + %.3fI VA",_to_Vector(S60V))
printf("\nS20V = %.3f + %.3fI VA\n",_to_Vector(S20V))
printf("\nPotências dos resistores\n");
S80_OHMS = R80_OHMS*I2*conj(I2);
S40_OHMS = R40_OHMS*I6*conj(I6);
printf("\nS80_OHMS = %.3f + %.3fI VA",_to_Vector(S80_OHMS))
printf("\nS40_OHMS = %.3f + %.3fI VA\n",_to_Vector(S40_OHMS))
printf("\nPotência do capacitor\n");
S_j20_OHMS = _ZC*I6*conj(I6);
printf("\nS_j20_OHMS = %.3f + %.3fI VA\n",_to_Vector(S_j20_OHMS))
printf("\nPotências dos indutores: Autoindutâncias + Mútuas\n");
Sj50_OHMS  =  _Zj50_OHMS*I4*conj(I4) + _ZM2*I2*conj(I4) + _ZM1*I5*conj(I4);
Sj80_OHMS  =  _Zj80_OHMS*I5*conj(I5) + _ZM1*I4*conj(I5) + _ZM3*I2*conj(I5);
Sj100_OHMS = _Zj100_OHMS*I2*conj(I2) + _ZM2*I4*conj(I2) + _ZM3*I5*conj(I2);
printf("\nSj50_OHMS = %.3f + %.3fI VA\n",_to_Vector(Sj50_OHMS))
printf("Sj80_OHMS = %.3f + %.3fI VA\n",_to_Vector(Sj80_OHMS))
printf("Sj100_OHMS = %.3f + %.3fI VA\n",_to_Vector(Sj100_OHMS))

St = S60V +  S20V + S80_OHMS + S40_OHMS + S_j20_OHMS + Sj50_OHMS + Sj80_OHMS + Sj100_OHMS;
printf("\nSt = %.3f + %.3f\n",real(St),imag(St));
