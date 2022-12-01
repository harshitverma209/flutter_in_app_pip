<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
# In App PiP for Flutter

<!-- TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them. -->

A Flutter Package to help easily implement in-app PiP(Picture in Picture) in a flutter application.
Written completely in dart. 


## Features

<!-- TODO: List what your package can do. Maybe include images, gifs, or videos. -->

Easily Implement PiP(Picture in Picture) in app.

Automatically Handle showing different widgets in the original view when in pip and when not in pip.

Provides the ability to update the size of the pip widget later after starting pip.


## Getting started

<!-- TODO: List prerequisites and provide or point to information on how to
start using the package. -->

Import the package.

Replace your MaterialApp with PiPMaterialApp. 

Optionally provide the pipHeight and pipWidth parameters. These correspond to the height and width of your pip widget.


## Usage

<!-- TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. -->

After replacing your MaterialApp with PiPMaterialApp, use 

```dart
 PictureInPicture.startPiP(pipWidget: MyPiPWidget());
```

to start PiP view in your app.

When you wish to stop PiP, use

```dart
PictureInPicture.stopPiP();
```

Use `PiPWidget` for additional functionalities like handling events on close of pip e.g.

```dart
PictureInPicture.startPiP(
    pipWidget:PiPWidget(child: ChildWidget(),onPiPClose: (){
      //Handle closing events e.g. dispose controllers.
      
    },)
);
```

Additonally, you can also use `PiPCapableWidget` to handle the view changes in case of PiP start and stop e.g.

```dart
PiPCapableWidget(
    whileNotInPip: ChildToShowWhileNotInPiP(),
    whileInPip: ChildToShowWhileInPiP(),
);
```

Update the size of the pip view like below:
```dart
PictureInPicture.updatePiPWindowSize(height: height, width: width);
```



## Note

Please do not use the builder property of the PiPMarterialApp.

That's it. Enjoy!

<!-- TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more. -->
