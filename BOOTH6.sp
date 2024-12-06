**  Lab4: 6-bit Booth Encoder  *

*********************************************************
*********************************************************
*************Don't touch settings below******************
*********************************************************
*********************************************************
.lib "../../umc018.l" L18U18V_TT
.vec 'BOOTH6.vec'

.temp 25
.op
.options post

***************** parameter ****************************
.global  VDD  GND
.param supply = 1.8v
.param load = 10f
.param tr = 0.2n

************* voltage source ************************
Vclk CLK GND pulse(0 supply 0 0.1ns 0.1ns "1*period/2-tr" "period*1")
Vd1 VDD GND supply

************* top-circuit ************************
XBOOTH6 CLK
+ A[5] A[4] A[3] A[2] A[1] A[0]
+ B[5] B[4] B[3] B[2] B[1] B[0]
+ PP0[6] PP0[5] PP0[4] PP0[3] PP0[2] PP0[1] PP0[0]
+ PP1[6] PP1[5] PP1[4] PP1[3] PP1[2] PP1[1] PP1[0]
+ PP2[6] PP2[5] PP2[4] PP2[3] PP2[2] PP2[1] PP2[0] BOOTH6

CLOAD1 PP0[0] GND load
CLOAD2 PP0[1] GND load
CLOAD3 PP0[2] GND load
CLOAD4 PP0[3] GND load
CLOAD5 PP0[4] GND load
CLOAD6 PP0[5] GND load
CLOAD7 PP0[6] GND load
CLOAD8 PP1[0] GND load
CLOAD9 PP1[1] GND load
CLOAD10 PP1[2] GND load
CLOAD11 PP1[3] GND load
CLOAD12 PP1[4] GND load
CLOAD13 PP1[5] GND load
CLOAD14 PP1[6] GND load
CLOAD15 PP2[0] GND load
CLOAD16 PP2[1] GND load
CLOAD17 PP2[2] GND load
CLOAD18 PP2[3] GND load
CLOAD19 PP2[4] GND load
CLOAD20 PP2[5] GND load
CLOAD21 PP2[6] GND load

************* Average Power ************************
.meas tran Iavg avg I(Vd1) from=0ns to='4095*period'
.meas Pavg param='abs(Iavg)*supply'

.meas tran AVG_Ckt_Pwr AVG power
.meas tran avg_power avg power from=0.1ns to='4095*period'

.tran 0.1n '4095*period'

*********************************************************
*********************************************************
*************Don't touch settings above******************
*********************************************************
*********************************************************

* you can modify clock cycle here, remember synchronize with clock cycle in BOOTH6.vec **
.param period = 0.57n


***** Define your sub-circuit and self-defined parameter here , and only need to submit this part ****
.param wp = 0.44u
.param wn = 0.75u

*0.65
*0.75

.subckt BOOTH6 clk A[5] A[4] A[3] A[2] A[1] A[0] B[5] B[4] B[3] B[2] B[1] B[0] 
+ PP0[6] PP0[5] PP0[4] PP0[3] PP0[2] PP0[1] PP0[0]
+ PP1[6] PP1[5] PP1[4] PP1[3] PP1[2] PP1[1] PP1[0]
+ PP2[6] PP2[5] PP2[4] PP2[3] PP2[2] PP2[1] PP2[0] 

X1 A[5] A[4] A[3] A[2] A[1] A[0] B[5] B[4] B[3] B[2] B[1] B[0] 
+ DPP0[6] DPP0[5] DPP0[4] DPP0[3] DPP0[2] DPP0[1] DPP0[0]
+ DPP1[6] DPP1[5] DPP1[4] DPP1[3] DPP1[2] DPP1[1] DPP1[0]
+ DPP2[6] DPP2[5] DPP2[4] DPP2[3] DPP2[2] DPP2[1] DPP2[0] Booth_Mult_Simplify   

