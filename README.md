# sml-photometry

[![CI](https://github.com/sjqtentacles/sml-photometry/actions/workflows/ci.yml/badge.svg)](https://github.com/sjqtentacles/sml-photometry/actions/workflows/ci.yml)

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

## Example

`make example` builds and runs [`examples/demo.sml`](examples/demo.sml), which
computes luminous efficacy, radiometric-to-photometric conversion,
inverse-square illuminance, and distance-modulus/magnitude-flux relations for
a handful of fixed inputs (output is byte-identical under MLton and Poly/ML):

```
Photometry worked example

Luminous efficacy V(lambda) * 683 lm/W:
  lambda = 555nm -> 679.5679 lm/W
  lambda = 507nm -> 306.6670 lm/W
  lambda = 650nm -> 73.0810 lm/W

Radiometric to photometric conversion (1 W at 555nm):
  679.5679 lm

Point-source illuminance (inverse square law, I = 100 cd):
  d = 1.0 m -> 100.000000 lux
  d = 2.0 m -> 25.000000 lux
  d = 10.0 m -> 1.000000 lux

Distance modulus (m - M):
  d = 10.0 pc -> mu = 0.0000 mag
  d = 136.0 pc -> mu = 5.6677 mag
  d = 1000.0 pc -> mu = 10.0000 mag

Flux ratio from magnitude difference:
  m1=0.0 m2=5.0 -> F1/F2 = 100.0000
  m1=0.0 m2=2.5 -> F1/F2 = 10.0000

Magnitude difference from flux ratio:
  ratio = 100.0 -> delta_m = 5.0000
  ratio = 2.512 -> delta_m = 1.0000
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
