function [out_2d,c_argmax,d_argmax]=cor_arg(y_sur,y_ref,t)

    c=0:6;
    d=-40:2:40;

    c_out=repmat(c,1,41)';
    d_out=repmat(d,1,7)';

    num_loop = length(c)*length(d);

    y_ref_conj=conj(y_ref);
    
    out=zeros(num_loop,1);
    counter=0;
    max_out=0;

    for c_i=c
        c_zero=zeros(1,c_i);
        for d_i=d
            y_sur_zero=[c_zero y_sur]; 
            y_ref_conj_zero=[y_ref_conj c_zero];
            exp_125=exp((t:(0.5/12500000):t+0.5-(0.5/12500000))*(-1i*2*pi*d_i));

            exp_125_zero=[exp_125 c_zero];
            counter=counter+1
            out(counter)=sum(y_sur_zero.*y_ref_conj_zero.*exp_125_zero);
            if abs(out(counter))>max_out
                c_argmax=c_i;
                d_argmax=d_i;
                max_out=abs(out(counter));
            end
        end
    end

    out=[out c_out d_out];

    out_2d = zeros(7,41);
for j = 1:7
    for k = 1:41
        out_2d(j,k) = out (41*j+k);
    end
end
end

