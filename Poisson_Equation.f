c       Marta Xiulan Aribó Herrera
c       Pràctica de l'equació de Poisson amb els mètode de Jacobi, Gauss-Seidel 
c       i sobrerelaxació
c       Estudiem la convergència per diferentes temperatures inicials
c       i obtenim un mapa de temperatures amb i sene fonts.


c-----------------------------------------------------------------------
        PROGRAM prac        
C--------------------------DECLARACIÓ DE VARIABLES-----------------------
        implicit none
        integer icontrol,i,j,c,kmax,k
        double precision ro,Lx,Ly,h,w,eps, no_ro
        external ro,no_ro
        parameter(Lx=44.5d0,Ly =32.5d0,h = 0.5d0,w=1.55d0)
        integer Nx,Ny
        parameter (Nx = int(Lx/h))
        parameter (Ny = int(Ly/h))
        double precision tnew(0:Nx,0:Ny),told(0:Nx,0:Ny),
     *error(0:Nx,0:Ny),told_error(0:Nx,0:Ny)
        double precision temperatura(3)
        temperatura = (/15.d0,220.d0,1280.d0/) !ºC
        eps = 0.00000001d0
        open (1,file="check1.dat") !per 15 ºC
        open (2,file="check2.dat") !per 220 ºC
        open (3,file="check3.dat") !per 1280 ºC
        open (4,file="check4.dat") !mapa de temperatures amb fonts
        open (5,file="check5.dat") !mapa de temperatures sense fonts
C------------------------COS DEL PROGRAMA PRINCIPAL---------------------

        !condicions de contorn que no varien en cap moment
        do i = 0, Nx !recorrem x
            told(i,0) = 17.d0 !eix x inferior ___
            told(i,Ny) = 25.3d0   !eix x superior  --- 
        enddo

        do j = 0,Ny
            told(0,j) = 0.5d0 !eix j a l'origen |...
            told(Nx,j) = 11.2d0 !eix j a l'extrem ...|
        enddo

c*****************************
        !Mètode de JACOBI
        icontrol = 3
        eps = 0.0000001d0
c*****************************
        write(1,*)"#Mètode Jacobi"

        DO C= 1, 3!---------------
        do i = 1, Nx-1 !punts interiors
        do j = 1, Ny-1
            told(i,j) = temperatura(c) !condicions de contorn que inicialitzem de forma arbitraria
        enddo
        enddo 
        write(1,*)"#Temperatura inicial", temperatura(C)

        tnew=told !inicialitzem les matrius 
        do k= 1, kmax!-------bucle 1
            told_error = tnew !guardem la matriu abans d'aplicar el mètode i comparar 
            call metodes(icontrol,Nx,Ny,told,tnew,h,ro,w) 
            error = abs(told_error-tnew) !comparació de l'iteració anterior

            if (mod(k,5).EQ.0) then
                write(1,*) k, tnew(nint(25.5/h),nint(13.5/h)) !escriptura de dades
            endif

            if (maxval(error).LE.eps) then !el valor màxim de la matriu error ha de ser més petit que una tolerància eps
                print*,"s'ha arribat a la convergencia desitjada",
     *          maxval(error)
                exit
            endif
            told = tnew 
            
            if (k.EQ.kmax) then
                print*, "S'ha arribat al nombre màxim d'iteracions"
            endif

        enddo!-------bucle 1
            write(1,"(a1)")
            write(1,"(a1)")
        ENDDO!-------------------
c*****************************
        !Mètode de gauss seidel
        icontrol = 1
        eps = 0.0000001d0
c*****************************

        write(2,*)"#Mètode Gauss-Seidel"

        DO C= 1, 3!---------------
        do i = 1, Nx-1 !punts interiors
        do j = 1, Ny-1
            told(i,j) = temperatura(c) !condicions de contorn que inicialitzem de forma arbitraria
        enddo
        enddo 
        write(2,*)"#Temperatura inicial", temperatura(C)

        tnew=told !inicialitzem les matrius 
        do k= 1, kmax!-------bucle 1
            told_error = tnew
            call metodes(icontrol,Nx,Ny,told,tnew,h,ro,w) 
            error = abs(told_error-tnew)

            if (mod(k,5).EQ.0) then
                write(2,*) k, tnew(nint(25.5/h),nint(13.5/h))
            endif

            if (maxval(error).LE.eps) then
                print*,"s'ha arribat a la convergencia desitjada",
     *          maxval(error)
                exit
            endif
            told = tnew !no cal, però per no perdre generalització
            
            if (k.EQ.kmax) then
                print*, "S'ha arribat al nombre màxim d'iteracions"
            endif

        enddo!-------bucle 1
            write(2,"(a1)")
            write(2,"(a1)")
        ENDDO!-------------------

c*****************************
        !Mètode de sobrerelaxació
        icontrol = 2
        eps = 0.0000001d0
c*****************************
        write(3,*)"#Sobrerelaxació"

        DO C= 1, 3!---------------
        do i = 1, Nx-1 !punts interiors
        do j = 1, Ny-1
            told(i,j) = temperatura(c) !condicions de contorn que inicialitzem de forma arbitraria
        enddo
        enddo 
        write(3,*)"#Temperatura inicial", temperatura(C)

        tnew=told !inicialitzem les matrius 
        do k= 1, kmax!-------bucle 1
            told_error = tnew
            call metodes(icontrol,Nx,Ny,told,tnew,h,ro,w) 
            error = abs(told_error-tnew)

            if (mod(k,5).EQ.0) then
                write(3,*) k, tnew(nint(25.5/h),nint(13.5/h))
            endif

            if (maxval(error).LE.eps) then
                print*,"s'ha arribat a la convergencia desitjada",
     *          maxval(error)
                exit
            endif
            told = tnew
            
            if (k.EQ.kmax) then
                print*, "S'ha arribat al nombre màxim d'iteracions"
            endif

        enddo!-------bucle 1
            write(3,"(a1)")
            write(3,"(a1)")
        ENDDO
