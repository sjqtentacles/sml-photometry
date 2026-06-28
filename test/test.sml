structure Tests =
struct
  open Harness
  fun close name (e, a, eps) = check name (Real.abs (e - a) <= eps)

  fun run () =
  let
    val () = section "luminous efficacy"
    (* Peak is near 555nm; table has 550 and 560 both near 1.0 *)
    val eff555 = Photometry.luminousEfficacy 555.0e~9
    val () = check "efficacy at 555nm > 670 lm/W" (eff555 > 670.0)
    val eff700 = Photometry.luminousEfficacy 700.0e~9
    val () = check "efficacy at 700nm < 10 lm/W" (eff700 < 10.0)
    val () = check "efficacy at 700nm > 0" (eff700 > 0.0)

    val () = section "distance modulus"
    val () = close "dist mod at 10pc = 0" (0.0, Photometry.distanceModulus 10.0, 1e~9)
    val () = close "dist mod at 100pc = 5" (5.0, Photometry.distanceModulus 100.0, 1e~9)
    val () = close "dist mod at 1000pc = 10" (10.0, Photometry.distanceModulus 1000.0, 1e~9)

    val () = section "flux ratio <-> magnitude"
    val r = Photometry.fluxRatioFromMagnitudes {m1=0.0, m2=5.0}
    val () = close "5 mags = 100x flux" (100.0, r, 1e~6)
    val dm = Photometry.magnitudeDifference 100.0
    val () = close "mag diff from flux 100 = 5" (5.0, dm, 1e~9)
    val r2 = Photometry.fluxRatioFromMagnitudes {m1=0.0, m2=dm}
    val () = close "flux ratio round-trip" (100.0, r2, 1e~6)

    val () = section "illuminance"
    val () = close "illuminance 1cd/1m = 1lux" (1.0,
               Photometry.illuminancePointSource {candela=1.0, distanceM=1.0}, 1e~12)
    val () = close "illuminance at 2m = 0.25lux" (0.25,
               Photometry.illuminancePointSource {candela=1.0, distanceM=2.0}, 1e~12)

  in Harness.run () end
end
