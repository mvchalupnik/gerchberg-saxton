% Practicing Gerchberg-Saxton algorithm for determining phases from
% phase-less, intensity-only "nearfield" or source and "farfield" or target images

fileloc = 'gs-practice3';

if ~exist(fileloc, 'dir')
   mkdir(fileloc) 
end

save_iteration_imgs = false;

% First, generate our nearfield image using Matlab's built-in peaks
% function. Also, multiply by some complex phases ts
P = peaks(20);
src = repmat(P,[5 10]);
ts = ones(20,20);

for m=1:4
   ts = [ts; ones(20,20)*exp(i*pi*m/5.)]; 
end

for m=1:9
   ts = [ts, ones(100,20)*exp(i*pi*m/5.)]; 
end

%ts (complex phases) are what we are trying to retrieve from the GS algorithm
src = src.*ts; 


%Say we only had the intensity of the farfield, and the intensity in nearfield, 
%but we wanted to reconstruct the phases necessary in nearfield to obtain 
%the intensity produced in farfield. 

% Save the amplitude of the target
trg_abs = abs(fft2(src));
trg_abs = abs(trg_abs)/max(max(abs(trg_abs)));
save_imgs(trg_abs, [fileloc, '/trg_abs_ff'], 'Abs(target)');

%Save phase map of source, to compare at the end
save_imgs(angle(src), [fileloc, '/src_angle'], 'Arg(source)', 'jet')

% Save amplitude of src
src_abs = abs(src)/max(max(abs(src)));
save_imgs(src_abs, [fileloc, '/src_abs_nf'], 'Abs(source)');


%% Gerchberg-Saxton algorithm, following: 
% https://en.wikipedia.org/wiki/Gerchberg%E2%80%93Saxton_algorithm

%Start by taking the inverse FT of our phase-less target image
A = ifft2(trg_abs);
save_imgs(A, [fileloc, '/A_iter', num2str(1)],['A iter. ', num2str(1)]);

%Save phase map at step 1
save_imgs(angle(A), [fileloc, '/src_angle_1'], ...
    ['Arg(nearfield) iter. ', num2str(1)], 'jet');

prev_abs = abs(A)+100;
k = 1;
while sum(sum(abs(abs(A) - prev_abs))) > 1e-7
    prev_abs = abs(A);
    
    B = abs(src_abs).*exp(i*angle(A));

    C = fft2(B);
        
    D = abs(trg_abs).*exp(i*angle(C));
    
    A = ifft2(D);
    
    if save_iteration_imgs
        save_imgs(B, [fileloc, '/B_iter', num2str(k)], ['B iter. ', num2str(k)]);
        save_imgs(C, [fileloc, '/C_iter', num2str(k)],['C iter. ', num2str(k)]);
        save_imgs(D, [fileloc, '/D_iter', num2str(k)],['D iter. ', num2str(k)]);
        save_imgs(A, [fileloc, '/A_iter', num2str(k+1)],['A iter. ', num2str(k+1)]);
        
        %Save phase map at step k
        save_imgs(angle(A), [fileloc, '/src_angle_', num2str(k+1)],...
            ['Arg(A) (Radians) iter. ', num2str(k+1)], 'jet');
    end
    

    k=k+1;
end

%Save C at step k
save_imgs(C, [fileloc, '/C_iter', num2str(k-1)],['C iter. ', num2str(k-1)]);

%save A at step k
save_imgs(A, [fileloc, '/A_iter', num2str(k)],['A iter. ', num2str(k)]);

%Save phase map at step k
save_imgs(angle(A), [fileloc, '/src_angle_', num2str(k)],...
    ['Arg(A) (Radians) iter. ', num2str(k)], 'jet');



function [] = save_imgs(data, savepath, ttl, cmap)
    hdl = figure;
    hold on;
    
    if nargin > 3
        colormap(hdl, cmap);
        c = colorbar;
        c.FontSize = 20;
        imagesc(data);
        c.XLim = [-pi, pi];
        c.YLim = [-pi, pi];
    else
         imagesc(abs(data)/max(max(abs(data))));
    end
     
    ax = gca;
    ax.Visible = 'off';
    ax.Title.Visible = 'on';
    ax.XLim = [0,size(data,2)];
    ax.YLim = [0,size(data,1)];
    title(ttl, 'FontSize', 24);
    xticks([]);
    yticks([]);

    
    hold off; 
    
    saveas(hdl, [savepath, '.png']);
    save([savepath, '.mat'], 'data');
    close(hdl);
end


