function out=cor(y_sur,y_ref,t)
%     c=0:5;
% d=-40:2:40;
    y_ref_conj=conj(y_ref);
    out=zeros(6,41);
    for c_i=1:6
        c_zero=zeros(1,c_i);
        %c_i
        for d_i=1:41
            y_sur_zero=[c_zero y_sur]; 
            y_ref_conj_zero=[y_ref_conj c_zero];
            exp_125=exp((t:(0.5/12500000):t+0.5-(0.5/12500000))*(-1i*2*pi*d_i));
            exp_125_zero=[exp_125 c_zero];
            out(c_i,d_i)=sum(y_sur_zero.*y_ref_conj_zero.*exp_125_zero);
        end
    end
end