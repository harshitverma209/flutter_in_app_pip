## 1.7.2
* Hotfix: PiPMaterialApp Not working due to typo.

## 1.7.1
* Fixes to PiPMaterialApp.router(still experimental).

## 1.7.0
* Upgraded package to Flutter 3.7.3.
* Added all updated parameters from MaterialApp to PiPMaterialApp.
* Added PiPMaterialApp.router(experimental) for usage of Go Router and similar navigator v2 packages.

## 1.6.0
* Added ability to make the PIP non-movable. Use `movable:false` in `PIPParams`.
* Added ability to make the pip resizable(via pinch in/out). Use `resizable:true` in `pipParams`. Additionally, you can also specify the minSize and maxSize for the PIP window.
* Added ability to specify the initial corner for the PIP Window. 

## 1.5.0
* Minor Fixes.

## 1.4.0
* Fixed a major bug where turning pip on/off or updating it caused the whole MaterialApp to rebuild.
* Fixed a bug where in some cases, updatePipParams was giving 'markNeedsRebuild' error.

## 1.3.0
* Added ability to set borders to which pip window can be dragged.
* Added pipParams instead of pipWindowHeight and pipWindowWidth and added more parameters(customizability).

## 1.2.0
* Removed unnecessary Navigator that was behaving as root navigator.
* Added NavigatablePiPWidget which allows navigation inside the PiP Window.

## 1.1.0
* Added ability to use builder in PiPMaterialApp.
* Fixed a major bug where clicks near the boundary were not getting recognized in pip.
* Added borderRadius and elevation parameters to PiPWidget.
* Updated ReadMe.

## 1.0.0
* Initial Release
