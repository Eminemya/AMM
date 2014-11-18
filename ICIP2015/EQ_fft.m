%Example Input with verification
%{
[Song, Fs, nBits] = wavread('Sample.wav');
struct_PSD.Frequency = [0,300,500,1200,2500, 5000, 12e3];
%struct_PSD.Power = [0,-3,-3,-6,-6, -3, -6];

for i =1:numel(struct_PSD.Power)
struct_PSD.Power = [-30,-30,-30,-30,-30, -30, -30];
struct_PSD.Power(i)= 30;
Signal = EQ_fft(Song(:,1)', Fs, struct_PSD);
%figure(2);periodogram(Signal);
%figure(1);periodogram(Song(:,1));
wavwrite(Signal, Fs,nBits,['Out_' num2str(i) '.wav']);
end
%}


%---------------------------------------------
%Grant Lohsen - v1.0 2012-11-20
%Georgia Tech Research Institute
%Spectral Shaping of signals
%---------------------------------------------
function [Signal] = EQ_fft(Signal, SampleFrequency, struct_PSD)
    %fEqualizer
    % Applies a PSD (Power Spectral Density) To a signal
    %
    % Inputs :
    %   .Signal
    %   .SampleFrequency
    %   .struct_PSD - Power spectral density structure
    %       .Frequency(Hz) Discrete frequency points for the PSD
    %       .Power (dB) :Discrete Power points at each frequency
    % Outputs:
    %   .Signal - Input Signal with the given PSD mapped to it
    %
    % Function Called:
    %   fft
    %   ifft
    %
    % Description:
    %   map signal to a specific power Spectral Density over a
    %   Due to memory constraints, the signal length should be less than 100e3 samples;
 
    %timekeeping records
    tic();
    
    Raw_Signal = Signal;
    Fs = SampleFrequency;
    if any(struct_PSD.Frequency>(Fs/2))
        error('You must specify PSD frequencies below Fs/2');
    end
    L = numel(Raw_Signal); %determine the signal length we are working with
    NFFT = L + (1-rem(L,2)); %Set the number of FFT samples. If signal is even length it must be padded with one.
 
    Index =floor(L/Fs * struct_PSD.Frequency(:)')+1; %map the frequency listed to the index of the FFT
    
    Power = struct_PSD.Power(:)';
    
    if Index(1) ~= 1
        Index = [1,Index];
        Power = [-160,Power];
        disp('Warning:fEqualizer not provided with the DC point; putting it at -160dBm')
    end
    
    %map the indicies of the FFT to the proper Frequency
    if Index(end) ~= floor(L/2 + 1 );
        %if for some reason we have rounded above the final point, let us downcorrect this
        if Index(end) > floor(L/2 +1)
            Index(end) = floor(L/2+1);
        else
        %if we have simply not included the last point, include it    
            Index = [Index, floor(L/2 +1)];
            Power = [Power,-160];
            disp('Warning: fEqualizer not provided with the Fs/2 hz point; putting it at -160dBm')
        end
    end

    PSD = zeros(1, Index(end));
    
    %map the power spectral density to the indicies of hte frequencies as shown by the FFT
    for i = 1:(length(Index)-1)
        if (Index (i+1) ~= Index(i))
            PSD((Index(i)):(Index(i+1))) = linspace(Power(i), Power(i+1), Index(i+1)-Index(i)+1);
        end
    end
    
    %Apply a fast fourier transform to the signal
    Raw_FFT = (fft(Raw_Signal,NFFT)/L);
        
    %trim signal of padding zeros
    FFT_Trimed = reshape(Raw_FFT,1,[]);
   
    %Unwrap PSD i.e. map to the same frequencies FFT creates. i.e. 0-fmax, fmax-(frequency right before 0)
    PSD_Unwrapped = [PSD, PSD(end:-1:2)];
    
    %apply psd to the signal
    PSD_FrequencyDomain = FFT_Trimed.*10.^(PSD_Unwrapped./20);
    
    %Return signal to time domain
    PSD_Signal = ifft(PSD_FrequencyDomain).*L;
    
    %Trim signal
    Signal = PSD_Signal(1:L);
    toc()
  
end
