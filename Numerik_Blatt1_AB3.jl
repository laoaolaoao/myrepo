function LRdecomposition(A)
    n = size(A,1)
    B = zeros(Rational{Int}, n, n)

    for j in 1:n-1
        for i in j+1:n
            if A[i,j] != 0
                B[i,j] = (A[i,j]//A[j,j])
                A[i,:] = A[i,:]-B[i,j]*A[j,:]
            end
        end
    end

    for i1 in 1:n
        B[i1,i1]=1
    end

    return B,A
end

function vorSub(L,b)
    n = length(b) #man darf kein size(b) verwenden, da sonst ein Tupel als ergebnis kommt
    y = zeros(Rational{Int}, n)
    
    for i in 1:n
        y[i] = b[i]

        for j in 1:i-1
            y[i] = y[i]-y[j]*L[i,j]
        end
        y[i] = y[i]//L[i,i]
    end

    return y
end

function rueckSub(R,y)
    n = length(y)
    x = zeros(Rational{Int}, n)
    i = n

    while i > 0
        x[i] = y[i]
        j = n

        while j > i
            x[i] = x[i]-x[j]*R[i,j]
            j = j-1
        end

        x[i] = x[i]//R[i,i]
        i = i-1
    end

    return x
end

function rueckSubalt(R,y) #Ein Alternative mithilfe von der Definition von vorSub
    A = R[end:-1:1,end:-1:1] #man folgt dem Schema Start:Schritt:Schluss. Also kehrt man hier sowohl die Spalten als auch die Zeilen von R um
    y1 = y[end:-1:1]
    x1 = vorSub(A,y1) # Also kann man hier wieder vorSub verwenden
    x = x1[end:-1:1]

    return x
end

A = [2 -3 1;-4 7 1;6 -7 13]
b = [5,3,57]
L,R = LRdecomposition(A)
y = vorSub(L,b)
(rueckSub(R,y))
print(rueckSubalt(R,y))