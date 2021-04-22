# Simple MATLAB implementation of Gerchberg-Saxton Algorithm

The Gerchberg-Saxton algorithm is an iterative phase-finding algorithm that can be used to find complex phases when one only has access to the amplitudes of an image and its Fourier transform. Specifically, it can find the complex phases to apply to an image ("nearfield") in order to generate a given desired pattern when the image is Fourier transformed ("farfield"), despite beginning with no initial phase knowledge. 


## Usage
This simple implementation creates a "nearfield" image using MATLAB's "peaks" function and multiplying by periodic complex phase,

![]


finds the associated "farfield", or Fourier-tranformed image,

![]

then loops over the Gerchberg-Saxton algorithm 