X_TSPC01     DPP0[6] PP0[6] clk    E_TSPC
X_TSPC02     DPP0[5] PP0[5] clk    E_TSPC
X_TSPC03     DPP0[4] PP0[4] clk    E_TSPC
X_TSPC04     DPP0[3] PP0[3] clk    E_TSPC
X_TSPC05     DPP0[2] PP0[2] clk    E_TSPC
X_TSPC06     DPP0[1] PP0[1] clk    E_TSPC
X_TSPC07     DPP0[0] PP0[0] clk    E_TSPC
X_TSPC11     DPP1[6] PP1[6] clk    E_TSPC
X_TSPC12     DPP1[5] PP1[5] clk    E_TSPC
X_TSPC13     DPP1[4] PP1[4] clk    E_TSPC
X_TSPC14     DPP1[3] PP1[3] clk    E_TSPC
X_TSPC15     DPP1[2] PP1[2] clk    E_TSPC
X_TSPC16     DPP1[1] PP1[1] clk    E_TSPC
X_TSPC17     DPP1[0] PP1[0] clk    E_TSPC
X_TSPC21     DPP2[6] PP2[6] clk    E_TSPC
X_TSPC22     DPP2[5] PP2[5] clk    E_TSPC
X_TSPC23     DPP2[4] PP2[4] clk    E_TSPC
X_TSPC24     DPP2[3] PP2[3] clk    E_TSPC
X_TSPC25     DPP2[2] PP2[2] clk    E_TSPC
X_TSPC26     DPP2[1] PP2[1] clk    E_TSPC
X_TSPC27     DPP2[0] PP2[0] clk    E_TSPC
.ends

.subckt Pseudo_AOI22  A    B   C   D   OUT
m1p OUT GND VDD VDD P_18_G2 l=0.18u w=wp
m5n OUT A   N2  GND N_18_G2 l=0.18u w=wn
m6n OUT C   N3  GND N_18_G2 l=0.18u w=wn
m7n N2  B   GND GND N_18_G2 l=0.18u w=wn
m8n N3  D   GND GND N_18_G2 l=0.18u w=wn
.ends

.subckt Pseudo_AOI33  A    B   C   D   E   F   OUT
m1p  OUT GND VDD VDD P_18_G2 l=0.18u w=wp
m7n  OUT A   N2  GND N_18_G2 l=0.18u w=wn
m8n  OUT D   N3  GND N_18_G2 l=0.18u w=wn
m9n  N2  B   N4  GND N_18_G2 l=0.18u w=wn
m10n N3  E   N5  GND N_18_G2 l=0.18u w=wn
m11n N4  C   GND GND N_18_G2 l=0.18u w=wn
m12n N5  F   GND GND N_18_G2 l=0.18u w=wn
.ends



*textbook
.subckt Booth_Encoder  X2i-1    X2i     X2i+1   Single  Double
X1  X2i-1   X2i     Single    Pseudo_XOR
* 3 x P 
* 2 x N
* 2 x NN
X2  X2i-1   X2i-1_INV         Pseudo_INV
X3  X2i     X2i_INV           Pseudo_INV
X4  X2i+1   X2i+1_INV         Pseudo_INV
X5  X2i-1   X2i     X2i+1_INV X2i-1_INV X2i_INV X2i+1   Double_INV  Pseudo_AOI33
* 1 x P 
* 2 x NNN
X6  Double_INV      Double    Pseudo_INV
*Total
* 8 x P 
* 6 x N
* 2 x NN
* 2 x NNN
.ends

*textbook
.subckt Booth_Sel  Yj-1       Yj    Neg     Single    Double    PP
X1  Yj      Single  Yj-1      Double        N1    Pseudo_AOI22 
* 1 x P 
* 2 x NN
X2  N1      N1_INV            Pseudo_INV
X3  N1_INV  Neg     PP        Pseudo_XOR  
* 3 x P 
* 2 x N
* 2 x NN
*Total
* 5 x P 
* 5 x N  ->
* 4 x NN
.ends


.subckt Booth_Mult_Simplify   
+   X[5]   X[4]    X[3]    X[2]    X[1]    X[0]
+   Y[5]   Y[4]    Y[3]    Y[2]    Y[1]    Y[0]
+   PP0[6]    PP0[5]   PP0[4]    PP0[3]    PP0[2]    PP0[1]    PP0[0] 
+   PP1[6]    PP1[5]   PP1[4]    PP1[3]    PP1[2]    PP1[1]    PP1[0] 
+   PP2[6]    PP2[5]   PP2[4]    PP2[3]    PP2[2]    PP2[1]    PP2[0] 
X_INVX5      X[5]    X[5]_INV  Pseudo_INV
X_INVX4      X[4]    X[4]_INV  Pseudo_INV
X_INVX3      X[3]    X[3]_INV  Pseudo_INV
X_INVX2      X[2]    X[2]_INV  Pseudo_INV
X_INVX1      X[1]    X[1]_INV  Pseudo_INV
X_INVX0      X[0]    X[0]_INV  Pseudo_INV

