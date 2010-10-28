      SUBROUTINE BODY(LNOSE,LAB,LBODY,BDMAX,X,D)

C   ROUTINE TO COMPUTE D VS. X FOR A NOSE-CYLINDER-AFTERBODY FUSELAGE
C     THERE ARE 21 POINTS ON THE NOSE; 9 ON THE CYLINDRICAL SECTION
C     (IF ANY); AND 21 ON THE AFTERBODY (IF ANY)
C   INPUT VARIABLES:
C     LNOSE    LENGTH OF THE NOSE
C     LAB      LENGTH OF THE AFTERBODY
C     LBODY    LENGTH OF THE BODY
C     BDMAX    DIAMETER OF THE CYLINDER
C                  
C   OUTPUT VARIABLES:
C     X        FUSELAGE STATIONS
C     D        CORRESPONDING DIAMETERS
C     R        CORRESPONDING RADIUS
C     NFSECT   NUMBER OF POINTS DEFINING BODY
C     NTAIL    INDEX OF FIRST POINT ON AFTERBODY
                   
      DIMENSION X(51),D(51),R(51)
      REAL LNOSE,LAB,LBODY,LCYL
      INTEGER OUTCOD
      LOGICAL DEBUG
                   
C   COMPUTE THE POINTS THAT DEFINE THE NOSE.
      DO 10 I=1,21
      XOVERL=.025*FLOAT(I-1)
      T2=XOVERL*(1.-XOVERL)
      X(I)=2.*LNOSE*XOVERL
      D(I)=BDMAX*SQRT(8.0*SQRT(T2*T2*T2))
10    R(I)=D(I)/2.
      NFSECT=21    
      NTAIL=21     
                   
C   COMPUTE THE POINTS THAT DEFINE THE CYLINDER.
      LCYL=LBODY-LNOSE-LAB
      IF(LCYL.LT..01*LBODY) GO TO 30
      DO 20 I=21,31
      X(I)=LNOSE+0.1*LCYL*FLOAT(I-21)
      D(I)=BDMAX
20    R(I)=D(I)/2. 
      NFSECT=31    
      NTAIL=31     
                   
C   COMPUTE THE POINTS THAT DEFINE THE AFTERBODY.
30    NFSECT=NFSECT+20
      DO 40 I=NTAIL,NFSECT
      XOVERL=.025*FLOAT(51-I)
      T2=XOVERL*(1.-XOVERL)
      X(I)=LBODY-2.*LAB*XOVERL

      D(I)=BDMAX*SQRT(8.0*SQRT(T2*T2*T2))
C      IF (ITAIL.NE.1) THEN
C        IF(X(I).GT.(LBODY-LAB)) D(I)=D(I)+.6*DIA1*(X(I)-LBODY+LAB)/LAB
C      ENDIF
      R(I)=D(I)/2. 
40    CONTINUE
                   
      END