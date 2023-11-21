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
NotebookDataLength[      3169,         84]
NotebookOptionsPosition[      3665,         79]
NotebookOutlinePosition[      4145,         99]
CellTagsIndexPosition[      4102,         96]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{
Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`p$$ = {{-1, 0}, {1, 
    0}}, $CellContext`q1$$ = -1, $CellContext`q2$$ = 1, Typeset`show$$ = True,
     Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{{
       Hold[$CellContext`q1$$], -1}, -3, 3}, {{
       Hold[$CellContext`q2$$], 1}, -3, 3}, {{
       Hold[$CellContext`p$$], {{-1, 0}, {1, 0}}}, {-1, -1}, {1, 1}}}, 
    Typeset`size$$ = {360., {178., 183.}}, Typeset`update$$ = 0, 
    Typeset`initDone$$, Typeset`skipInitDone$$ = True}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, 
      "Variables" :> {$CellContext`p$$ = {{-1, 0}, {1, 
         0}}, $CellContext`q1$$ = -1, $CellContext`q2$$ = 1}, 
      "ControllerVariables" :> {}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> 
      ContourPlot[$CellContext`q1$$/
         Norm[{$CellContext`x, $CellContext`y} - 
          Part[$CellContext`p$$, 1]] + $CellContext`q2$$/
         Norm[{$CellContext`x, $CellContext`y} - 
          Part[$CellContext`p$$, 2]], {$CellContext`x, -2, 
         2}, {$CellContext`y, -2, 2}], 
      "Specifications" :> {{{$CellContext`q1$$, -1}, -3, 
         3}, {{$CellContext`q2$$, 1}, -3, 
         3}, {{$CellContext`p$$, {{-1, 0}, {1, 0}}}, {-1, -1}, {1, 1}, 
         ControlType -> Locator}}, "Options" :> {}, "DefaultOptions" :> {}],
     ImageSizeCache->{410., {240., 245.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    SynchronousInitialization->True,
    UndoTrackedVariables:>{Typeset`show$$, Typeset`bookmarkMode$$},
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Manipulate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output",ExpressionUUID->"a5d21707-\
1c03-488c-b8be-bd91a2c91246"]
},
Visible->True,
ScrollingOptions->{"VerticalScrollRange"->Fit},
ShowCellBracket->Automatic,
Deployed->True,
CellContext->Notebook,
TrackCellChangeTimes->False,
FrontEndVersion->"13.0 for Mac OS X ARM (64-bit) (December 2, 2021)",
StyleDefinitions->"Default.nb",
ExpressionUUID->"8ab274ef-d03e-453b-9871-75f7e413b48a"
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
Cell[1488, 33, 2173, 44, 34, "Output",ExpressionUUID->"a5d21707-1c03-488c-b8be-bd91a2c91246"]
}
]
*)

(* End of internal cache information *)

(* NotebookSignature 3uDdjuemrzd4DB1gbmcWlg7x *)
