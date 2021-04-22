% Practicing Gerchberg-Saxton algorithm for determining phases from
% phase-less, intensity-only "nearfield" and "farfield" images

fileloc = 'matlab-practice';


if ~exist(fileloc, 'dir')
   mkdir(fileloc) 
end

% First, generate our nearfield image using Matlab's built-in peaks
% function: 
P = peaks(20);
X = repmat(P,[5 10]);
%save_imgs(X, [fileloc, '/nf1']);

% Next, take fourier transform to get farfield image.
%save_imgs(abs(fftshift(fft2(X))), [fileloc, '/ff1']);




%Say we only had the intensity of the farfield, and the intensity in nearfield, 
%but we wanted to reconstruct the phases necessary in nearfield to obtain 
%the intensity produced in farfield. 
trg = abs(fft2(X)); %no fftshift (?), target (we got rid of the phases
%save_imgs(abs(fftshift(fft2(X))), [fileloc, '/trg_meas_ff']);

%Set source equal to the "nearfield" peaks pattern multiplied by some 
%arbitrarily chosen phase (since we can't measure the phase)
src = X; 
ts = ones(20,20);

for m=1:4
   ts = [ts; ones(20,20)*exp(i*pi*m/5)]; 
end

for m=1:9
   ts = [ts, ones(100,20)*exp(i*pi*m/5)]; 
end

src = src.*ts; %ts is what we are trying to "guess" from the GS algorithm


% target
trg = abs(fft2(src));
save_imgs(abs(fftshift(fft2(X))), [fileloc, '/trg_meas_ff'], 'abs(farfield)');

% src
src = abs(src);
save_imgs(abs(fftshift(fft2(X))), [fileloc, '/src_meas_nf'], 'abs(nearfield)');


%% Gerchberg-Saxton algorithm, following: 
% https://en.wikipedia.org/wiki/Gerchberg%E2%80%93Saxton_algorithm
A = ifft2(trg);


for k=1:2%10
    B = abs(src).*exp(i*angle(A));
    save_imgs(B, [fileloc, '/B_iter', num2str(k)], ['B iter. ', num2str(k)]);
    C = fft2(B);
    save_imgs(C, [fileloc, '/C_iter', num2str(k)],['C iter.', num2str(k)]);
    D = abs(trg).*exp(i*angle(C));
    save_imgs(D, [fileloc, '/D_iter', num2str(k)],['D iter.', num2str(k)]);
    A = ifft2(D);
    save_imgs(A, [fileloc, '/A_iter', num2str(k)],['A iter.', num2str(k)]);
    
end




function [] = save_imgs(data, savepath, ttl)
    hdl = figure;
    imagesc(abs(data)/max(max(abs(data))));
    title(ttl);
    saveas(hdl, [savepath, '.png']);
    save([savepath, '.mat'], 'data');
    close(hdl);
end


