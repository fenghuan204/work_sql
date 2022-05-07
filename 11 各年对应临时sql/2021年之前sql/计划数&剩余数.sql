t2.PLAN_B +t2. PLAN_G + t2.PLAN_G1 + t2.PLAN_G2 bgplan
(t2.PLAN_Y + t2.PLAN_B + t2.PLAN_H + t2.PLAN_K + t2.PLAN_L +
                       t2.PLAN_M + t2.PLAN_N + t2.PLAN_Q + t2. PLAN_T + t2.
                        PLAN_X + t2.PLAN_U + t2.PLAN_E + t2.PLAN_W + t2.PLAN_P +
                        t2.PLAN_P1 + t2.PLAN_P2 + t2.PLAN_O + t2. PLAN_G + t2.PLAN_G1 + t2.PLAN_G2 + 
                        t2.PLAN_R1 + t2.PLAN_R2 + t2.PLAN_R3 + t2.PLAN_R4 +
                        NVL(t2.PLAN_F, 0) + NVL(t2.PLAN_F1, 0) + NVL(t2.PLAN_F2, 0) +
                        NVL(t2.PLAN_F3, 0) + NVL(t2.PLAN_F4, 0) + NVL(t2.PLAN_C, 0) +
                        NVL(t2.PLAN_C1, 0) + NVL(t2.PLAN_C2, 0) +
                        NVL(t2.PLAN_C3, 0) + NVL(t2.PLAN_C4, 0) + NVL(t2.PLAN_S, 0) +
                        NVL(t2.PLAN_V, 0) + NVL(t2.PLAN_A, 0) + NVL(t2.PLAN_D, 0) +
                        NVL(t2.PLAN_I, 0) + NVL(t2.PLAN_J, 0) + NVL(t2.PLAN_Z, 0) +
                        NVL(t2.PLAN_P3, 0) + NVL(t2.PLAN_P4, 0) +
                        NVL(t2.PLAN_P5, 0)) oversale,
(t3.remnant_Y + t3.remnant_H + t3.remnant_K + t3.remnant_L +
                       t3.remnant_M + t3.remnant_N + t3.remnant_Q + t3.remnant_T + t3.remnant_X + 
                       t3.remnant_U + t3.remnant_E + t3.remnant_W + t3.remnant_P +
                        t3.remnant_P1 + t3.remnant_P2 + t3.remnant_O +t3.remnant_R1 + t3.remnant_R2 + t3.remnant_R3 + t3.remnant_R4 +
                        NVL(t3.remnant_F, 0) + NVL(t3.remnant_F1, 0) + NVL(t3.remnant_F2, 0) +
                        NVL(t3.remnant_F3, 0) + NVL(t3.remnant_F4, 0) + NVL(t3.remnant_C, 0) +
                        NVL(t3.remnant_C1, 0) + NVL(t3.remnant_C2, 0) +
                        NVL(t3.remnant_C3, 0) + NVL(t3.remnant_C4, 0) + NVL(t3.remnant_S, 0) +
                        NVL(t3.remnant_V, 0) + NVL(t3.remnant_A, 0) + NVL(t3.remnant_D, 0) +
                        NVL(t3.remnant_I, 0) + NVL(t3.remnant_J, 0) + NVL(t3.remnant_Z, 0) +
                        NVL(t3.remnant_P3, 0) + NVL(t3.remnant_P4, 0) +
                        NVL(t3.remnant_P5, 0)) remant,
  least(
decode(t1.money_Y,0,10000000,t1.money_Y),
decode(t1.money_H,0,10000000,t1.money_H),
decode(t1.money_K,0,10000000,t1.money_K),
decode(t1.money_L,0,10000000,t1.money_L),
decode(t1.money_M,0,10000000,t1.money_M),
decode(t1.money_N,0,10000000,t1.money_N),
decode(t1.money_Q,0,10000000,t1.money_Q),
decode(t1.money_T,0,10000000,t1.money_T),
decode(t1.money_X,0,10000000,t1.money_X),
decode(t1.money_U,0,10000000,t1.money_U),
decode(t1.money_E,0,10000000,t1.money_E),
decode(t1.money_W,0,10000000,t1.money_W),
decode(t1.money_P,0,10000000,t1.money_P),
decode(t1.money_P1,0,10000000,t1.money_P1),
decode(t1.money_R1,0,10000000,t1.money_R1),
decode(t1.money_R2,0,10000000,t1.money_R2),
decode(t1.money_R3,0,10000000,t1.money_R3),
decode(t1.money_R4,0,10000000,t1.money_R4),
decode(NVL(t1.money_F 0),0,10000000,NVL(t1.money_F 0)),
decode(NVL(t1.money_F1 0),0,10000000,NVL(t1.money_F1 0)),
decode(NVL(t1.money_F2 0),0,10000000,NVL(t1.money_F2 0)),
decode(NVL(t1.money_F3 0),0,10000000,NVL(t1.money_F3 0)),
decode(NVL(t1.money_F4 0),0,10000000,NVL(t1.money_F4 0)),
decode(NVL(t1.money_C 0),0,10000000,NVL(t1.money_C 0)),
decode(NVL(t1.money_C1 0),0,10000000,NVL(t1.money_C1 0)),
decode(NVL(t1.money_C2 0),0,10000000,NVL(t1.money_C2 0)),
decode(NVL(t1.money_C3 0),0,10000000,NVL(t1.money_C3 0)),
decode(NVL(t1.money_C4 0),0,10000000,NVL(t1.money_C4 0)),
decode(NVL(t1.money_S 0),0,10000000,NVL(t1.money_S 0)),
decode(NVL(t1.money_V 0),0,10000000,NVL(t1.money_V 0)),
decode(NVL(t1.money_A 0),0,10000000,NVL(t1.money_A 0)),
decode(NVL(t1.money_D 0),0,10000000,NVL(t1.money_D 0)),
decode(NVL(t1.money_I 0),0,10000000,NVL(t1.money_I 0)),
decode(NVL(t1.money_J 0),0,10000000,NVL(t1.money_J 0)),
decode(NVL(t1.money_Z 0),0,10000000,NVL(t1.money_Z 0)) ,
 ) minprice
 
