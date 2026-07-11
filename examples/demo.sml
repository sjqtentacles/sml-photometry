(* demo.sml - photometric and astronomical brightness calculations: luminous
   efficacy, radiometric-to-photometric conversion, inverse-square illuminance,
   and magnitude/flux relations. Deterministic: fixed literal inputs, identical
   output on every run and both compilers. *)

structure P = Photometry

fun fmt n x =
  let val x = if Real.== (x, 0.0) then 0.0 else x
  in Real.fmt (StringCvt.FIX (SOME n)) x
  end

val () = print "Photometry worked example\n"

val () = print "\nLuminous efficacy V(lambda) * 683 lm/W:\n"
val () =
  List.app
    (fn (label, lam) =>
       print ("  lambda = " ^ label ^ " -> "
              ^ fmt 4 (P.luminousEfficacy lam) ^ " lm/W\n"))
    [("555nm", 555.0e~9), ("507nm", 507.0e~9), ("650nm", 650.0e~9)]

val () = print "\nRadiometric to photometric conversion (1 W at 555nm):\n"
val lum = P.radiometricToPhotometric {wavelengthM = 555.0e~9, watts = 1.0}
val () = print ("  " ^ fmt 4 lum ^ " lm\n")

val () = print "\nPoint-source illuminance (inverse square law, I = 100 cd):\n"
val () =
  List.app
    (fn d =>
       print ("  d = " ^ fmt 1 d ^ " m -> "
              ^ fmt 6 (P.illuminancePointSource {candela = 100.0, distanceM = d})
              ^ " lux\n"))
    [1.0, 2.0, 10.0]

val () = print "\nDistance modulus (m - M):\n"
val () =
  List.app
    (fn dPc =>
       print ("  d = " ^ fmt 1 dPc ^ " pc -> mu = "
              ^ fmt 4 (P.distanceModulus dPc) ^ " mag\n"))
    [10.0, 136.0, 1000.0]

val () = print "\nFlux ratio from magnitude difference:\n"
val () = print ("  m1=0.0 m2=5.0 -> F1/F2 = "
                ^ fmt 4 (P.fluxRatioFromMagnitudes {m1=0.0, m2=5.0}) ^ "\n")
val () = print ("  m1=0.0 m2=2.5 -> F1/F2 = "
                ^ fmt 4 (P.fluxRatioFromMagnitudes {m1=0.0, m2=2.5}) ^ "\n")

val () = print "\nMagnitude difference from flux ratio:\n"
val () = print ("  ratio = 100.0 -> delta_m = "
                ^ fmt 4 (P.magnitudeDifference 100.0) ^ "\n")
val () = print ("  ratio = 2.512 -> delta_m = "
                ^ fmt 4 (P.magnitudeDifference 2.512) ^ "\n")
