(* Content-type: application/vnd.wolfram.cdf.text *)

(*** Wolfram CDF File ***)
(* http://www.wolfram.com/cdf *)

(* CreatedBy='Mathematica 13.0' *)

(***************************************************************************)
(*                                                                         *)
(*                                                                         *)
(*  Under the Wolfram FreeCDF terms of use, this file and its content are  *)
(*  bound by the Creative Commons BY-SA Attribution-ShareAlike license.    *)
(*                                                                         *)
(*        For additional information concerning CDF licensing, see:        *)
(*                                                                         *)
(*         www.wolfram.com/cdf/adopting-cdf/licensing-options.html         *)
(*                                                                         *)
(*                                                                         *)
(***************************************************************************)

(*CacheID: 234*)
(* Internal cache information:
NotebookFileLineBreakTest
NotebookFileLineBreakTest
NotebookDataPosition[      1088,         20]
NotebookDataLength[      4752,        113]
NotebookOptionsPosition[      5248,        108]
NotebookOutlinePosition[      5728,        128]
CellTagsIndexPosition[      5685,        125]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{
Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`tmax$$ = 30, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`tmax$$], 30, 40}}, Typeset`size$$ = {
    404., {269., 274.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = True}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, "Variables" :> {$CellContext`tmax$$ = 30}, 
      "ControllerVariables" :> {}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> Manipulate[
        Module[{$CellContext`sol$ = NDSolve[
            
            Join[$CellContext`RosslerEquations, {$CellContext`x[
               0] == $CellContext`x0, $CellContext`y[
               0] == $CellContext`y0, $CellContext`z[0] == $CellContext`z0}], {
             $CellContext`x[$CellContext`t], 
             $CellContext`y[$CellContext`t], 
             $CellContext`z[$CellContext`t]}, {$CellContext`t, 
             0, $CellContext`Tmax + 1}]}, $CellContext`pplot = 
          ParametricPlot3D[
            ReplaceAll[{
              $CellContext`x[$CellContext`t], 
              $CellContext`y[$CellContext`t], 
              $CellContext`z[$CellContext`t]}, $CellContext`sol$], \
{$CellContext`t, 0, $CellContext`tmax$$}, 
            AxesLabel -> {"x(t)", "y(t)", "z(t)"}, 
            PlotRange -> {{-$CellContext`rad, $CellContext`rad}, \
{-$CellContext`rad, $CellContext`rad}, {-$CellContext`rad, \
$CellContext`rad}}]; $CellContext`xplot = Plot[
            ReplaceAll[{
              $CellContext`x[$CellContext`t]}, $CellContext`sol$], \
{$CellContext`t, 0, $CellContext`tmax$$}, 
            AxesLabel -> {"t", "x(t)"}]; $CellContext`yplot = Plot[
            ReplaceAll[{
              $CellContext`y[$CellContext`t]}, $CellContext`sol$], \
{$CellContext`t, 0, $CellContext`tmax$$}, 
            AxesLabel -> {"t", "y(t)"}]; $CellContext`zplot = Plot[
            ReplaceAll[{
              $CellContext`z[$CellContext`t]}, $CellContext`sol$], \
{$CellContext`t, 0, $CellContext`tmax$$}, AxesLabel -> {"t", "z(t)"}]; 
         GraphicsGrid[{{$CellContext`pplot, SpanFromLeft, SpanFromLeft}, {
            SpanFromAbove, SpanFromBoth, SpanFromBoth}, {
            SpanFromAbove, SpanFromBoth, 
             SpanFromBoth}, {$CellContext`xplot, $CellContext`yplot, \
$CellContext`zplot}}]], {{$CellContext`x0, -1}, -5, 
         5}, {{$CellContext`y0, 0}, -5, 5}, {{$CellContext`z0, 1}, -5, 5}], 
      "Specifications" :> {{$CellContext`tmax$$, 30, 40, AnimationRunning -> 
         False, AppearanceElements -> {
          "ProgressSlider", "PlayPauseButton", "FasterSlowerButtons", 
           "DirectionButton"}}}, 
      "Options" :> {
       ControlType -> Animator, AppearanceElements -> None, DefaultBaseStyle -> 
        "Animate", DefaultLabelStyle -> "AnimateLabel", SynchronousUpdating -> 
        True, ShrinkingDelay -> 10.}, "DefaultOptions" :> {}],
     ImageSizeCache->{448., {306., 311.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    SynchronousInitialization->True,
    UndoTrackedVariables:>{Typeset`show$$, Typeset`bookmarkMode$$},
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Animate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output",ExpressionUUID->"87eb3955-\
bf6e-44c9-b872-0d333442f27f"]
},
Visible->True,
ScrollingOptions->{"VerticalScrollRange"->Fit},
ShowCellBracket->Automatic,
Deployed->True,
CellContext->Notebook,
TrackCellChangeTimes->False,
FrontEndVersion->"13.0 for Mac OS X ARM (64-bit) (December 2, 2021)",
StyleDefinitions->"Default.nb",
ExpressionUUID->"ca35be62-2d72-425c-b995-6cccdc757099"
]
(* End of Notebook Content *)

(* Internal cache information *)
(*CellTagsOutline
CellTagsIndex->{}
*)
(*CellTagsIndex
CellTagsIndex->{}
*)
(*NotebookFileOutline
Notebook[{
Cell[1488, 33, 3756, 73, 34, "Output",ExpressionUUID->"87eb3955-bf6e-44c9-b872-0d333442f27f"]
}
]
*)

(* End of internal cache information *)

(* NotebookSignature XuTbwcd7Zbqb5DKqB5u0Z#0Y *)
