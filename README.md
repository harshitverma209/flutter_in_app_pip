# In App PiP for Flutter

A Flutter Package to help easily implement in-app PiP(Picture in Picture) in a flutter application.
Written completely in dart. 

## Features

* Easily Implement PiP(Picture in Picture) in app.

* Navigatable PiP Widget which allows navigation inside the PiP Window.

* Automatically Handle showing different widgets in the original view when in pip and when not in pip.

* Provides the ability to update the size of the pip widget later after starting pip.


## Getting started

* Import the package.

* Replace your MaterialApp with PiPMaterialApp. 

* Optionally provide the pipHeight and pipWidth parameters. These correspond to the height and width of your pip widget.


## Usage

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
    pipWidget:PiPWidget(
      child: ChildWidget(),
      onPiPClose: (){
      //Handle closing events e.g. dispose controllers.
      
      },
      elevation: 10,        //Optional
      pipBorderRadius: 10,  //Optional
      )
);
```

Use `NavigatablePiPWidget` for Navigation inside the PiP Window e.g.

```dart
PictureInPicture.startPiP(
    pipWidget:NavigatablePiPWidget(
      child: ChildWidget(),
      onPiPClose: (){
      //Handle closing events e.g. dispose controllers.
      
      },
      elevation: 10,        //Optional
      pipBorderRadius: 10,  //Optional
      )
);
```


Additionally, you can also use `PiPCapableWidget` to handle the view changes in case of PiP start and stop e.g.

```dart
PiPCapableWidget(
    whileNotInPip: ChildToShowWhileNotInPiP(),
    whileInPip: ChildToShowWhileInPiP(),      //Optional
);
```

Update the size of the pip view like below:
```dart
PictureInPicture.updatePiPWindowSize(height: height, width: width);
```

## Note
That's it. Enjoy!
