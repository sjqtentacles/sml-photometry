# sml-photometry

Zero-dependency Standard ML library for photometric and astronomical brightness calculations.

## API

```sml
signature PHOTOMETRY =
sig
  val luminousEfficacy : real -> real               (* wavelength m -> lm/W *)
  val radiometricToPhotometric : {wavelengthM:real, watts:real} -> real  (* lumens *)
  val illuminancePointSource   : {candela:real, distanceM:real} -> real  (* lux *)

  val distanceModulus         : real -> real         (* pc -> mag *)
  val fluxRatioFromMagnitudes : {m1:real, m2:real} -> real
  val magnitudeDifference     : real -> real         (* flux ratio -> delta_m *)
end
```

## Worked example

```sml
(* Luminous efficacy at green peak (~555 nm) *)
val eff = Photometry.luminousEfficacy 555.0e~9
(* ~683 lm/W *)

(* Distance modulus to the Pleiades (~136 pc) *)
val mu = Photometry.distanceModulus 136.0
(* ~5.67 mag *)

(* Flux ratio corresponding to 5 magnitude difference *)
val r = Photometry.fluxRatioFromMagnitudes {m1=0.0, m2=5.0}
(* 100.0 *)
```

## Scope and limitations

- CIE 1931 photopic V(λ) table uses 10 nm steps (380–780 nm) with linear interpolation.
- Does not model scotopic (night) vision or mesopic conditions.
- Magnitude calculations use the Pogson scale; no bolometric correction or filter bandpasses.
- No colour science (XYZ, chromaticity) — see sml-colorsci.

## Build and test

Requires [MLton](http://mlton.org/) and Poly/ML in PATH.

```
make all-tests
```
