`include "GATE_LIB.v"

module MAC6 (//input
             A,
             B,
             MODE,
             ACC,
             //output
             OUT);

input  signed [5:0]  A,B;
input  signed [11:0] ACC;
input  [1:0]  MODE;
output signed [12:0] OUT; 

wire signed [6:0] PP0, PP1, PP2;
wire signed [10:0] CSA_SUM, CSA_COUT;
wire signed [12:0] mult_result_0, mult_result;
wire [11:0] ACC_inv;
wire [12:0] ACC_twos_comp, B_twos_comp, mode0_result, mode1_result, mode2_result, mode3_result, ans0, ans1, ans3;
wire [5:0] B_inv;

//Wallace Tree
wire [12:0] M0wtree0_0, M0wtree0_1, M0wtree0_2, M0wtree0_3, M0wtree0_4;
wire [12:0] M0wtree1_0, M0wtree1_1, M0wtree1_2, M0wtree1_3;
wire [12:0] M0wtree2_0, M0wtree2_1, M0wtree2_2;
wire [12:0] M0wtree3_0, M0wtree3_1;

wire [12:0] M1wtree0_0, M1wtree0_1, M1wtree0_2, M1wtree0_3, M1wtree0_4;
wire [12:0] M1wtree1_0, M1wtree1_1, M1wtree1_2, M1wtree1_3;
wire [12:0] M1wtree2_0, M1wtree2_1, M1wtree2_2;
wire [12:0] M1wtree3_0, M1wtree3_1;

wire [12:0] M3wtree0_0, M3wtree0_1, M3wtree0_2, M3wtree0_3, M3wtree0_4;
wire [12:0] M3wtree1_0, M3wtree1_1, M3wtree1_2, M3wtree1_3;
wire [12:0] M3wtree2_0, M3wtree2_1, M3wtree2_2;
wire [12:0] M3wtree3_0, M3wtree3_1;

assign M0wtree0_0 = {{6{PP0[6]}}, PP0};
assign M0wtree0_1 = {{4{PP1[6]}}, PP1, ACC[1], A[1]};
assign M0wtree0_2 = {{2{PP2[6]}}, PP2, ACC[3], A[3], 1'b0, ACC[0]};
assign M0wtree0_3 = {ACC[11], ACC[11:4], 1'b0, ACC[2], 2'b0};
assign M0wtree0_4 = {8'b0 ,A[5], 3'b0, MODE[0]};
wtree0 M0wallace0(M0wtree0_0, M0wtree0_1, M0wtree0_2, M0wtree0_3, M0wtree0_4, M0wtree1_0, M0wtree1_1, M0wtree1_2, M0wtree1_3);
wtree1 M0wallace1(M0wtree1_0, M0wtree1_1, M0wtree1_2, M0wtree1_3, M0wtree2_0, M0wtree2_1, M0wtree2_2);
wtree2 M0wallace2(M0wtree2_0, M0wtree2_1, M0wtree2_2, M0wtree3_0, M0wtree3_1);
FA13_CLA mode0_add(M0wtree3_0, M0wtree3_1, ans0);

assign M1wtree0_0 = {{6{PP0[6]}}, PP0};
assign M1wtree0_1 = {{4{PP1[6]}}, PP1, ACC_inv[1], A[1]};
assign M1wtree0_2 = {{2{PP2[6]}}, PP2, ACC_inv[3], A[3], 1'b0, ACC_inv[0]};
assign M1wtree0_3 = {ACC_inv[11], ACC_inv[11:4], 1'b0, ACC_inv[2], 2'b0};
assign M1wtree0_4 = {8'b0 ,A[5], 3'b0, MODE[0]};
wtree0 M1wallace0(M1wtree0_0, M1wtree0_1, M1wtree0_2, M1wtree0_3, M1wtree0_4, M1wtree1_0, M1wtree1_1, M1wtree1_2, M1wtree1_3);
wtree1 M1wallace1(M1wtree1_0, M1wtree1_1, M1wtree1_2, M1wtree1_3, M1wtree2_0, M1wtree2_1, M1wtree2_2);
wtree2 M1wallace2(M1wtree2_0, M1wtree2_1, M1wtree2_2, M1wtree3_0, M1wtree3_1);
FA13_CLA mode1_add(M1wtree3_0, M1wtree3_1, ans1);

assign M3wtree0_0 = {{7{A[5]}},A};
assign M3wtree0_1 = {{7{B_inv[5]}},B_inv};
assign M3wtree0_2 = {12'b0, MODE[1]};
assign M3wtree0_3 = 13'b0;
assign M3wtree0_4 = 13'b0;
wtree0 M3wallace0(M3wtree0_0, M3wtree0_1, M3wtree0_2, M3wtree0_3, M3wtree0_4, M3wtree1_0, M3wtree1_1, M3wtree1_2, M3wtree1_3);
wtree1 M3wallace1(M3wtree1_0, M3wtree1_1, M3wtree1_2, M3wtree1_3, M3wtree2_0, M3wtree2_1, M3wtree2_2);
wtree2 M3wallace2(M3wtree2_0, M3wtree2_1, M3wtree2_2, M3wtree3_0, M3wtree3_1);
FA13_CLA mode3_add(M3wtree3_0, M3wtree3_1, ans3);

//Multiplier
Booth6 Booth(A, B, PP0, PP1, PP2);



//Mode 0
//Mode 1
//Convert signed ACC to 2's complement
invert13 ACC_comp (ACC, ACC_inv);
invert13 B_comp (B, B_inv);

//Mode 2
FA13_CLA FA_A_plus_B({{7{A[5]}},A}, {{7{B[5]}},B}, mode2_result);
//Mode 3
//Convert signed B to 2's complement
signed_to_comp SC_B({{7{B[5]}},B}, B_twos_comp);
FA13_CLA FA_A_plus_B_comp({{7{A[5]}},A}, B_twos_comp, mode3_result);

//MUX 13 bits
//Four_One_MUX13 mux(mode0_result, mode1_result, mode2_result, mode3_result, MODE, OUT);
Four_One_MUX13 mux(ans0, ans1, mode2_result, ans3, MODE, OUT);

endmodule

module Booth6(
input  signed [5:0]  A,B,
output signed [6:0]  PP0, PP1, PP2  
);
Booth_Encoder BE0(   0, A[0], A[1], Single0, Double0);
Booth_Encoder BE1(A[1], A[2], A[3], Single1, Double1);
Booth_Encoder BE2(A[3], A[4], A[5], Single2, Double2);

Booth_Selector BS00(   0, B[0], A[1], Single0, Double0, PP0[0]);
Booth_Selector BS01(B[0], B[1], A[1], Single0, Double0, PP0[1]);
Booth_Selector BS02(B[1], B[2], A[1], Single0, Double0, PP0[2]);
Booth_Selector BS03(B[2], B[3], A[1], Single0, Double0, PP0[3]);
Booth_Selector BS04(B[3], B[4], A[1], Single0, Double0, PP0[4]);
Booth_Selector BS05(B[4], B[5], A[1], Single0, Double0, PP0[5]);
Booth_Selector BS06(B[5], B[5], A[1], Single0, Double0, PP0[6]);

Booth_Selector BS10(   0, B[0], A[3], Single1, Double1, PP1[0]);
Booth_Selector BS11(B[0], B[1], A[3], Single1, Double1, PP1[1]);
Booth_Selector BS12(B[1], B[2], A[3], Single1, Double1, PP1[2]);
Booth_Selector BS13(B[2], B[3], A[3], Single1, Double1, PP1[3]);
Booth_Selector BS14(B[3], B[4], A[3], Single1, Double1, PP1[4]);
Booth_Selector BS15(B[4], B[5], A[3], Single1, Double1, PP1[5]);
Booth_Selector BS16(B[5], B[5], A[3], Single1, Double1, PP1[6]);

Booth_Selector BS20(   0, B[0], A[5], Single2, Double2, PP2[0]);
Booth_Selector BS21(B[0], B[1], A[5], Single2, Double2, PP2[1]);
Booth_Selector BS22(B[1], B[2], A[5], Single2, Double2, PP2[2]);
Booth_Selector BS23(B[2], B[3], A[5], Single2, Double2, PP2[3]);
Booth_Selector BS24(B[3], B[4], A[5], Single2, Double2, PP2[4]);
Booth_Selector BS25(B[4], B[5], A[5], Single2, Double2, PP2[5]);
Booth_Selector BS26(B[5], B[5], A[5], Single2, Double2, PP2[6]);

endmodule

module wtree0(
input [12:0] A, B, C, D, E,
output [12:0] OA, OB, OC, OD
);
FA1 x0(A[12], B[12], C[12], OA[12], empty);
FA1 x1(A[11], B[11], C[11], OA[11], OB[12]);
FA1 x2(A[10], B[10], C[10], OA[10], OB[11]);
FA1 x3(A[9], B[9], C[9], OA[9], OB[10]);
FA1 x4(A[8], B[8], C[8], OA[8], OB[9]);
FA1 x5(A[7], B[7], C[7], OA[7], OB[8]);
FA1 x6(A[6], B[6], C[6], OA[6], OB[7]);
FA1 x7(A[5], B[5], C[5], OA[5], OB[6]);
FA1 x8(A[4], B[4], C[4], OA[4], OB[5]);
FA1 x9(A[3], B[3], C[3], OA[3], OB[4]);
FA1 x10(A[2], B[2], C[2], OA[2], OB[3]);
HA1 x11(D[4], E[4], OC[4], OD[5]);
FA1 x12(A[0], B[0], C[0], OA[0], OC[1]);
assign OA[1] = A[1];
assign OB[2:0] = {D[2], B[1], E[0]};
assign OC[12:5] = D[12:5];
assign {OC[3:2], OC[0]} = 3'b0;
assign {OD[12:6], OD[4:0]} = 12'b0;
endmodule

module wtree1(
input [12:0] A, B, C, D,
output [12:0] OA, OB, OC
);
FA1 x0(A[12], B[12], C[12], OA[12], empty);
FA1 x1(A[11], B[11], C[11], OA[11], OB[12]);
FA1 x2(A[10], B[10], C[10], OA[10], OB[11]);
FA1 x3(A[9], B[9], C[9], OA[9], OB[10]);
FA1 x4(A[8], B[8], C[8], OA[8], OB[9]);
FA1 x5(A[7], B[7], C[7], OA[7], OB[8]);
FA1 x6(A[6], B[6], C[6], OA[6], OB[7]);
FA1 x7(A[5], B[5], C[5], OA[5], OB[6]);
FA1 x8(A[4], B[4], C[4], OA[4], OC[5]);
HA1 x9(B[1], C[1], OB[1], OC[2]);
assign OA[3:0] = A[3:0];
assign OB[5] = D[5];
assign {OB[4:2], OB[0]} = {1'b0, B[3:2], B[0]};
assign {OC[12:6], OC[4:3], OC[1:0]} = 11'b0;
endmodule

module wtree2(
input [12:0] A, B, C,
output [12:0] OA, OB
);
HA1 x0(A[12], B[12], OA[12], empty);
HA1 x1(A[11], B[11], OA[11], OB[12]);
HA1 x2(A[10], B[10], OA[10], OB[11]);
HA1 x3(A[9], B[9], OA[9], OB[10]);
HA1 x4(A[8], B[8], OA[8], OB[9]);
HA1 x5(A[7], B[7], OA[7], OB[8]);
HA1 x6(A[6], B[6], OA[6], OB[7]);
FA1 x7(A[5], B[5], C[5], OA[5], OB[6]);
HA1 x8(A[3], B[3], OA[3], OB[4]);
FA1 x9(A[2], B[2], C[2], OA[2], OB[3]);
assign {OA[4], OA[1:0]} = {A[4],A[1:0]};
assign {OB[5], OB[2:0]} = {2'b0, B[1:0]};
endmodule

module CSA_array(
input [10:0] A, B, C, D,
output [10:0] SUM, CARRY 
);
FA1 x0(A[0], B[0], C[0], SUM[0], CARRY[0]);
FA1 x1(A[1], B[1], C[1], SUM[1], CARRY[1]);
FA1 x2(A[2], B[2], C[2], SUM[2], CARRY[2]);
FA1 x3(A[3], B[3], C[3], SUM[3], CARRY[3]);
FA1 x4(A[4], B[4], C[4], SUM[4], CARRY[4]);
FA1 x5(A[5], B[5], C[5], SUM[5], CARRY[5]);
FA1 x6(A[6], B[6], C[6], SUM[6], CARRY[6]);
FA1 x7(A[7], B[7], C[7], SUM[7], CARRY[7]);
FA1 x8(A[8], B[8], C[8], SUM[8], CARRY[8]);
FA1 x9(A[9], B[9], C[9], SUM[9], CARRY[9]);
FA1 x10(A[10], B[10], C[10], SUM[10], CARRY[10]);

endmodule

module Four_Two_Compressor(
input  A, B, C, D,
input  Cin,
output Cout,
output SUM, CARRY 
);
FA1 x0(A, B, C, xor_out, Cout);
FA1 x1(Cin, D, xor_out, SUM, CARRY);
endmodule

module Four_Two_Compressor_Array(
input [10:0] A, B, C, D,
output [10:0] SUM, CARRY 
);
wire [10:0] inter_c; //intermediate carry
Four_Two_Compressor x0(A[0], B[0], C[0], D[0],          0, inter_c[0], SUM[0], CARRY[0]);
Four_Two_Compressor x1(A[1], B[1], C[1], D[1], inter_c[0], inter_c[1], SUM[1], CARRY[1]);
Four_Two_Compressor x2(A[2], B[2], C[2], D[2], inter_c[1], inter_c[2], SUM[2], CARRY[2]);
Four_Two_Compressor x3(A[3], B[3], C[3], D[3], inter_c[2], inter_c[3], SUM[3], CARRY[3]);
Four_Two_Compressor x4(A[4], B[4], C[4], D[4], inter_c[3], inter_c[4], SUM[4], CARRY[4]);
Four_Two_Compressor x5(A[5], B[5], C[5], D[5], inter_c[4], inter_c[5], SUM[5], CARRY[5]);
Four_Two_Compressor x6(A[6], B[6], C[6], D[6], inter_c[5], inter_c[6], SUM[6], CARRY[6]);
Four_Two_Compressor x7(A[7], B[7], C[7], D[7], inter_c[6], inter_c[7], SUM[7], CARRY[7]);
Four_Two_Compressor x8(A[8], B[8], C[8], D[8], inter_c[7], inter_c[8], SUM[8], CARRY[8]);
Four_Two_Compressor x9(A[9], B[9], C[9], D[9], inter_c[8], inter_c[9], SUM[9], CARRY[9]);
Four_Two_Compressor x10(A[10], B[10], C[10], D[10], inter_c[9], inter_c[10], SUM[10], CARRY[10]);
endmodule

module Booth_Encoder(
input x2i_minus_1,
input x2i,
input x2i_plus_1,
output Single,
output Double
);
VLSI_XOR2 XOR1( x2i_minus_1, x2i, Single);
VLSI_NOT INV1(x2i_minus_1, x2i_minus_1_inv);
VLSI_NOT INV2(x2i, x2i_inv);
VLSI_NOT INV3(x2i_plus_1, x2i_plus_1_inv);
//Changed AND-OR to pure NAND, faster! Original name kept as reminder
VLSI_NAND3 AND1(x2i_minus_1, x2i, x2i_plus_1_inv, AND1_out);
VLSI_NAND3 AND2(x2i_minus_1_inv, x2i_inv, x2i_plus_1, AND2_out);
VLSI_NAND2  OR1(AND1_out, AND2_out, Double);
endmodule

module Booth_Selector(
input Yj_minus_1,
input Yj,    
input Neg,
input Single,
input Double,   
output PP
);
VLSI_NAND2 NAND1(Yj, Single,   NAND1_out);
VLSI_NAND2 NAND2(Yj_minus_1, Double, NAND2_out);
VLSI_NAND2 NAND3(NAND1_out, NAND2_out, NAND3_out);
VLSI_XOR2 XOR1(Neg, NAND3_out, PP);
endmodule

module Four_One_MUX13(
input [12:0] A, B, C, D, 
input [1:0] sel,
output [12:0] out
);
Four_One_MUX x0(A[0],B[0],C[0],D[0], sel, out[0]);
Four_One_MUX x1(A[1],B[1],C[1],D[1], sel, out[1]);
Four_One_MUX x2(A[2],B[2],C[2],D[2], sel, out[2]);
Four_One_MUX x3(A[3],B[3],C[3],D[3], sel, out[3]);
Four_One_MUX x4(A[4],B[4],C[4],D[4], sel, out[4]);
Four_One_MUX x5(A[5],B[5],C[5],D[5], sel, out[5]);
Four_One_MUX x6(A[6],B[6],C[6],D[6], sel, out[6]);
Four_One_MUX x7(A[7],B[7],C[7],D[7], sel, out[7]);
Four_One_MUX x8(A[8],B[8],C[8],D[8], sel, out[8]);
Four_One_MUX x9(A[9],B[9],C[9],D[9], sel, out[9]);
Four_One_MUX x10(A[10],B[10],C[10],D[10], sel, out[10]);
Four_One_MUX x11(A[11],B[11],C[11],D[11], sel, out[11]);
Four_One_MUX x12(A[12],B[12],C[12],D[12], sel, out[12]);
endmodule

module Four_One_MUX(
input INA,
input INB,
input INC,
input IND,
input [1:0] sel,
output OUT
);
VLSI_NOT    NOT1(sel[0], sel0_inv);
VLSI_NOT    NOT2(sel[1], sel1_inv);
//Changed AND-OR to pure NAND, faster! Original name kept as reminder
VLSI_NAND3   AND1(sel1_inv, sel0_inv,    INA, AND1_out);
VLSI_NAND3   AND2(sel1_inv, sel[0],      INB, AND2_out);
VLSI_NAND3   AND3(sel[1]    ,sel0_inv,   INC, AND3_out);
VLSI_NAND3   AND4(sel[1]    ,sel[0]    , IND, AND4_out);
VLSI_NAND4   OR1(AND1_out, AND2_out, AND3_out, AND4_out, OUT);
endmodule

module invert13(
input signed [12:0] in,
output [12:0] out
);
VLSI_NOT x0(in[0], out[0]);
VLSI_NOT x1(in[1], out[1]);
VLSI_NOT x2(in[2], out[2]);
VLSI_NOT x3(in[3], out[3]);
VLSI_NOT x4(in[4], out[4]);
VLSI_NOT x5(in[5], out[5]);
VLSI_NOT x6(in[6], out[6]);
VLSI_NOT x7(in[7], out[7]);
VLSI_NOT x8(in[8], out[8]);
VLSI_NOT x9(in[9], out[9]);
VLSI_NOT x10(in[10], out[10]);
VLSI_NOT x11(in[11], out[11]);
VLSI_NOT x12(in[12], out[12]);
endmodule

module signed_to_comp(
input signed [12:0] in,
output [12:0] out
);
wire [12:0] inverted;
VLSI_NOT x0(in[0], inverted[0]);
VLSI_NOT x1(in[1], inverted[1]);
VLSI_NOT x2(in[2], inverted[2]);
VLSI_NOT x3(in[3], inverted[3]);
VLSI_NOT x4(in[4], inverted[4]);
VLSI_NOT x5(in[5], inverted[5]);
VLSI_NOT x6(in[6], inverted[6]);
VLSI_NOT x7(in[7], inverted[7]);
VLSI_NOT x8(in[8], inverted[8]);
VLSI_NOT x9(in[9], inverted[9]);
VLSI_NOT x10(in[10], inverted[10]);
VLSI_NOT x11(in[11], inverted[11]);
VLSI_NOT x12(in[12], inverted[12]);
FA13_CLA FA(inverted, 13'b0000000000001, out);
endmodule

module FA1(
input A,
input B,
input CIN,
output SUM,
output COUT    
);
VLSI_XOR2   XOR1(A, B, XOR1_out);
VLSI_XOR2   XOR2(XOR1_out, CIN, SUM);
VLSI_NAND2  NAND1(XOR1_out, CIN, NAND1_out);
VLSI_NAND2  NAND2(A, B, NAND2_out);
VLSI_NAND2  NAND3(NAND1_out, NAND2_out, COUT);
endmodule

module HA1(
input A,
input B,
output SUM,
output COUT    
);
VLSI_XOR2   XOR1(A, B, SUM);
VLSI_AND2   AND1(A, B, COUT);
endmodule

module FA7(
input [6:0] A,
input [6:0] B,
output [6:0] S
);
wire [6:0] C;
HA1 x0(A[0], B[0], S[0], C[0]);
FA1 x1(A[1], B[1], C[0], S[1], C[1]);
FA1 x2(A[2], B[2], C[1], S[2], C[2]);
FA1 x3(A[3], B[3], C[2], S[3], C[3]);
FA1 x4(A[4], B[4], C[3], S[4], C[4]);
FA1 x5(A[5], B[5], C[4], S[5], C[5]);
FA1 x6(A[6], B[6], C[5], S[6], C[6]);
endmodule

module FA9(
input [8:0] A,
input [8:0] B,
output [8:0] S
);
wire [8:0] C;
HA1 x0(A[0], B[0], S[0], C[0]);
FA1 x1(A[1], B[1], C[0], S[1], C[1]);
FA1 x2(A[2], B[2], C[1], S[2], C[2]);
FA1 x3(A[3], B[3], C[2], S[3], C[3]);
FA1 x4(A[4], B[4], C[3], S[4], C[4]);
FA1 x5(A[5], B[5], C[4], S[5], C[5]);
FA1 x6(A[6], B[6], C[5], S[6], C[6]);
FA1 x7(A[7], B[7], C[6], S[7], C[7]);
FA1 x8(A[8], B[8], C[7], S[8], C[8]);
endmodule

module FA13(
input [12:0] A,
input [12:0] B,
output [12:0] S
);
wire [12:0] C;
HA1 x0(A[0], B[0], S[0], C[0]);
FA1 x1(A[1], B[1], C[0], S[1], C[1]);
FA1 x2(A[2], B[2], C[1], S[2], C[2]);
FA1 x3(A[3], B[3], C[2], S[3], C[3]);
FA1 x4(A[4], B[4], C[3], S[4], C[4]);
FA1 x5(A[5], B[5], C[4], S[5], C[5]);
FA1 x6(A[6], B[6], C[5], S[6], C[6]);
FA1 x7(A[7], B[7], C[6], S[7], C[7]);
FA1 x8(A[8], B[8], C[7], S[8], C[8]);
FA1 x9(A[9], B[9], C[8], S[9], C[9]);
FA1 x10(A[10], B[10], C[9], S[10], C[10]);
FA1 x11(A[11], B[11], C[10], S[11], C[11]);
FA1 x12(A[12], B[12], C[11], S[12], C[12]);
endmodule

module FA9_CLA(
input [8:0] A,
input [8:0] B,
output [8:0] S
);
wire [8:0] P,G,C;

VLSI_XOR2 XOR_x0(A[0], B[0], P[0]);
VLSI_XOR2 XOR_x1(A[1], B[1], P[1]);
VLSI_XOR2 XOR_x2(A[2], B[2], P[2]);
VLSI_XOR2 XOR_x3(A[3], B[3], P[3]);
VLSI_XOR2 XOR_x4(A[4], B[4], P[4]);
VLSI_XOR2 XOR_x5(A[5], B[5], P[5]);
VLSI_XOR2 XOR_x6(A[6], B[6], P[6]);
VLSI_XOR2 XOR_x7(A[7], B[7], P[7]);
VLSI_XOR2 XOR_x8(A[8], B[8], P[8]);

VLSI_AND2 AND_0(A[0], B[0], G[0]);
VLSI_AND2 AND_1(A[1], B[1], G[1]);
VLSI_AND2 AND_2(A[2], B[2], G[2]);
VLSI_AND2 AND_3(A[3], B[3], G[3]);
VLSI_AND2 AND_4(A[4], B[4], G[4]);
VLSI_AND2 AND_5(A[5], B[5], G[5]);
VLSI_AND2 AND_6(A[6], B[6], G[6]);
VLSI_AND2 AND_7(A[7], B[7], G[7]);
VLSI_AND2 AND_8(A[8], B[8], G[8]);

Carry_Lookahead_Generator_9bit CLA(G,P,C);

assign S[0] = P[0];
VLSI_XOR2 SUM_x1(P[1], C[0], S[1]);
VLSI_XOR2 SUM_x2(P[2], C[1], S[2]);
VLSI_XOR2 SUM_x3(P[3], C[2], S[3]);
VLSI_XOR2 SUM_x4(P[4], C[3], S[4]);
VLSI_XOR2 SUM_x5(P[5], C[4], S[5]);
VLSI_XOR2 SUM_x6(P[6], C[5], S[6]);
VLSI_XOR2 SUM_x7(P[7], C[6], S[7]);
VLSI_XOR2 SUM_x8(P[8], C[7], S[8]);
endmodule

module FA13_CLA(
input [12:0] A,
input [12:0] B,
output [12:0] S
);
wire [12:0] P,G,C;

VLSI_XOR2 XOR_x0(A[0], B[0], P[0]);
VLSI_XOR2 XOR_x1(A[1], B[1], P[1]);
VLSI_XOR2 XOR_x2(A[2], B[2], P[2]);
VLSI_XOR2 XOR_x3(A[3], B[3], P[3]);
VLSI_XOR2 XOR_x4(A[4], B[4], P[4]);
VLSI_XOR2 XOR_x5(A[5], B[5], P[5]);
VLSI_XOR2 XOR_x6(A[6], B[6], P[6]);
VLSI_XOR2 XOR_x7(A[7], B[7], P[7]);
VLSI_XOR2 XOR_x8(A[8], B[8], P[8]);
VLSI_XOR2 XOR_x9(A[9], B[9], P[9]);
VLSI_XOR2 XOR_x10(A[10], B[10], P[10]);
VLSI_XOR2 XOR_x11(A[11], B[11], P[11]);
VLSI_XOR2 XOR_x12(A[12], B[12], P[12]);

VLSI_AND2 AND_0(A[0], B[0], G[0]);
VLSI_AND2 AND_1(A[1], B[1], G[1]);
VLSI_AND2 AND_2(A[2], B[2], G[2]);
VLSI_AND2 AND_3(A[3], B[3], G[3]);
VLSI_AND2 AND_4(A[4], B[4], G[4]);
VLSI_AND2 AND_5(A[5], B[5], G[5]);
VLSI_AND2 AND_6(A[6], B[6], G[6]);
VLSI_AND2 AND_7(A[7], B[7], G[7]);
VLSI_AND2 AND_8(A[8], B[8], G[8]);
VLSI_AND2 AND_9(A[9], B[9], G[9]);
VLSI_AND2 AND_10(A[10], B[10], G[10]);
VLSI_AND2 AND_11(A[11], B[11], G[11]);
VLSI_AND2 AND_12(A[12], B[12], G[12]);

Carry_Lookahead_Generator_13bit CLA(G,P,C);

assign S[0] = P[0];
VLSI_XOR2 SUM_x1(P[1], C[0], S[1]);
VLSI_XOR2 SUM_x2(P[2], C[1], S[2]);
VLSI_XOR2 SUM_x3(P[3], C[2], S[3]);
VLSI_XOR2 SUM_x4(P[4], C[3], S[4]);
VLSI_XOR2 SUM_x5(P[5], C[4], S[5]);
VLSI_XOR2 SUM_x6(P[6], C[5], S[6]);
VLSI_XOR2 SUM_x7(P[7], C[6], S[7]);
VLSI_XOR2 SUM_x8(P[8], C[7], S[8]);
VLSI_XOR2 SUM_x9(P[9], C[8], S[9]);
VLSI_XOR2 SUM_x10(P[10], C[9], S[10]);
VLSI_XOR2 SUM_x11(P[11], C[10], S[11]);
VLSI_XOR2 SUM_x12(P[12], C[11], S[12]);

endmodule

module Carry_Lookahead_Generator_13bit(
    input [12:0] G,  // Generate signals
    input [12:0] P,  // Propagate signals
    output [12:0] C  // Carry-out signals for each bit
);
// C1 = G0 + P0Cin
//VLSI_AND2 c1_p0cin(P[0], Cin, p0cin); -> No Cin -> P[0]
assign C[0] = G[0];
// C2 = G1 + P1(G0 + P0Cin)
VLSI_AND2 c2_and1(P[1], G[0], p1g0);
VLSI_OR2 c2_or1(G[1], p1g0, C[1]);
// C3 = G2 + P2(G1 + P1G0 + P1P0Cin)
VLSI_AND2 c3_and1(P[2], G[1], p2g1);
VLSI_AND3 c3_and2(P[2], P[1], G[0], p2p1g0);
VLSI_OR3 c3_or1(G[2], p2g1, p2p1g0, C[2]);
// C4 = G3 + P3(G2 + P2G1 + P2P1G0 + P2P1P0Cin)
VLSI_AND2 c4_and1(P[3], G[2], p3g2);
VLSI_AND3 c4_and2(P[3], P[2], G[1], p3p2g1);
VLSI_AND4 c4_and3(P[3], P[2], P[1], G[0], p3p2p1g0);
VLSI_OR4 c4_or1(G[3], p3g2, p3p2g1, p3p2p1g0, C[3]);
// C5 = G4 + P4(G3 + P3G2 + P3P2G1 + P3P2P1G0 + P3P2P1P0Cin)
VLSI_AND2 c5_and1(P[4], G[3], p4g3);
VLSI_AND3 c5_and2(P[4], P[3], G[2], p4p3g2);
VLSI_AND4 c5_and3(P[4], P[3], P[2], G[1], p4p3p2g1);
VLSI_AND5 c5_and4(P[4], P[3], P[2], P[1], G[0], p4p3p2p1g0);
VLSI_OR5 c5_or1(G[4], p4g3, p4p3g2, p4p3p2g1, p4p3p2p1g0, C[4]);
// C6 = G5 + P5(G4 + P4G3 + P4P3G2 + P4P3P2G1 + P4P3P2P1G0 + P4P3P2P1P0C0)
VLSI_AND2 c6_and1(P[5], G[4], p5g4);
VLSI_AND3 c6_and2(P[5], P[4], G[3], p5p4g3);
VLSI_AND4 c6_and3(P[5], P[4], P[3], G[2], p5p4p3g2);
VLSI_AND5 c6_and4(P[5], P[4], P[3], P[2], G[1], p5p4p3p2g1);
VLSI_AND6 c6_and5(P[5], P[4], P[3], P[2], P[1], G[0], p5p4p3p2p1g0);
VLSI_OR6 c6_or1(G[5], p5g4, p5p4g3, p5p4p3g2, p5p4p3p2g1, p5p4p3p2p1g0, C[5]);

// C7 = G6 + P6(G5 + P5G4 + P5P4G3 + P5P4P3G2 + P5P4P3P2G1 + P5P4P3P2P1G0 + P5P4P3P2P1P0C0)
VLSI_AND2 c7_and1(P[6], G[5], p6g5);
VLSI_AND3 c7_and2(P[6], P[5], G[4], p6p5g4);
VLSI_AND4 c7_and3(P[6], P[5], P[4], G[3], p6p5p4g3);
VLSI_AND5 c7_and4(P[6], P[5], P[4], P[3], G[2], p6p5p4p3g2);
VLSI_AND6 c7_and5(P[6], P[5], P[4], P[3], P[2], G[1], p6p5p4p3p2g1);
VLSI_AND7 c7_and6(P[6], P[5], P[4], P[3], P[2], P[1], G[0], p6p5p4p3p2p1g0);
VLSI_OR7 c7_or1(G[6], p6g5, p6p5g4, p6p5p4g3, p6p5p4p3g2, p6p5p4p3p2g1, p6p5p4p3p2p1g0, C[6]);
// C8 = G7 + P7(G6 + P6G5 + P6P5G4 + P6P5P4G3 + P6P5P4P3G2 + P6P5P4P3P2G1 + P6P5P4P3P2P1G0 + P6P5P4P3P2P1P0C0)
VLSI_AND2 c8_and1(P[7], G[6], p7g6);
VLSI_AND3 c8_and2(P[7], P[6], G[5], p7p6g5);
VLSI_AND4 c8_and3(P[7], P[6], P[5], G[4], p7p6p5g4);
VLSI_AND5 c8_and4(P[7], P[6], P[5], P[4], G[3], p7p6p5p4g3);
VLSI_AND6 c8_and5(P[7], P[6], P[5], P[4], P[3], G[2], p7p6p5p4p3g2);
VLSI_AND7 c8_and6(P[7], P[6], P[5], P[4], P[3], P[2], G[1], p7p6p5p4p3p2g1);
VLSI_AND8 c8_and7(P[7], P[6], P[5], P[4], P[3], P[2], P[1], G[0], p7p6p5p4p3p2p1g0);
VLSI_OR8 c8_or1(G[7], p7g6, p7p6g5, p7p6p5g4, p7p6p5p4g3, p7p6p5p4p3g2, p7p6p5p4p3p2g1, p7p6p5p4p3p2p1g0, C[7]);
// C9 = G8 + P8(G7 + P7G6 + P7P6G5 + P7P6P5G4 + P7P6P5P4G3 + P7P6P5P4P3G2 + P7P6P5P4P3P2G1 + P7P6P5P4P3P2P1G0)
VLSI_AND2 c9_and1(P[8], G[7], p8g7);
VLSI_AND3 c9_and2(P[8], P[7], G[6], p8p7g6);
VLSI_AND4 c9_and3(P[8], P[7], P[6], G[5], p8p7p6g5);
VLSI_AND5 c9_and4(P[8], P[7], P[6], P[5], G[4], p8p7p6p5g4);
VLSI_AND6 c9_and5(P[8], P[7], P[6], P[5], P[4], G[3], p8p7p6p5p4g3);
VLSI_AND7 c9_and6(P[8], P[7], P[6], P[5], P[4], P[3], G[2], p8p7p6p5p4p3g2);
VLSI_AND8 c9_and7(P[8], P[7], P[6], P[5], P[4], P[3], P[2], G[1], p8p7p6p5p4p3p2g1);
VLSI_AND9 c9_and8(P[8], P[7], P[6], P[5], P[4], P[3], P[2], P[1], G[0], p8p7p6p5p4p3p2p1g0);
VLSI_OR9 c9_or1(G[8], p8g7, p8p7g6, p8p7p6g5, p8p7p6p5g4, p8p7p6p5p4g3, p8p7p6p5p4p3g2, p8p7p6p5p4p3p2g1, p8p7p6p5p4p3p2p1g0, C[8]);

// C10 = G9 + P9(G8 + P8G7 + P8P7G6 + P8P7P6G5 + P8P7P6P5G4 + P8P7P6P5P4G3 + P8P7P6P5P4P3G2 + P8P7P6P5P4P3P2G1 + P8P7P6P5P4P3P2P1G0)
VLSI_AND2 c10_and1(P[9], G[8], p9g8);
VLSI_AND3 c10_and2(P[9], P[8], G[7], p9p8g7);
VLSI_AND4 c10_and3(P[9], P[8], P[7], G[6], p9p8p7g6);
VLSI_AND5 c10_and4(P[9], P[8], P[7], P[6], G[5], p9p8p7p6g5);
VLSI_AND6 c10_and5(P[9], P[8], P[7], P[6], P[5], G[4], p9p8p7p6p5g4);
VLSI_AND7 c10_and6(P[9], P[8], P[7], P[6], P[5], P[4], G[3], p9p8p7p6p5p4g3);
VLSI_AND8 c10_and7(P[9], P[8], P[7], P[6], P[5], P[4], P[3], G[2], p9p8p7p6p5p4p3g2);
VLSI_AND9 c10_and8(P[9], P[8], P[7], P[6], P[5], P[4], P[3], P[2], G[1], p9p8p7p6p5p4p3p2g1);
VLSI_AND10 c10_and9(P[9], P[8], P[7], P[6], P[5], P[4], P[3], P[2], P[1], G[0], p9p8p7p6p5p4p3p2p1g0);
VLSI_OR10 c10_or1(G[9], p9g8, p9p8g7, p9p8p7g6, p9p8p7p6g5, p9p8p7p6p5g4, p9p8p7p6p5p4g3, p9p8p7p6p5p4p3g2, p9p8p7p6p5p4p3p2g1, p9p8p7p6p5p4p3p2p1g0, C[9]);

// C11 = G10 + P10(G9 + P9G8 + P9P8G7 + P9P8P7G6 + P9P8P7P6G5 + P9P8P7P6P5G4 + P9P8P7P6P5P4G3 + P9P8P7P6P5P4P3G2 + P9P8P7P6P5P4P3P2G1 + P9P8P7P6P5P4P3P2P1G0)
VLSI_AND2 c11_and1(P[10], G[9], p10g9);
VLSI_AND3 c11_and2(P[10], P[9], G[8], p10p9g8);
VLSI_AND4 c11_and3(P[10], P[9], P[8], G[7], p10p9p8g7);
VLSI_AND5 c11_and4(P[10], P[9], P[8], P[7], G[6], p10p9p8p7g6);
VLSI_AND6 c11_and5(P[10], P[9], P[8], P[7], P[6], G[5], p10p9p8p7p6g5);
VLSI_AND7 c11_and6(P[10], P[9], P[8], P[7], P[6], P[5], G[4], p10p9p8p7p6p5g4);
VLSI_AND8 c11_and7(P[10], P[9], P[8], P[7], P[6], P[5], P[4], G[3], p10p9p8p7p6p5p4g3);
VLSI_AND9 c11_and8(P[10], P[9], P[8], P[7], P[6], P[5], P[4], P[3], G[2], p10p9p8p7p6p5p4p3g2);
VLSI_AND10 c11_and9(P[10], P[9], P[8], P[7], P[6], P[5], P[4], P[3], P[2], G[1], p10p9p8p7p6p5p4p3p2g1);
VLSI_AND11 c11_and10(P[10], P[9], P[8], P[7], P[6], P[5], P[4], P[3], P[2], P[1], G[0], p10p9p8p7p6p5p4p3p2p1g0);
VLSI_OR11 c11_or1(G[10], p10g9, p10p9g8, p10p9p8g7, p10p9p8p7g6, p10p9p8p7p6g5, p10p9p8p7p6p5g4, p10p9p8p7p6p5p4g3, p10p9p8p7p6p5p4p3g2, p10p9p8p7p6p5p4p3p2g1, p10p9p8p7p6p5p4p3p2p1g0, C[10]);

// C12 = G11 + P11(G10 + P10G9 + P10P9G8 + P10P9P8G7 + P10P9P8P7G6 + P10P9P8P7P6G5 + P10P9P8P7P6P5G4 + P10P9P8P7P6P5P4G3 + P10P9P8P7P6P5P4P3G2 + P10P9P8P7P6P5P4P3P2G1 + P10P9P8P7P6P5P4P3P2P1G0)
VLSI_AND2 c12_and1(P[11], G[10], p11g10);
VLSI_AND3 c12_and2(P[11], P[10], G[9], p11p10g9);
VLSI_AND4 c12_and3(P[11], P[10], P[9], G[8], p11p10p9g8);
VLSI_AND5 c12_and4(P[11], P[10], P[9], P[8], G[7], p11p10p9p8g7);
VLSI_AND6 c12_and5(P[11], P[10], P[9], P[8], P[7], G[6], p11p10p9p8p7g6);
VLSI_AND7 c12_and6(P[11], P[10], P[9], P[8], P[7], P[6], G[5], p11p10p9p8p7p6g5);
VLSI_AND8 c12_and7(P[11], P[10], P[9], P[8], P[7], P[6], P[5], G[4], p11p10p9p8p7p6p5g4);
VLSI_AND9 c12_and8(P[11], P[10], P[9], P[8], P[7], P[6], P[5], P[4], G[3], p11p10p9p8p7p6p5p4g3);
VLSI_AND10 c12_and9(P[11], P[10], P[9], P[8], P[7], P[6], P[5], P[4], P[3], G[2], p11p10p9p8p7p6p5p4p3g2);
VLSI_AND11 c12_and10(P[11], P[10], P[9], P[8], P[7], P[6], P[5], P[4], P[3], P[2], G[1], p11p10p9p8p7p6p5p4p3p2g1);
VLSI_AND12 c12_and11(P[11], P[10], P[9], P[8], P[7], P[6], P[5], P[4], P[3], P[2], P[1], G[0], p11p10p9p8p7p6p5p4p3p2p1g0);
VLSI_OR12 c12_or1(G[11], p11g10, p11p10g9, p11p10p9g8, p11p10p9p8g7, p11p10p9p8p7g6, p11p10p9p8p7p6g5, p11p10p9p8p7p6p5g4, p11p10p9p8p7p6p5p4g3, p11p10p9p8p7p6p5p4p3g2, p11p10p9p8p7p6p5p4p3p2g1, p11p10p9p8p7p6p5p4p3p2p1g0, C[11]);

endmodule

module Carry_Lookahead_Generator_6bit_with_carry(
    input [5:0] G,   // Generate signals
    input [5:0] P,   // Propagate signals
    input Cin,        // Input carry
    output [5:0] C   // Carry-out signals for each bit
);

// C1 = G0 + P0Cin
VLSI_AND2 c1_p0cin(P[0], Cin, p0cin);
VLSI_OR2 c1_or1(G[0], p0cin, C[0]);

// C2 = G1 + P1(G0 + P0Cin)
VLSI_AND2 c2_and1(P[1], G[0], p1g0);
VLSI_AND2 c2_and2(P[1], p0cin, p1p0cin);
VLSI_OR3 c2_or1(G[1], p1g0, p1p0cin, C[1]);

// C3 = G2 + P2(G1 + P1G0 + P1P0Cin)
VLSI_AND2 c3_and1(P[2], G[1], p2g1);
VLSI_AND2 c3_and2(P[2], p1g0, p2p1g0);
VLSI_AND2 c3_and3(P[2], p1p0cin, p2p1p0cin);
VLSI_OR4 c3_or1(G[2], p2g1, p2p1g0, p2p1p0cin, C[2]);

// C4 = G3 + P3(G2 + P2G1 + P2P1G0 + P2P1P0Cin)
VLSI_AND2 c4_and1(P[3], G[2], p3g2);
VLSI_AND2 c4_and2(P[3], p2g1, p3p2g1);
VLSI_AND2 c4_and3(P[3], p2p1g0, p3p2p1g0);
VLSI_AND2 c4_and4(P[3], p2p1p0cin, p3p2p1p0cin);
VLSI_OR5 c4_or1(G[3], p3g2, p3p2g1, p3p2p1g0, p3p2p1p0cin, C[3]);

// C5 = G4 + P4(G3 + P3G2 + P3P2G1 + P3P2P1G0 + P3P2P1P0Cin)
VLSI_AND2 c5_and1(P[4], G[3], p4g3);
VLSI_AND2 c5_and2(P[4], p3g2, p4p3g2);
VLSI_AND2 c5_and3(P[4], p3p2g1, p4p3p2g1);
VLSI_AND2 c5_and4(P[4], p3p2p1g0, p4p3p2p1g0);
VLSI_AND2 c5_and5(P[4], p3p2p1p0cin, p4p3p2p1p0cin);
VLSI_OR6 c5_or1(G[4], p4g3, p4p3g2, p4p3p2g1, p4p3p2p1g0, p4p3p2p1p0cin, C[4]);

// C6 = G5 + P5(G4 + P4G3 + P4P3G2 + P4P3P2G1 + P4P3P2P1G0 + P4P3P2P1P0Cin)
VLSI_AND2 c6_and1(P[5], G[4], p5g4);
VLSI_AND2 c6_and2(P[5], p4g3, p5p4g3);
VLSI_AND2 c6_and3(P[5], p4p3g2, p5p4p3g2);
VLSI_AND2 c6_and4(P[5], p4p3p2g1, p5p4p3p2g1);
VLSI_AND2 c6_and5(P[5], p4p3p2p1g0, p5p4p3p2p1g0);
VLSI_AND2 c6_and6(P[5], p4p3p2p1p0cin, p5p4p3p2p1p0cin);
VLSI_OR7 c6_or1(G[5], p5g4, p5p4g3, p5p4p3g2, p5p4p3p2g1, p5p4p3p2p1g0, p5p4p3p2p1p0cin, C[5]);
endmodule

module Carry_Lookahead_Generator_4bit_with_carry(
    input [3:0] G,   // Generate signals
    input [3:0] P,   // Propagate signals
    input Cin,        // Input carry
    output [3:0] C   // Carry-out signals for each bit
);

// C1 = G0 + P0Cin
VLSI_AND2 c1_p0cin(P[0], Cin, p0cin);
VLSI_OR2 c1_or1(G[0], p0cin, C[0]);
// C2 = G1 + P1(G0 + P0Cin)
VLSI_AND2 c2_and1(P[1], G[0], p1g0);
VLSI_AND3 c2_and2(P[1], P[0], Cin, p1p0cin);
VLSI_OR3 c2_or1(G[1], p1g0, p1p0cin, C[1]);
// C3 = G2 + P2(G1 + P1G0 + P1P0Cin)
VLSI_AND2 c3_and1(P[2], G[1], p2g1);
VLSI_AND3 c3_and2(P[2], P[1], G[0], p2p1g0);
VLSI_AND4 c3_and3(P[2], P[1], P[0], Cin, p2p1p0cin);
VLSI_OR4 c3_or1(G[2], p2g1, p2p1g0, p2p1p0cin, C[2]);
// C4 = G3 + P3(G2 + P2G1 + P2P1G0 + P2P1P0Cin)
VLSI_AND2 c4_and1(P[3], G[2], p3g2);
VLSI_AND3 c4_and2(P[3], P[2], G[1], p3p2g1);
VLSI_AND4 c4_and3(P[3], P[2], P[1], G[0], p3p2p1g0);
VLSI_AND5 c4_and4(P[3], P[2], P[1], P[0], Cin, p3p2p1p0cin);
VLSI_OR5 c4_or1(G[3], p3g2, p3p2g1, p3p2p1g0, p3p2p1p0cin, C[3]);
endmodule

module Carry_Lookahead_Generator_9bit(
    input [8:0] G,  // Generate signals
    input [8:0] P,  // Propagate signals
    output [8:0] C  // Carry-out signals for each bit
);
// C1 = G0 + P0Cin
//VLSI_AND2 c1_p0cin(P[0], Cin, p0cin); -> No Cin -> P[0]
assign C[0] = G[0];
// C2 = G1 + P1(G0 + P0Cin)
VLSI_AND2 c2_and1(P[1], G[0], p1g0);
VLSI_OR2 c2_or1(G[1], p1g0, C[1]);
// C3 = G2 + P2(G1 + P1G0 + P1P0Cin)
VLSI_AND2 c3_and1(P[2], G[1], p2g1);
VLSI_AND3 c3_and2(P[2], P[1], G[0], p2p1g0);
VLSI_OR3 c3_or1(G[2], p2g1, p2p1g0, C[2]);
// C4 = G3 + P3(G2 + P2G1 + P2P1G0 + P2P1P0Cin)
VLSI_AND2 c4_and1(P[3], G[2], p3g2);
VLSI_AND3 c4_and2(P[3], P[2], G[1], p3p2g1);
VLSI_AND4 c4_and3(P[3], P[2], P[1], G[0], p3p2p1g0);
VLSI_OR4 c4_or1(G[3], p3g2, p3p2g1, p3p2p1g0, C[3]);
// C5 = G4 + P4(G3 + P3G2 + P3P2G1 + P3P2P1G0 + P3P2P1P0Cin)
VLSI_AND2 c5_and1(P[4], G[3], p4g3);
VLSI_AND3 c5_and2(P[4], P[3], G[2], p4p3g2);
VLSI_AND4 c5_and3(P[4], P[3], P[2], G[1], p4p3p2g1);
VLSI_AND5 c5_and4(P[4], P[3], P[2], P[1], G[0], p4p3p2p1g0);
VLSI_OR5 c5_or1(G[4], p4g3, p4p3g2, p4p3p2g1, p4p3p2p1g0, C[4]);
// C6 = G5 + P5(G4 + P4G3 + P4P3G2 + P4P3P2G1 + P4P3P2P1G0 + P4P3P2P1P0C0)
VLSI_AND2 c6_and1(P[5], G[4], p5g4);
VLSI_AND3 c6_and2(P[5], P[4], G[3], p5p4g3);
VLSI_AND4 c6_and3(P[5], P[4], P[3], G[2], p5p4p3g2);
VLSI_AND5 c6_and4(P[5], P[4], P[3], P[2], G[1], p5p4p3p2g1);
VLSI_AND6 c6_and5(P[5], P[4], P[3], P[2], P[1], G[0], p5p4p3p2p1g0);
VLSI_OR6 c6_or1(G[5], p5g4, p5p4g3, p5p4p3g2, p5p4p3p2g1, p5p4p3p2p1g0, C[5]);
// C7 = G6 + P6(G5 + P5G4 + P5P4G3 + P5P4P3G2 + P5P4P3P2G1 + P5P4P3P2P1G0 + P5P4P3P2P1P0C0)
VLSI_AND2 c7_and1(P[6], G[5], p6g5);
VLSI_AND3 c7_and2(P[6], P[5], G[4], p6p5g4);
VLSI_AND4 c7_and3(P[6], P[5], P[4], G[3], p6p5p4g3);
VLSI_AND5 c7_and4(P[6], P[5], P[4], P[3], G[2], p6p5p4p3g2);
VLSI_AND6 c7_and5(P[6], P[5], P[4], P[3], P[2], G[1], p6p5p4p3p2g1);
VLSI_AND7 c7_and6(P[6], P[5], P[4], P[3], P[2], P[1], G[0], p6p5p4p3p2p1g0);
VLSI_OR7 c7_or1(G[6], p6g5, p6p5g4, p6p5p4g3, p6p5p4p3g2, p6p5p4p3p2g1, p6p5p4p3p2p1g0, C[6]);
// C8 = G7 + P7(G6 + P6G5 + P6P5G4 + P6P5P4G3 + P6P5P4P3G2 + P6P5P4P3P2G1 + P6P5P4P3P2P1G0 + P6P5P4P3P2P1P0C0)
VLSI_AND2 c8_and1(P[7], G[6], p7g6);
VLSI_AND3 c8_and2(P[7], P[6], G[5], p7p6g5);
VLSI_AND4 c8_and3(P[7], P[6], P[5], G[4], p7p6p5g4);
VLSI_AND5 c8_and4(P[7], P[6], P[5], P[4], G[3], p7p6p5p4g3);
VLSI_AND6 c8_and5(P[7], P[6], P[5], P[4], P[3], G[2], p7p6p5p4p3g2);
VLSI_AND7 c8_and6(P[7], P[6], P[5], P[4], P[3], P[2], G[1], p7p6p5p4p3p2g1);
VLSI_AND8 c8_and7(P[7], P[6], P[5], P[4], P[3], P[2], P[1], G[0], p7p6p5p4p3p2p1g0);
VLSI_OR8 c8_or1(G[7], p7g6, p7p6g5, p7p6p5g4, p7p6p5p4g3, p7p6p5p4p3g2, p7p6p5p4p3p2g1, p7p6p5p4p3p2p1g0, C[7]);
// C9 = G8 + P8(G7 + P7G6 + P7P6G5 + P7P6P5G4 + P7P6P5P4G3 + P7P6P5P4P3G2 + P7P6P5P4P3P2G1 + P7P6P5P4P3P2P1G0)
VLSI_AND2 c9_and1(P[8], G[7], p8g7);
VLSI_AND3 c9_and2(P[8], P[7], G[6], p8p7g6);
VLSI_AND4 c9_and3(P[8], P[7], P[6], G[5], p8p7p6g5);
VLSI_AND5 c9_and4(P[8], P[7], P[6], P[5], G[4], p8p7p6p5g4);
VLSI_AND6 c9_and5(P[8], P[7], P[6], P[5], P[4], G[3], p8p7p6p5p4g3);
VLSI_AND7 c9_and6(P[8], P[7], P[6], P[5], P[4], P[3], G[2], p8p7p6p5p4p3g2);
VLSI_AND8 c9_and7(P[8], P[7], P[6], P[5], P[4], P[3], P[2], G[1], p8p7p6p5p4p3p2g1);
VLSI_AND9 c9_and8(P[8], P[7], P[6], P[5], P[4], P[3], P[2], P[1], G[0], p8p7p6p5p4p3p2p1g0);
VLSI_OR9 c9_or1(G[8], p8g7, p8p7g6, p8p7p6g5, p8p7p6p5g4, p8p7p6p5p4g3, p8p7p6p5p4p3g2, p8p7p6p5p4p3p2g1, p8p7p6p5p4p3p2p1g0, C[8]);
endmodule

module Carry_Lookahead_Generator_6bit(
    input [5:0] G,  // Generate signals
    input [5:0] P,  // Propagate signals
    output [5:0] C  // Carry-out signals for each bit
);
// C1 = G0 + P0Cin
//VLSI_AND2 c1_p0cin(P[0], Cin, p0cin); -> No Cin -> P[0]
assign C[0] = G[0];
// C2 = G1 + P1(G0 + P0Cin)
VLSI_AND2 c2_and1(P[1], G[0], p1g0);
VLSI_OR2 c2_or1(G[1], p1g0, C[1]);
// C3 = G2 + P2(G1 + P1G0 + P1P0Cin)
VLSI_AND2 c3_and1(P[2], G[1], p2g1);
VLSI_AND2 c3_and2(P[2], p1g0, p2p1g0);
VLSI_OR3 c3_or1(G[2], p2g1, p2p1g0, C[2]);
// C4 = G3 + P3(G2 + P2G1 + P2P1G0 + P2P1P0Cin)
VLSI_AND2 c4_and1(P[3], G[2], p3g2);
VLSI_AND2 c4_and2(P[3], p2g1, p3p2g1);
VLSI_AND2 c4_and3(P[3], p2p1g0, p3p2p1g0);
VLSI_OR4 c4_or1(G[3], p3g2, p3p2g1, p3p2p1g0, C[3]);
// C5 = G4 + P4(G3 + P3G2 + P3P2G1 + P3P2P1G0 + P3P2P1P0Cin)
VLSI_AND2 c5_and1(P[4], G[3], p4g3);
VLSI_AND2 c5_and2(P[4], p3g2, p4p3g2);
VLSI_AND2 c5_and3(P[4], p3p2g1, p4p3p2g1);
VLSI_AND2 c5_and4(P[4], p3p2p1g0, p4p3p2p1g0);
VLSI_OR5 c5_or1(G[4], p4g3, p4p3g2, p4p3p2g1, p4p3p2p1g0, C[4]);
// C6 = G5 + P5G4 + P5P4G3 + P5P4P3G2 + P5P4P3P2G1 + P5P4P3P2P1G0 + P5P4P3P2P1P0C0 
VLSI_AND2 c6_and1(P[5], G[4], p5g4);
VLSI_AND2 c6_and2(P[5], p4g3, p5p4g3);
VLSI_AND2 c6_and3(P[5], p4p3g2, p5p4p3g2);
VLSI_AND2 c6_and4(P[5], p4p3p2g1, p5p4p3p2g1);
VLSI_AND2 c6_and5(P[5], p4p3p2p1g0, p5p4p3p2p1g0);
VLSI_OR6 c6_or1(G[5], p5g4, p5p4g3, p5p4p3g2, p5p4p3p2g1, p5p4p3p2p1g0, C[5]);
endmodule

module Carry_Lookahead_Generator_4bit(
    input [3:0] G,  // Generate signals
    input [3:0] P,  // Propagate signals
    output [3:0] C  // Carry-out signals for each bit
);
// C1 = G0 + P0Cin
//VLSI_AND2 c1_p0cin(P[0], Cin, p0cin); -> No Cin -> P[0]
assign C[0] = G[0];
// C2 = G1 + P1(G0 + P0Cin)
VLSI_AND2 c2_and1(P[1], G[0], p1g0);
VLSI_OR2 c2_or1(G[1], p1g0, C[1]);
// C3 = G2 + P2(G1 + P1G0 + P1P0Cin)
VLSI_AND2 c3_and1(P[2], G[1], p2g1);
VLSI_AND3 c3_and2(P[2], P[1], G[0], p2p1g0);
VLSI_OR3 c3_or1(G[2], p2g1, p2p1g0, C[2]);
// C4 = G3 + P3(G2 + P2G1 + P2P1G0 + P2P1P0Cin)
VLSI_AND2 c4_and1(P[3], G[2], p3g2);
VLSI_AND3 c4_and2(P[3], P[2], G[1], p3p2g1);
VLSI_AND4 c4_and3(P[3], P[2], P[1], G[0], p3p2p1g0);
VLSI_OR4 c4_or1(G[3], p3g2, p3p2g1, p3p2p1g0, C[3]);
endmodule

module FA9_CLA4(
input [8:0] A,
input [8:0] B,
output [8:0] S
);
wire [8:0] P,G,C;

VLSI_XOR2 XOR_x0(A[0], B[0], P[0]);
VLSI_XOR2 XOR_x1(A[1], B[1], P[1]);
VLSI_XOR2 XOR_x2(A[2], B[2], P[2]);
VLSI_XOR2 XOR_x3(A[3], B[3], P[3]);
VLSI_XOR2 XOR_x4(A[4], B[4], P[4]);
VLSI_XOR2 XOR_x5(A[5], B[5], P[5]);
VLSI_XOR2 XOR_x6(A[6], B[6], P[6]);
VLSI_XOR2 XOR_x7(A[7], B[7], P[7]);
VLSI_XOR2 XOR_x8(A[8], B[8], P[8]);

VLSI_AND2 AND_0(A[0], B[0], G[0]);
VLSI_AND2 AND_1(A[1], B[1], G[1]);
VLSI_AND2 AND_2(A[2], B[2], G[2]);
VLSI_AND2 AND_3(A[3], B[3], G[3]);
VLSI_AND2 AND_4(A[4], B[4], G[4]);
VLSI_AND2 AND_5(A[5], B[5], G[5]);
VLSI_AND2 AND_6(A[6], B[6], G[6]);
VLSI_AND2 AND_7(A[7], B[7], G[7]);
VLSI_AND2 AND_8(A[8], B[8], G[8]);

Carry_Lookahead_Generator_4bit CLA0(G[3:0],P[3:0], C[3:0]);
Carry_Lookahead_Generator_4bit_with_carry CLA1(G[7:4],P[7:4], C[3], C[7:4]);

assign S[0] = P[0];
VLSI_XOR2 SUM_x1(P[1], C[0], S[1]);
VLSI_XOR2 SUM_x2(P[2], C[1], S[2]);
VLSI_XOR2 SUM_x3(P[3], C[2], S[3]);
VLSI_XOR2 SUM_x4(P[4], C[3], S[4]);
VLSI_XOR2 SUM_x5(P[5], C[4], S[5]);
VLSI_XOR2 SUM_x6(P[6], C[5], S[6]);
VLSI_XOR2 SUM_x7(P[7], C[6], S[7]);
VLSI_XOR2 SUM_x8(P[8], C[7], S[8]);
endmodule

module FA13_CLA4(
input [12:0] A,
input [12:0] B,
output [12:0] S
);
wire [12:0] P,G,C;

VLSI_XOR2 XOR_x0(A[0], B[0], P[0]);
VLSI_XOR2 XOR_x1(A[1], B[1], P[1]);
VLSI_XOR2 XOR_x2(A[2], B[2], P[2]);
VLSI_XOR2 XOR_x3(A[3], B[3], P[3]);
VLSI_XOR2 XOR_x4(A[4], B[4], P[4]);
VLSI_XOR2 XOR_x5(A[5], B[5], P[5]);
VLSI_XOR2 XOR_x6(A[6], B[6], P[6]);
VLSI_XOR2 XOR_x7(A[7], B[7], P[7]);
VLSI_XOR2 XOR_x8(A[8], B[8], P[8]);
VLSI_XOR2 XOR_x9(A[9], B[9], P[9]);
VLSI_XOR2 XOR_x10(A[10], B[10], P[10]);
VLSI_XOR2 XOR_x11(A[11], B[11], P[11]);
VLSI_XOR2 XOR_x12(A[12], B[12], P[12]);

VLSI_AND2 AND_0(A[0], B[0], G[0]);
VLSI_AND2 AND_1(A[1], B[1], G[1]);
VLSI_AND2 AND_2(A[2], B[2], G[2]);
VLSI_AND2 AND_3(A[3], B[3], G[3]);
VLSI_AND2 AND_4(A[4], B[4], G[4]);
VLSI_AND2 AND_5(A[5], B[5], G[5]);
VLSI_AND2 AND_6(A[6], B[6], G[6]);
VLSI_AND2 AND_7(A[7], B[7], G[7]);
VLSI_AND2 AND_8(A[8], B[8], G[8]);
VLSI_AND2 AND_9(A[9], B[9], G[9]);
VLSI_AND2 AND_10(A[10], B[10], G[10]);
VLSI_AND2 AND_11(A[11], B[11], G[11]);
VLSI_AND2 AND_12(A[12], B[12], G[12]);

Carry_Lookahead_Generator_4bit CLA0(G[3:0],P[3:0], C[3:0]);
Carry_Lookahead_Generator_4bit_with_carry CLA1(G[7:4],P[7:4], C[3], C[7:4]);
Carry_Lookahead_Generator_4bit_with_carry CLA2(G[11:8],P[11:8], C[7], C[11:8]);

assign S[0] = P[0];
VLSI_XOR2 SUM_x1(P[1], C[0], S[1]);
VLSI_XOR2 SUM_x2(P[2], C[1], S[2]);
VLSI_XOR2 SUM_x3(P[3], C[2], S[3]);
VLSI_XOR2 SUM_x4(P[4], C[3], S[4]);
VLSI_XOR2 SUM_x5(P[5], C[4], S[5]);
VLSI_XOR2 SUM_x6(P[6], C[5], S[6]);
VLSI_XOR2 SUM_x7(P[7], C[6], S[7]);
VLSI_XOR2 SUM_x8(P[8], C[7], S[8]);
VLSI_XOR2 SUM_x9(P[9], C[8], S[9]);
VLSI_XOR2 SUM_x10(P[10], C[9], S[10]);
VLSI_XOR2 SUM_x11(P[11], C[10], S[11]);
VLSI_XOR2 SUM_x12(P[12], C[11], S[12]);

endmodule

module FA13_CLA6(
input [12:0] A,
input [12:0] B,
output [12:0] S
);
wire [12:0] P,G,C;

VLSI_XOR2 XOR_x0(A[0], B[0], P[0]);
VLSI_XOR2 XOR_x1(A[1], B[1], P[1]);
VLSI_XOR2 XOR_x2(A[2], B[2], P[2]);
VLSI_XOR2 XOR_x3(A[3], B[3], P[3]);
VLSI_XOR2 XOR_x4(A[4], B[4], P[4]);
VLSI_XOR2 XOR_x5(A[5], B[5], P[5]);
VLSI_XOR2 XOR_x6(A[6], B[6], P[6]);
VLSI_XOR2 XOR_x7(A[7], B[7], P[7]);
VLSI_XOR2 XOR_x8(A[8], B[8], P[8]);
VLSI_XOR2 XOR_x9(A[9], B[9], P[9]);
VLSI_XOR2 XOR_x10(A[10], B[10], P[10]);
VLSI_XOR2 XOR_x11(A[11], B[11], P[11]);
VLSI_XOR2 XOR_x12(A[12], B[12], P[12]);

VLSI_AND2 AND_0(A[0], B[0], G[0]);
VLSI_AND2 AND_1(A[1], B[1], G[1]);
VLSI_AND2 AND_2(A[2], B[2], G[2]);
VLSI_AND2 AND_3(A[3], B[3], G[3]);
VLSI_AND2 AND_4(A[4], B[4], G[4]);
VLSI_AND2 AND_5(A[5], B[5], G[5]);
VLSI_AND2 AND_6(A[6], B[6], G[6]);
VLSI_AND2 AND_7(A[7], B[7], G[7]);
VLSI_AND2 AND_8(A[8], B[8], G[8]);
VLSI_AND2 AND_9(A[9], B[9], G[9]);
VLSI_AND2 AND_10(A[10], B[10], G[10]);
VLSI_AND2 AND_11(A[11], B[11], G[11]);
VLSI_AND2 AND_12(A[12], B[12], G[12]);

Carry_Lookahead_Generator_6bit CLA0(G[5:0],P[5:0], C[5:0]);
Carry_Lookahead_Generator_6bit_with_carry CLA1(G[11:6],P[11:6], C[5], C[11:6]);

assign S[0] = P[0];
VLSI_XOR2 SUM_x1(P[1], C[0], S[1]);
VLSI_XOR2 SUM_x2(P[2], C[1], S[2]);
VLSI_XOR2 SUM_x3(P[3], C[2], S[3]);
VLSI_XOR2 SUM_x4(P[4], C[3], S[4]);
VLSI_XOR2 SUM_x5(P[5], C[4], S[5]);
VLSI_XOR2 SUM_x6(P[6], C[5], S[6]);
VLSI_XOR2 SUM_x7(P[7], C[6], S[7]);
VLSI_XOR2 SUM_x8(P[8], C[7], S[8]);
VLSI_XOR2 SUM_x9(P[9], C[8], S[9]);
VLSI_XOR2 SUM_x10(P[10], C[9], S[10]);
VLSI_XOR2 SUM_x11(P[11], C[10], S[11]);
VLSI_XOR2 SUM_x12(P[12], C[11], S[12]);

endmodule

module VLSI_NAND5(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 OUT);
input  INA, INB, INC, IND, INE;
output OUT;

VLSI_AND3 x1(INA,INB,INC,x1_out);
VLSI_AND2 x2(IND,INE, x2_out);
VLSI_NAND2 x3(x1_out,x2_out, OUT);
endmodule

module VLSI_NAND6(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 OUT);
input  INA, INB, INC, IND, INE, INF;
output OUT;

VLSI_AND3 x1(INA,INB,INC,x1_out);
VLSI_AND3 x2(IND,INE,INF,x2_out);
VLSI_NAND2 x3(x1_out,x2_out, OUT);
endmodule

module VLSI_NAND7(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING;
output OUT;

VLSI_AND3 x1(INA,INB,INC,x1_out);
VLSI_AND4 x2(IND,INE,INF,ING,x2_out);
VLSI_NAND2 x3(x1_out,x2_out, OUT);
endmodule

module VLSI_NAND8(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 INH,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING, INH;
output OUT;

VLSI_AND4 x1(INA,INB,INC,IND, x1_out);
VLSI_AND4 x2(INE,INF,ING,INH, x2_out);
VLSI_NAND2 x3(x1_out,x2_out, OUT);
endmodule

module VLSI_NAND9(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 INH,
                 INI,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING, INH, INI;
output OUT;

VLSI_AND3 x1(INA,INB,INC, x1_out);
VLSI_AND3 x2(IND,INE,INF, x2_out);
VLSI_AND3 x3(ING,INH,INI, x3_out);
VLSI_NAND3 x4(x1_out,x2_out,x3_out,OUT);
endmodule

module VLSI_NAND10(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 INH,
                 INI,
                 INJ,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING, INH, INI, INJ;
output OUT;

VLSI_AND3 x1(INA,INB,INC, x1_out);
VLSI_AND3 x2(IND,INE,INF, x2_out);
VLSI_AND4 x3(ING,INH,INI, INJ, x3_out);
VLSI_NAND3 x4(x1_out,x2_out,x3_out,OUT);
endmodule

module VLSI_NAND11(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 INH,
                 INI,
                 INJ,
                 INK,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING, INH, INI, INJ, INK;
output OUT;

VLSI_AND3 x1(INA,INB,INC, x1_out);
VLSI_AND4 x2(IND,INE,INF,ING, x2_out);
VLSI_AND4 x3(INH,INI,INJ,INK, x3_out);
VLSI_NAND3 x4(x1_out,x2_out,x3_out,OUT);
endmodule

module VLSI_NAND12(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 INH,
                 INI,
                 INJ,
                 INK,
                 INL,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING, INH, INI, INJ, INK, INL;
output OUT;

VLSI_AND4 x1(INA,INB,INC,IND, x1_out);
VLSI_AND4 x2(INE,INF,ING,INH, x2_out);
VLSI_AND4 x3(INI,INJ,INK,INL, x3_out);
VLSI_NAND3 x4(x1_out,x2_out,x3_out,OUT);
endmodule

module VLSI_NAND13(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 INH,
                 INI,
                 INJ,
                 INK,
                 INL,
                 INM,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING, INH, INI, INJ, INK, INL, INM;
output OUT;
VLSI_AND4 x1(INA,INB,INC,IND, x1_out);
VLSI_AND3 x2(INE,INF,ING, x2_out);
VLSI_AND3 x3(INH,INI,INJ, x3_out);
VLSI_AND3 x4(INK,INL,INM, x4_out);
VLSI_NAND4 x5(x1_out,x2_out,x3_out,x4_out,OUT);
endmodule

module VLSI_AND5(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 OUT);
input  INA, INB, INC, IND, INE;
output OUT;

VLSI_AND3 x1(INA,INB,INC,x1_out);
VLSI_AND2 x2(IND,INE, x2_out);
VLSI_AND2 x3(x1_out,x2_out, OUT);
endmodule

module VLSI_AND6(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 OUT);
input  INA, INB, INC, IND, INE, INF;
output OUT;

VLSI_AND3 x1(INA,INB,INC,x1_out);
VLSI_AND3 x2(IND,INE,INF,x2_out);
VLSI_AND2 x3(x1_out,x2_out, OUT);
endmodule

module VLSI_AND7(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING;
output OUT;

VLSI_AND3 x1(INA,INB,INC,x1_out);
VLSI_AND4 x2(IND,INE,INF,ING,x2_out);
VLSI_AND2 x3(x1_out,x2_out, OUT);
endmodule

module VLSI_AND8(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 INH,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING, INH;
output OUT;

VLSI_AND4 x1(INA,INB,INC,IND, x1_out);
VLSI_AND4 x2(INE,INF,ING,INH, x2_out);
VLSI_AND2 x3(x1_out,x2_out, OUT);
endmodule

module VLSI_AND9(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 INH,
                 INI,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING, INH, INI;
output OUT;

VLSI_AND3 x1(INA,INB,INC, x1_out);
VLSI_AND3 x2(IND,INE,INF, x2_out);
VLSI_AND3 x3(ING,INH,INI, x3_out);
VLSI_AND3 x4(x1_out,x2_out,x3_out,OUT);
endmodule

module VLSI_AND10(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 INH,
                 INI,
                 INJ,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING, INH, INI, INJ;
output OUT;

VLSI_AND3 x1(INA,INB,INC, x1_out);
VLSI_AND3 x2(IND,INE,INF, x2_out);
VLSI_AND4 x3(ING,INH,INI, INJ, x3_out);
VLSI_AND3 x4(x1_out,x2_out,x3_out,OUT);
endmodule

module VLSI_AND11(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 INH,
                 INI,
                 INJ,
                 INK,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING, INH, INI, INJ, INK;
output OUT;

VLSI_AND3 x1(INA,INB,INC, x1_out);
VLSI_AND4 x2(IND,INE,INF,ING, x2_out);
VLSI_AND4 x3(INH,INI,INJ,INK, x3_out);
VLSI_AND3 x4(x1_out,x2_out,x3_out,OUT);
endmodule

module VLSI_AND12(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 INH,
                 INI,
                 INJ,
                 INK,
                 INL,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING, INH, INI, INJ, INK, INL;
output OUT;

VLSI_AND4 x1(INA,INB,INC,IND, x1_out);
VLSI_AND4 x2(INE,INF,ING,INH, x2_out);
VLSI_AND4 x3(INI,INJ,INK,INL, x3_out);
VLSI_AND3 x4(x1_out,x2_out,x3_out,OUT);
endmodule

module VLSI_AND13(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 INH,
                 INI,
                 INJ,
                 INK,
                 INL,
                 INM,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING, INH, INI, INJ, INK, INL, INM;
output OUT;
VLSI_AND4 x1(INA,INB,INC,IND, x1_out);
VLSI_AND3 x2(INE,INF,ING, x2_out);
VLSI_AND3 x3(INH,INI,INJ, x3_out);
VLSI_AND3 x4(INK,INL,INM, x4_out);
VLSI_AND4 x5(x1_out,x2_out,x3_out,x4_out,OUT);
endmodule

module VLSI_OR5(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 OUT);
input  INA, INB, INC, IND, INE;
output OUT;

VLSI_OR3 x1(INA,INB,INC,x1_out);
VLSI_OR2 x2(IND,INE, x2_out);
VLSI_OR2 x3(x1_out,x2_out, OUT);
endmodule

module VLSI_OR6(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 OUT);
input  INA, INB, INC, IND, INE, INF;
output OUT;

VLSI_OR3 x1(INA,INB,INC,x1_out);
VLSI_OR3 x2(IND,INE,INF,x2_out);
VLSI_OR2 x3(x1_out,x2_out, OUT);
endmodule

module VLSI_OR7(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING;
output OUT;

VLSI_OR3 x1(INA,INB,INC,x1_out);
VLSI_OR4 x2(IND,INE,INF,ING,x2_out);
VLSI_OR2 x3(x1_out,x2_out, OUT);
endmodule

module VLSI_OR8(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 INH,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING, INH;
output OUT;

VLSI_OR4 x1(INA,INB,INC,IND, x1_out);
VLSI_OR4 x2(INE,INF,ING,INH, x2_out);
VLSI_OR2 x3(x1_out,x2_out, OUT);
endmodule

module VLSI_OR9(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 INH,
                 INI,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING, INH, INI;
output OUT;

VLSI_OR3 x1(INA,INB,INC, x1_out);
VLSI_OR3 x2(IND,INE,INF, x2_out);
VLSI_OR3 x3(ING,INH,INI, x3_out);
VLSI_OR3 x4(x1_out,x2_out,x3_out,OUT);
endmodule

module VLSI_OR10(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 INH,
                 INI,
                 INJ,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING, INH, INI, INJ;
output OUT;

VLSI_OR3 x1(INA,INB,INC, x1_out);
VLSI_OR3 x2(IND,INE,INF, x2_out);
VLSI_OR4 x3(ING,INH,INI, INJ, x3_out);
VLSI_OR3 x4(x1_out,x2_out,x3_out,OUT);
endmodule

module VLSI_OR11(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 INH,
                 INI,
                 INJ,
                 INK,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING, INH, INI, INJ, INK;
output OUT;

VLSI_OR3 x1(INA,INB,INC, x1_out);
VLSI_OR4 x2(IND,INE,INF,ING, x2_out);
VLSI_OR4 x3(INH,INI,INJ,INK, x3_out);
VLSI_OR3 x4(x1_out,x2_out,x3_out,OUT);
endmodule

module VLSI_OR12(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 INH,
                 INI,
                 INJ,
                 INK,
                 INL,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING, INH, INI, INJ, INK, INL;
output OUT;

VLSI_OR4 x1(INA,INB,INC,IND, x1_out);
VLSI_OR4 x2(INE,INF,ING,INH, x2_out);
VLSI_OR4 x3(INI,INJ,INK,INL, x3_out);
VLSI_OR3 x4(x1_out,x2_out,x3_out,OUT);
endmodule

module VLSI_OR13(INA, 
                 INB, 
                 INC, 
                 IND,
                 INE,
                 INF,
                 ING,
                 INH,
                 INI,
                 INJ,
                 INK,
                 INL,
                 INM,
                 OUT);
input  INA, INB, INC, IND, INE, INF, ING, INH, INI, INJ, INK, INL, INM;
output OUT;
VLSI_OR4 x1(INA,INB,INC,IND, x1_out);
VLSI_OR3 x2(INE,INF,ING, x2_out);
VLSI_OR3 x3(INH,INI,INJ, x3_out);
VLSI_OR3 x4(INK,INL,INM, x4_out);
VLSI_OR4 x5(x1_out,x2_out,x3_out,x4_out,OUT);
endmodule