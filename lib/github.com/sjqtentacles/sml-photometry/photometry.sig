signature PHOTOMETRY =
sig
  (* Luminous efficacy (lm/W) at wavelength (meters): 683 * V(lambda)
     where V(lambda) is the CIE 1931 photopic luminous efficiency function *)
  val luminousEfficacy : real -> real

  (* Convert spectral radiant flux to luminous flux *)
  val radiometricToPhotometric : {wavelengthM:real, watts:real} -> real  (* lumens *)

  (* Point source illuminance (lux): E = I/d^2 (I in candela, d in meters) *)
  val illuminancePointSource : {candela:real, distanceM:real} -> real

  (* Distance modulus: m - M = 5 * log10(distancePc / 10) *)
  val distanceModulus : real -> real  (* distancePc -> magnitude difference *)

  (* Flux ratio from magnitude difference: F1/F2 = 10^(-0.4*(m1-m2)) *)
  val fluxRatioFromMagnitudes : {m1:real, m2:real} -> real

  (* Magnitude difference from flux ratio *)
  val magnitudeDifference : real -> real  (* fluxRatio -> delta_m *)
end
