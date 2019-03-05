module nelder_mead_module

    contains
        ! x is an n x (n+1) array of simplices
        ! f is an array of function values
        ! func is the function
        function nelder_mead(func, x, f, dl) result(xmax)
            implicit none
            double precision, dimension(:) :: f
            double precision, dimension(:,:) :: x
            double precision :: dl
            interface 
                function func(x)
                    implicit none
                    double precision, intent(in), dimension(:) :: x
                    double precision :: func
                end function 
            end interface
            double precision, parameter :: alpha = 1   ! alpha > 0
            double precision, parameter :: gamma = 2   ! gamma > 1
            double precision, parameter :: rho   = 0.5 ! 0 < rho < 0.5
            double precision, parameter :: sigma = 0.5 ! 0 < sigma < 1

            integer :: n, j
            integer, dimension(size(f)) :: i
            double precision, dimension(size(f)-1) :: xo, xr, xe, xc, xmax
            double precision :: fr, fe, fc

            n = size(f)-1
            do while (.true.)
                ! 1) Sort
                i = sort_doubles(f)
                if (f(i(n+1)) - f(i(1)) < dl) exit

                ! 2) Centroid
                xo = sum(x(:,i(2:)),dim=2)/n

                ! 3) Reflection
                xr = xo + alpha * (xo-x(:,i(1)))
                fr = func(xr)

                if (fr <= f(i(n+1))  .and. f(i(2))  < fr) then
                    f(i(1)) = fr
                    x(:,i(1)) = xr

                !4) Expansion
                else if (fr > f(i(n+1))) then
                    xe = xo + gamma * (xr - xo)
                    fe = func(xe)
                    if (fe > fr) then
                        write(*,*) fe, fe-f(i(1))
                        f(i(1)) = fe
                        x(:,i(1)) = xe
                    else
                        write(*,*) fr, fr-f(i(1))
                        f(i(1)) = fr
                        x(:,i(1)) = xr
                    end if
                else
                ! 5) Contraction
                    xc = xo + rho * (x(:,i(1)) - xo)
                    fc = func(xc)
                    if (fc > f(i(1))) then
                        f(i(1)) = fc
                        x(:,i(1)) = xc
                    else
                        ! 6) Shrink
                        do j=1,n
                            x(:,i(j)) = x(:,i(n+1)) + sigma* (x(:,i(j)) - x(:,i(n+1)))
                            f(i(j)) = func(x(:,i(j)))
                        end do
                    end if
                end if
            end do
            xmax = x(:,i(n+1))

        end function nelder_mead



    !> Return the sorted indices of an array of doubles
    !!
    function sort_doubles(a) result(k)
        implicit none
        double precision,intent(in), dimension(:) :: a
        double precision, dimension(size(a)) :: b
        integer, dimension(size(a)) :: i
        integer, dimension(size(a)) :: k

        integer :: j

        b = a
        i = [ (j,j=1,size(a)) ]

        call quicksort(b,i)

        k=i
        !do j=1,size(a)
            !k(i(j)) = j
        !end do

    end function sort_doubles

    recursive subroutine quicksort(A,Ai)
        implicit none
        double precision, intent(inout), dimension(:) :: A
        integer, intent(inout), dimension(:) :: Ai
        integer :: iq

        if(size(A) > 1) then
            call Partition(A,Ai,iq)
            call quicksort(A(:iq-1),Ai(:iq-1))
            call quicksort(A(iq:),Ai(iq:))
        endif
    end subroutine quicksort

    subroutine Partition(A,Ai,marker)
        implicit none
        double precision, intent(inout), dimension(:) :: A
        integer, intent(inout), dimension(:) :: Ai
        integer, intent(out) :: marker
        integer :: i, j
        double precision :: temp
        integer :: tempi
        double precision :: x      ! pivot point
        x = A(1)
        i= 0
        j= size(A) + 1

        do
            j = j-1
            do
                if (A(j) <= x) exit
                j = j-1
            end do
            i = i+1
            do
                if (A(i) >= x) exit
                i = i+1
            end do
            if (i < j) then
                ! exchange A(i) and A(j)
                temp = A(i)
                A(i) = A(j)
                A(j) = temp
                tempi = Ai(i)
                Ai(i) = Ai(j)
                Ai(j) = tempi

            elseif (i == j) then
                marker = i+1
                return
            else
                marker = i
                return
            endif
        end do

    end subroutine Partition


end module nelder_mead_module