c------------------- Matriu pel cas de l'existència de fonts --------------------

        write(4,*)"#Resultats amb fonts"
        do i = 0,Nx !escriptura de resultats del últim mètode per la gràfica amb fonts
        do j = 0,Ny ! amb el mètode de sobrerelaxació
            write(4,*) i*h,j*h, tnew(i,j)
        enddo 
            write(4,"(a1)")
        enddo 

c-------------------- Matriu pel cas de no existir fonts --------------------        
        do i = 1, Nx-1 !punts interiors
        do j = 1, Ny-1
            told(i,j) = 15.d0 !condicions de contorn que inicialitzem de forma arbitraria
        enddo
        enddo 
        write(5,*)"#Resultats sense fonts", 15.d0

        tnew=told !inicialitzem les matrius 
        icontrol = 2 !utilitzem el mètode de sobrerelaxació perquè convergeix més ràpidament
        do k= 1, kmax!-------bucle 1
            told_error = tnew
            call metodes(icontrol,Nx,Ny,told,tnew,h,no_ro,w) 
            error = abs(told_error-tnew)

            if (maxval(error).LE.eps) then
                print*,"s'ha arribat a la convergencia desitjada",
     *          maxval(error)
                exit
            endif
            told = tnew
            
            if (k.EQ.kmax) then
                print*, "S'ha arribat al nombre màxim d'iteracions"
            endif

        enddo!-------bucle 1

        do i = 0,Nx !escriptura de resultats del últim mètode per la gràfica amb fonts
        do j = 0,Ny
            write(5,*) i*h,j*h, tnew(i,j)
        enddo 
            write(5,"(a1)")
        enddo 


        call system ("gnuplot -p plot1.gnu") !gràfica de 15ºC
        call system ("gnuplot -p plot2.gnu") !gràfica de 220ºC
        call system ("gnuplot -p plot3.gnu") !gràfica de 1280ºC
        call system ("gnuplot -p plot4.gnu") !gràfica amb fonts
        call system ("gnuplot -p plot5.gnu") !gràfica sense fonts


        END PROGRAM 
C---------------------------SUBRUTINES I FUNCIONS-----------------------
        
C--------------------- SUBRUTINA AMB ELS MÈTODES -----------------------
c       Subrutina amb els mètodes de Gauss-Seidel, sobrerelaxació i jacobi
c       El seu ús controla amb una variable icontrol que determina quin 
c       ha de ser el mètode a utilitzar

C-----------------------------------------------------------------------
        subroutine metodes(icontrol,Nx,Ny,told,tnew,h,fun,w)
        implicit none
        integer i,j,c,icontrol
        double precision Lx,Ly,h,w,fun,eps !longituds i pas
        external fun
        integer Nx,Ny, kmax,k
        double precision tnew(0:Nx,0:Ny),told(0:Nx,0:Ny)


        do i = 1, Nx-1
        do j = 1, Ny-1
        !    
        if (icontrol.EQ.1) then !Gauss-Seidel
            tnew(i,j) = (tnew(i+1,j)+tnew(i-1,j)+tnew(i,j+1)+tnew(i,j-1)
     *                 +(h**2.d0*fun(i*h,j*h,h)))/4.d0
        endif 
        if (icontrol.EQ.2) then!Sobrerelaxació
            tnew(i,j) = told(i,j) + 
     *                w*(told(i+1,j)+tnew(i-1,j)+told(i,j+1)+tnew(i,j-1)
     *                - 4.d0*told(i,j)+(h**2.d0)*fun(i*h,j*h,h))/4.d0
        endif

        if (icontrol.EQ.3) then !Jacobi
            tnew(i,j) = (told(i+1,j)+told(i-1,j)+told(i,j+1)+told(i,j-1)
     *+(h**2.d0*fun(i*h,j*h,h)))/4.d0
        endif
        !
        enddo
        enddo 

        end subroutine 

C----------------------------- DENSITAT RO -----------------------------
c       Funció amb la densitat(x,y) segons els punts
C-----------------------------------------------------------------------

        double precision function ro(x,y,h)
        implicit none
        double precision h, ro1,ro2, r10,r,arrel,x, y,ro3,r30
        r30 = 5.5d0
        r10 =10.d0 !ºC/cm
        ro2 = 7.d0
        ro = 0.d0
        arrel = (x-22.5d0)**2+(y-8.d0)**2
        !primera ro
        if (arrel.LT.0) then
                print*, "Arrel negativa, ojo"
        else
                r = sqrt(arrel)
                ro1 = r10*exp(-((r-4.d0)/0.7d0)**2.d0)
                ro = ro+ ro1
        endif 
        !segona ro

        arrel = (x-10.5)**2.d0 + (y-22.d0)**2.d0

        if (arrel.LT.0) then
                print*, "Arrel negativa, ojo"
        else
                r = sqrt(arrel)
                ro3 = r30*exp(-((r-5.d0)/1.2d0)**2.d0)
                ro = ro+ ro3
        endif     
        !tercera ro

        if (((nint(x).GE.29).AND.(nint(x).LE.35)).AND.((nint(y).GE.18)
     *.AND.(nint(y).LE.22))) then
            ro = ro + ro2
        endif

        end function 
c------------------------------sense densitat--------------------------
c       Si no hi han fonts passem una funció que bàsicament equival a 0
c-------------------------------------------------------------------------
        double precision function no_ro(x,y)
        implicit none
        double precision x, y

            no_ro = 0.d0

        return
        end function



