function [ out] = get_irfTVAR4VOLNOTRENDSTAR(N, HORZ, T, L,LH, Y0,hlast0, beta1, Sbig1,iamat1,beta2,tar,tvar,delay,muvol,fvol,qvol,reps,scale,nml,EX,gam)



% Draw N(0,1) innovations for variance  equation:
Cq=sqrt(qvol);
bb1=reshape(beta1,N*L+EX,N);
bb2=reshape(beta2,N*L+EX,N);
% Note we only need HORZ*N innovations, but adding an extra L draws makes 
% the indexing in the loop below a bit cleaner.
yy1=0;yy=0;
hh=0;
hh1=0;
for ii=1:reps
%compute forecast
yhat=zeros(HORZ+L,N);
yhat(1:L,:)=Y0;
hhat=zeros(HORZ+L,1);
hhat(L-LH+1:L,:)=log(hlast0);
hhat1=hhat;
yhat1=yhat;

ystar=zeros(HORZ+L,1);


ystar1=ystar;

for fi=L+1:HORZ+L
    
    
    
    
  
    ystar(fi,:)=yhat(fi-delay,tvar);
    
    ystar1(fi,:)=yhat1(fi-delay,tvar);
    

    
    
    %simulate data
    if fi==L+1
        hhat(fi,:)=muvol+hhat(fi-1,:)*fvol;
        
        %
        hhat1(fi,:)=muvol+hhat1(fi-1,:)*fvol+(scale*Cq);
        
        xhat=[];
    xhat1=[];
   
    for ji=1:L
        xhat=[xhat yhat(fi-ji,:)];
        xhat1=[xhat1 yhat1(fi-ji,:)];
        
    end
   
    for ji=0:LH
        xhat=[xhat hhat(fi-ji,:)];
        xhat1=[xhat1 hhat1(fi-ji,:)];
        
    end
    
   xhat=[xhat 1 ];
    
    xhat1=[xhat1 1 ];
   
        
       %build covariance matrix
    sigma1=iamat1*diag(Sbig1.*exp(hhat(fi,1)))*iamat1';
    csigma1=cholx(sigma1);
  
    sigmaS1=iamat1*diag(Sbig1.*exp(hhat1(fi,1)))*iamat1';
    
    csigmaS1=cholx(sigmaS1);
  
        
    uu1=zeros(1,N);
           
    e2=1./(1+exp(-gam.*(ystar(fi,:)-tar)));
    
    yhat(fi,:) = (xhat*bb1)+((xhat*bb2)*e2)+uu1*csigma1;
    
     
    
    %y1
    uu1=zeros(1,N);
           
    e2=1./(1+exp(-gam.*(ystar1(fi,:)-tar)));
    
    yhat1(fi,:) = (xhat1*bb1)+((xhat1*bb2)*e2)+uu1*csigmaS1;
   
    
  
    
    
    
    else
        
     hhat(fi,:)=muvol+hhat(fi-1,:)*fvol+randn(1,1)*Cq;
        
        %
        hhat1(fi,:)=muvol+hhat1(fi-1,:)*fvol+randn(1,1)*Cq;
        xhat=[];
    xhat1=[];
   
    for ji=1:L
        xhat=[xhat yhat(fi-ji,:)];
        xhat1=[xhat1 yhat1(fi-ji,:)];
        
    end
    
    for ji=0:LH
        xhat=[xhat hhat(fi-ji,:)];
        xhat1=[xhat1 hhat1(fi-ji,:)];
        
    end
    
    xhat=[xhat 1 ];
    
    xhat1=[xhat1 1 ];
        
       %build covariance matrix
    sigma1=iamat1*diag(Sbig1.*exp(hhat(fi,1)))*iamat1';
    
    csigma1=cholx(sigma1);
    
    
    sigmaS1=iamat1*diag(Sbig1.*exp(hhat1(fi,1)))*iamat1';
    
    csigmaS1=cholx(sigmaS1);
       
        
        
        uu1=randn(1,N);
           
    e2=1./(1+exp(-gam.*(ystar(fi,:)-tar)));
    
    yhat(fi,:) = (xhat*bb1)+((xhat*bb2)*e2)+uu1*csigma1;
    
     
    %
   uu1=randn(1,N);
           
    e2=1./(1+exp(-gam.*(ystar1(fi,:)-tar)));
    
    yhat1(fi,:) = (xhat1*bb1)+((xhat1*bb2)*e2)+uu1*csigmaS1;
    
    
    
    end
   
end

yy=yy+yhat;
yy1=yy1+yhat1;
hh=hh+hhat;
hh1=hh1+hhat1;
   

end

yy=yy/reps;
yy1=yy1/reps;
hh=hh/reps;
hh1=hh1/reps;



ir1=yy1-yy;
hir1=hh1-hh;

 
 ir1=ir1(L+1:end,:);
 hir1=hir1(L+1:end,:);
 out=[ir1 hir1];
 
