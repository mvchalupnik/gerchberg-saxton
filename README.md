# Simple MATLAB implementation of Gerchberg-Saxton Algorithm

The Gerchberg-Saxton algorithm is an iterative phase-finding algorithm that can be used to find complex phases when one only has access to the amplitudes of an image and the amplitude of its Fourier transform. Specifically, the algorithm can find the complex phases to apply to the amplitude of a source image in order to generate a given desired target pattern when the image is Fourier transformed, despite beginning with no initial phase knowledge. One application for this is recovering phase information from a nearfield image (source) given images taken in the nearfield (source) and farfield (target). 

Due to redundancies in the way phase can be applied to a source image produce a given target image, the phase map produced by the algorithm will not necessarily be the phase map of the original source image; however it will be a phase map that, when applied to the source image, approximates the correct target image, such that the Fourier transform of that target image matches the source image up to some specified error. 


## Algorithm Steps
This simple implementation first creates a source image using MATLAB's "peaks" function and multiplying by periodic complex phase. Abs(src) shows the amplitude of the source image: 

<img src="imgs/src_abs_nf.png" width = "300">

Next the associated target image, abs(B), is found by Fourier transform,

<img src="imgs/trg_abs_ff.png" width = "300">

Lastly the "secret" complex phase of the source image is extracted, for comparison at the end,

<img src="imgs/src_angle.png" width = "300">

The Gerchberg-Saxton algorithm then begins, in an attempt to retrieve the "secret" phase map. First, ![\Large x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}](https://latex.codecogs.com/svg.latex?&space;A=\text{abs}(e^{i&space;\text{rand}(\phi)}) is calculated, where ![](https://latex.codecogs.com/svg.latex?&space;\text{rand}(\phi))  is an array of random phases:

<img src="imgs/A_iter1.png" width = "300">

then, ![](https://latex.codecogs.com/svg.latex?B=\text{abs}(\text{src})\cdot%20e^{i%20\text{arg}(A)}) 

<img src="imgs/B_iter1.png" width = "300">

then, ![](https://latex.codecogs.com/svg.latex?&space;C=\text{fft}(B)).

<img src="imgs/C_iter1.png" width = "300">

then, ![](https://latex.codecogs.com/svg.latex?&space;D=\text{abs}(\text{trg})\cdot%20e^{i%20\text{arg}(C)}) 

<img src="imgs/D_iter1.png" width = "300">

and then again A = ifft(D). The process is repeated until the difference between A for the current and previous step is less than some set threshold. 

abs(A) will begin to look more and more like the source image:

<div class="row">
  <div class="column">
    <img src="imgs/A_iter1.png" width = "280">
    <img src="imgs/A_iter2.png" width = "280">
    <img src="imgs/A_iter3.png" width = "280">
  </div>
  <div class="column">
    <img src="imgs/A_iter4.png" width = "280">
    <img src="imgs/A_iter5.png" width = "280">
    <img src="imgs/A_iter6.png" width = "280">
  </div>
  <div class="column">
    <img src="imgs/A_iter144.png" width = "280">
    <img src="imgs/A_iter741.png" width = "280">
    <img src="imgs/A_iter3361.png" width = "280">
  </div>
</div>

abs(C) will begin to look more and more like the target image:

<div class="row">
  <div class="column">
    <img src="imgs/C_iter1.png" width = "280">
    <img src="imgs/C_iter2.png" width = "280">
    <img src="imgs/C_iter3.png" width = "280">
  </div>
  <div class="column">
    <img src="imgs/C_iter4.png" width = "280">
    <img src="imgs/C_iter5.png" width = "280">
    <img src="imgs/C_iter6.png" width = "280">
  </div>
  <div class="column">
    <img src="imgs/C_iter143.png" width = "280">
    <img src="imgs/C_iter740.png" width = "280">
    <img src="imgs/C_iter3360.png" width = "280">
  </div>
</div>

and the phase will converge to some phase map resembling (though not necessarily exactly matching) the "secret" phase map:

<div class="row">
  <div class="column">
    <img src="imgs/src_angle_1.png" width = "280">
    <img src="imgs/src_angle_2.png" width = "280">
    <img src="imgs/src_angle_3.png" width = "280">
  </div>
  <div class="column">
    <img src="imgs/src_angle_4.png" width = "280">
    <img src="imgs/src_angle_5.png" width = "280">
    <img src="imgs/src_angle_6.png" width = "280">
  </div>
  <div class="column">
    <img src="imgs/src_angle_144.png" width = "280">
    <img src="imgs/src_angle_741.png" width = "280">
    <img src="imgs/src_angle_3361.png" width = "280">
  </div>
</div>

## Discussion
Why doesn't the phase necessarily exactly match the original "secret" phase? First, we began with a source image that had many symmetries in the amplitude. A source symmetric in amplitude (even if not symmetric in phase) will have degeneracies in the amplitude (though not phase!) of its Fourier transform. Because we're only starting with two amplitudes, (amplitude of target and amplitude of source), we cannot resolve the degeneracies. Because of these symmetries, our phase map will thus change when the random number generator for the initial random phase is seeded differently. Below is an example of the phase map produced when the random number generator is seeded with 1 (middle) and when the random number generator is seeded with 2 (on right), compared to the secret phase (on left).
<div class="row">
    <img src="imgs/src_angle.png" width = "280">
    <img src="imgs/src_angle_3361.png" width = "280">
    <img src="imgs/src_angle_3930_rng2.png" width = "280">
</div>

  
Second, there is always an overall freedom in global phase. One can use the wrap_phase function also defined in the script to experiment with this. Below is an example of the secret phase (on left), next to the phase found by the algorithm (middle) and the phase found by the algorithm, shifted by pi.  
<div class="row">
    <img src="imgs/src_angle.png" width = "300">
    <img src="imgs/src_angle_2588.png" width = "300">
    <img src="imgs/src_angle_pluspi2588.png" width = "300">
</div>

