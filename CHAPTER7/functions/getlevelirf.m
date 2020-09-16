function [ out] = getlevelirf( L,LH,N,horizon,shock,Fmat,Qmat,varcoef,A0 )

    LL=max(L,LH);
    hhat=zeros(horizon+LL,N);
    vhat=zeros(horizon+LL,N);
    vhat(LL+1,:)=shock;
    yhat=zeros(horizon+LL,N);
    for m=LL+1:horizon+LL
        hhat(m,:)=hhat(m-1,:)*Fmat(1:N,1:N);
        xhat=[];
        for i=1:L
            xhat=[xhat yhat(m-i,:)];
        end
        xhat=[xhat hhat(m,:)];
        for i=1:LH
            xhat=[xhat hhat(m-i,:)];
        end
        xhat=[xhat 0];
        yhat(m,:)=xhat*varcoef+vhat(m,:)*A0;
    end
    
    out=[yhat(LL+1:end,:) hhat(LL+1:end,:)];
end