********ENCODERS x 3******************
X01  GND     X[0]    Single0   Pseudo_XOR
X02  GND     X[0]    X[1]_INV  VDD      X[0]_INV  X[1]  Double0_INV  Pseudo_AOI33
X03  Double0_INV     Double0   Pseudo_INV

X11  X[1]    X[2]    Single1   Pseudo_XOR
X12  X[1]    X[2]    X[3]_INV  X[1]_INV X[2]_INV  X[3]  Double1_INV  Pseudo_AOI33
X13  Double1_INV     Double1   Pseudo_INV

X21  X[3]    X[4]    Single2   Pseudo_XOR
X22  X[3]    X[4]    X[5]_INV  X[3]_INV X[4]_INV  X[5]  Double2_INV  Pseudo_AOI33
X23  Double2_INV     Double2   Pseudo_INV
********SELECTORS x 21******************
X_Sel00      GND      Y[0]    X[1]    Single0  Double0 PP0[0]   Booth_Sel
X_Sel01      Y[0]     Y[1]    X[1]    Single0  Double0 PP0[1]   Booth_Sel
X_Sel02      Y[1]     Y[2]    X[1]    Single0  Double0 PP0[2]   Booth_Sel
X_Sel03      Y[2]     Y[3]    X[1]    Single0  Double0 PP0[3]   Booth_Sel
X_Sel04      Y[3]     Y[4]    X[1]    Single0  Double0 PP0[4]   Booth_Sel
X_Sel05      Y[4]     Y[5]    X[1]    Single0  Double0 PP0[5]   Booth_Sel
X_Sel06      Y[5]     Y[5]    X[1]    Single0  Double0 PP0[6]   Booth_Sel

X_Sel10      GND      Y[0]    X[3]    Single1  Double1 PP1[0]   Booth_Sel
X_Sel11      Y[0]     Y[1]    X[3]    Single1  Double1 PP1[1]   Booth_Sel
X_Sel12      Y[1]     Y[2]    X[3]    Single1  Double1 PP1[2]   Booth_Sel
X_Sel13      Y[2]     Y[3]    X[3]    Single1  Double1 PP1[3]   Booth_Sel
X_Sel14      Y[3]     Y[4]    X[3]    Single1  Double1 PP1[4]   Booth_Sel
X_Sel15      Y[4]     Y[5]    X[3]    Single1  Double1 PP1[5]   Booth_Sel
X_Sel16      Y[5]     Y[5]    X[3]    Single1  Double1 PP1[6]   Booth_Sel

X_Sel20      GND      Y[0]    X[5]    Single2  Double2 PP2[0]   Booth_Sel
X_Sel21      Y[0]     Y[1]    X[5]    Single2  Double2 PP2[1]   Booth_Sel
X_Sel22      Y[1]     Y[2]    X[5]    Single2  Double2 PP2[2]   Booth_Sel
X_Sel23      Y[2]     Y[3]    X[5]    Single2  Double2 PP2[3]   Booth_Sel
X_Sel24      Y[3]     Y[4]    X[5]    Single2  Double2 PP2[4]   Booth_Sel
X_Sel25      Y[4]     Y[5]    X[5]    Single2  Double2 PP2[5]   Booth_Sel
X_Sel26      Y[5]     Y[5]    X[5]    Single2  Double2 PP2[6]   Booth_Sel
.ends

