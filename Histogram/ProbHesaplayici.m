clc
for i=1:length(THP)
    for k=1:length(HT)
        if Thp(i)>Ht(k)
            ProbT(i,k) = Thp(i)/Ht(k);
            ProbH(i,k) = 1;
        elseif Ht(k)>Thp(i)
            ProbH(i,k) = Ht(k)/Thp(i);
            ProbT(i,k) = 1;
        elseif Thp(i) == Ht(k)
            ProbH(i,k) = 1;
            ProbT(i,k) = 1;
        else
            disp('There is a problem')
        end
    end
end
for i=1:length(THP)
    for k=1:length(HT)
        if Thp(i)>Ht(k)
            Prob(i,2*k-1) = Thp(i)/Ht(k);
            Prob(i,2*k) = 1;
        elseif Ht(k)>Thp(i)
            Prob(i,2*k) = Ht(k)/Thp(i);
            Prob(i,2*k-1) = 1;
        elseif Thp(i) == Ht(k)
            Prob(i,2*k) = 1;
            Prob(i,2*k-1) = 1;
        else
            disp('There is a problem')
        end
    end
end