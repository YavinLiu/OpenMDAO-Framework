      SUBROUTINE LDP(G,MG,M,N,H,X,XNORM,W,INDEX,MODE)

C                     T
C     MINIMIZE   1/2 X X    SUBJECT TO   G * X >= H.

C       C.L. LAWSON, R.J. HANSON: 'SOLVING LEAST SQUARES PROBLEMS'
C       PRENTICE HALL, ENGLEWOOD CLIFFS, NEW JERSEY, 1974.

C     PARAMETER DESCRIPTION:

C     G(),MG,M,N   ON ENTRY G() STORES THE M BY N MATRIX OF
C                  LINEAR INEQUALITY CONSTRAINTS. G() HAS FIRST
C                  DIMENSIONING PARAMETER MG
C     H()          ON ENTRY H() STORES THE M VECTOR H REPRESENTING
C                  THE RIGHT SIDE OF THE INEQUALITY SYSTEM

C     REMARK: G(),H() WILL NOT BE CHANGED DURING CALCULATIONS BY LDP

C     X()          ON ENTRY X() NEED NOT BE INITIALIZED.
C                  ON EXIT X() STORES THE SOLUTION VECTOR X IF MODE=1.
C     XNORM        ON EXIT XNORM STORES THE EUCLIDIAN NORM OF THE
C                  SOLUTION VECTOR IF COMPUTATION IS SUCCESSFUL
C     W()          W IS A ONE DIMENSIONAL WORKING SPACE, THE LENGTH
C                  OF WHICH SHOULD BE AT LEAST (M+2)*(N+1) + 2*M
C                  ON EXIT W() STORES THE LAGRANGE MULTIPLIERS
C                  ASSOCIATED WITH THE CONSTRAINTS
C                  AT THE SOLUTION OF PROBLEM LDP
C     INDEX()      INDEX() IS A ONE DIMENSIONAL INTEGER WORKING SPACE
C                  OF LENGTH AT LEAST M
C     MODE         MODE IS A SUCCESS-FAILURE FLAG WITH THE FOLLOWING
C                  MEANINGS:
C          MODE=1: SUCCESSFUL COMPUTATION
C               2: ERROR RETURN BECAUSE OF WRONG DIMENSIONS (N.LE.0)
C               3: ITERATION COUNT EXCEEDED BY NNLS
C               4: INEQUALITY CONSTRAINTS INCOMPATIBLE

      DOUBLE PRECISION G,H,X,XNORM,W,U,V,
     .                 ZERO,ONE,FAC,RNORM,DNRM2,DDOT,DIFF
      INTEGER          INDEX,I,IF,IW,IWDUAL,IY,IZ,J,M,MG,MODE,N,N1
      DIMENSION        G(MG,N),H(M),X(N),W(*),INDEX(M)
      DIFF(U,V)=       U-V
      DATA             ZERO,ONE/0.0D0,1.0D0/

      MODE=2
      IF(N.LE.0)                    GOTO 50

C  STATE DUAL PROBLEM

      MODE=1
      X(1)=ZERO
      CALL DCOPY(N,X(1),0,X,1)
      XNORM=ZERO
      IF(M.EQ.0)                    GOTO 50
      IW=0
      DO 20 J=1,M
          DO 10 I=1,N
              IW=IW+1
   10         W(IW)=G(J,I)
          IW=IW+1
   20     W(IW)=H(J)
      IF=IW+1
      DO 30 I=1,N
          IW=IW+1
   30     W(IW)=ZERO
      W(IW+1)=ONE
      N1=N+1
      IZ=IW+2
      IY=IZ+N1
      IWDUAL=IY+M

C  SOLVE DUAL PROBLEM

      CALL NNLS (W,N1,N1,M,W(IF),W(IY),RNORM,W(IWDUAL),W(IZ),INDEX,MODE)

      IF(MODE.NE.1)                 GOTO 50
      MODE=4
      IF(RNORM.LE.ZERO)             GOTO 50

C  COMPUTE SOLUTION OF PRIMAL PROBLEM

      FAC=ONE-DDOT(M,H,1,W(IY),1)
      IF(DIFF(ONE+FAC,ONE).LE.ZERO) GOTO 50
      MODE=1
      FAC=ONE/FAC
      DO 40 J=1,N
   40     X(J)=FAC*DDOT(M,G(1,J),1,W(IY),1)
      XNORM=DNRM2(N,X,1)

C  COMPUTE LAGRANGE MULTIPLIERS FOR PRIMAL PROBLEM

      W(1)=ZERO
      CALL DCOPY(M,W(1),0,W,1)
      CALL DAXPY(M,FAC,W(IY),1,W,1)

C  END OF SUBROUTINE LDP

   50 END
      