.subckt Booth_Mult   X2i-1    X2i     X2i+1   Y[5]   Y[4]    Y[3]    Y[2]    Y[1]    Y[0]     PP[6]    PP[5]   PP[4]    PP[3]    PP[2]    PP[1]    PP[0] 
X_Encode    X2i-1    X2i      X2i+1   Single  Double         Booth_Encoder
X_Sel0      GND      Y[0]     X2i+1   Single  Double PP[0]   Booth_Sel
X_Sel1      Y[0]     Y[1]     X2i+1   Single  Double PP[1]   Booth_Sel
X_Sel2      Y[1]     Y[2]     X2i+1   Single  Double PP[2]   Booth_Sel
X_Sel3      Y[2]     Y[3]     X2i+1   Single  Double PP[3]   Booth_Sel
X_Sel4      Y[3]     Y[4]     X2i+1   Single  Double PP[4]   Booth_Sel
X_Sel5      Y[4]     Y[5]     X2i+1   Single  Double PP[5]   Booth_Sel
X_Sel6      Y[5]     Y[5]     X2i+1   Single  Double PP[6]   Booth_Sel
.ends
*0.94
.subckt E_TSPC  D   Q   CLK
m1p S1  CLK VDD VDD P_18_G2 l=0.18u w=0.94u
m2n S1  D   GND GND N_18_G2 l=0.18u w=0.94u
m3p S2  CLK VDD VDD P_18_G2 l=0.18u w=0.94u
m4n S2  S1  GND GND N_18_G2 l=0.18u w=0.94u
m5p Q_N S2  VDD VDD P_18_G2 l=0.18u w=0.94u
m6n Q_N CLK GND GND N_18_G2 l=0.18u w=0.94u
X1  Q_N Q   Pseudo_INV
.ends

.subckt CMOS_INV IN OUT
mp OUT IN VDD VDD P_18_G2 l=0.18u w=wp
mn OUT IN GND GND N_18_G2 l=0.18u w=wn
.ends

.subckt Pseudo_INV IN OUT
mp OUT GND VDD VDD P_18_G2 l=0.18u w=wp
mn OUT IN  GND GND N_18_G2 l=0.18u w=wn
.ends

.subckt Pseudo_XOR     A   B   OUT
X1  A       A_NOT   Pseudo_INV
X2  B       B_NOT   Pseudo_INV
mp1 OUT     GND     VDD     VDD P_18_G2 l=0.18u w=wp
mn1 OUT     A       N2      GND N_18_G2 l=0.18u w=wn
mn2 N2      B       GND     GND N_18_G2 l=0.18u w=wn
mn3 OUT     A_NOT   N3      GND N_18_G2 l=0.18u w=wn
mn4 N3      B_NOT   GND     GND N_18_G2 l=0.18u w=wn

* 3 x P 
* 2 x N
* 2 x NN
.ends

.subckt Pseudo_XNOR     A   B   OUT
X1  A       A_NOT   INV
X2  B       B_NOT   INV
mp1 OUT     GND     VDD     VDD P_18_G2 l=0.18u w=wp
mn1 OUT     A       N2      GND N_18_G2 l=0.18u w=wn
mn2 N2      B_NOT   GND     GND N_18_G2 l=0.18u w=wn
mn3 OUT     A_NOT   N3      GND N_18_G2 l=0.18u w=wn
mn4 N3      B       GND     GND N_18_G2 l=0.18u w=wn
.ends


*https://ir.lib.nycu.edu.tw/bitstream/11536/30400/1/000088843800008.pdf
* .subckt Booth_Encoder  X2i-1    X2i     X2i+1   X1_b    Z   X2_b
* X1  X2i-1   X2i     X1_b    XNOR_4T
* X2  X2i+1   X2i     Z       XNOR_4T
* X3  X2i-1   X2i     X2_b    XOR_4T
* .ends

*VLSI Intro Powerpoint
* .subckt Booth_Encoder  X2i-1    X2i     X2i+1   Single  Double
* *X1  X2i-1   X2i     Single    XOR_4T
* X1  X2i-1   X2i     Single    CMOS_XOR
* *X2  X2i-1   X2i     N1_INV   Pseudo_NAND2
* X2  X2i-1   X2i     N1_INV    CMOS_NAND2

* X3  N1_INV  N1                INV
* *X4  N1      X2i+1   Double    XOR_4T
* X4  N1      X2i+1   Double    CMOS_XOR   
* .ends

*交大論文
* .subckt Booth_Sel  Yj-1       Yj    Neg     X1_b    Z   X2_b    PP
* X1  Yj      Neg     O1    XNOR_4T
* X2  Yj-1    Neg     O2    XNOR_4T
* X3  X2_b    O2      Z     X1_b          O1      PP      AOI32
* .ends


* *VLSI Intro Powerpoint
* .subckt Booth_Sel  Yj-1       Yj    Neg     Single    Double    PP
* X1  Yj-1    Double  Yj        Single        N1    AOI22 
* *X2  N1      Neg     PP        XNOR_4T
* X2  N1      Neg     PP        CMOS_XNOR     
* .ends

.end