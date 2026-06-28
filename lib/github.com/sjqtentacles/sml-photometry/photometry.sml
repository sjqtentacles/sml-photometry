structure Photometry :> PHOTOMETRY =
struct
  fun log10 x = Math.ln x / Math.ln 10.0

  (* CIE 1931 photopic V(lambda): wavelength 380-780nm step 10nm, 41 values *)
  val photopicTable : (real * real) list = [
    (380.0e~9, 0.000039), (390.0e~9, 0.000120), (400.0e~9, 0.000396),
    (410.0e~9, 0.001210), (420.0e~9, 0.004000), (430.0e~9, 0.011600),
    (440.0e~9, 0.023000), (450.0e~9, 0.038000), (460.0e~9, 0.060000),
    (470.0e~9, 0.090980), (480.0e~9, 0.139020), (490.0e~9, 0.208020),
    (500.0e~9, 0.323000), (510.0e~9, 0.503000), (520.0e~9, 0.710000),
    (530.0e~9, 0.862000), (540.0e~9, 0.954000), (550.0e~9, 0.994950),
    (560.0e~9, 0.995000), (570.0e~9, 0.952000), (580.0e~9, 0.870000),
    (590.0e~9, 0.757000), (600.0e~9, 0.631000), (610.0e~9, 0.503000),
    (620.0e~9, 0.381000), (630.0e~9, 0.265000), (640.0e~9, 0.175000),
    (650.0e~9, 0.107000), (660.0e~9, 0.061000), (670.0e~9, 0.032000),
    (680.0e~9, 0.017000), (690.0e~9, 0.008200), (700.0e~9, 0.004102),
    (710.0e~9, 0.002091), (720.0e~9, 0.001047), (730.0e~9, 0.000520),
    (740.0e~9, 0.000249), (750.0e~9, 0.000120), (760.0e~9, 0.000060),
    (770.0e~9, 0.000030), (780.0e~9, 0.000015)
  ]

  fun interpolateV lam =
    let
      fun interp [] = 0.0
        | interp [_] = 0.0
        | interp ((l0, v0) :: (rest as (l1, v1) :: _)) =
            if lam < l0 then 0.0
            else if lam <= l1 then
              v0 + (v1 - v0) * (lam - l0) / (l1 - l0)
            else interp rest
    in
      case photopicTable of
        [] => 0.0
      | ((l0, v0) :: _) =>
          if lam < l0 then 0.0
          else interp photopicTable
    end

  fun luminousEfficacy lam = 683.0 * interpolateV lam

  fun radiometricToPhotometric {wavelengthM, watts} =
    luminousEfficacy wavelengthM * watts

  fun illuminancePointSource {candela, distanceM} =
    candela / (distanceM * distanceM)

  fun distanceModulus dPc =
    5.0 * log10 (dPc / 10.0)

  fun fluxRatioFromMagnitudes {m1, m2} =
    Math.pow (10.0, ~0.4 * (m1 - m2))

  fun magnitudeDifference fluxRatio =
    2.5 * log10 fluxRatio
end
