Storyline 2 SDK
=============

##Introduction
The Storyline 2 SDK consists of documentation, interfaces, and sample code that demonstrate how to customize the player that surrounds your Storyline slide content, referred to as the frame.

##Flash Document
The included Flash® document was created in Adobe® Flash® Professional CS6 and saved as an uncompressed document (.xfl). It is located in the folder named [CustomFrame](https://github.com/articulate/storyline-sdk/tree/v2.0/CustomFrame).

###Document Library
The library is divided into four main folders (assets, components, panels, and windows). All the graphical assets for the sample frame are contained within these folders.
 
####assets
The assets folder contains the common visual elements that are used within the project.

####components
The components folder contains the basic controls that are used on the frame such as buttons, scrollbars, etc.

####panels
Located within the panels folder are the containers used to display the Menu, Glossary, Notes, and Resources as well as the sidebar and tab control used to navigate between these panels.

####window
The window folder contains the windows used for displaying lightboxed slides, system messages (such as the resume prompt), as well as the slide container and background.

##ActionScript Source
All ActionScript used in the sdk is located in the [src](https://github.com/articulate/storyline-sdk/tree/v2.0/src) folder. Here you will find two additional folders, [customframe](https://github.com/articulate/storyline-sdk/tree/v2.0/src/customframe) and [com/articulate/wg/v3_0](https://github.com/articulate/storyline-sdk/tree/v2.0/src/com/articulate/wg/v3_0). 

####customframe
The [customframe](https://github.com/articulate/storyline-sdk/tree/v2.0/src/customframe) folder contains the source files that provide the logic for the sample frame. The source files are organized into sub-folders and structured similarly to the library contained within CustomFrame.xfl.

####com/articulate/wg/v3_0
The folder [com/articulate/wg/v3_0](https://github.com/articulate/storyline-sdk/tree/v2.0/src/com/articulate/wg/v3_0) contains the interface and event classes that define the interface used to communicate with Articulate Storyline flash runtime.

##Documentation
Documentation for the interface and event classes is located in the [Documentation](https://github.com/articulate/storyline-sdk/tree/v2.0/Documentation) folder. The documentation can be viewed by opening [index.html](https://rawgithub.com/articulate/storyline-sdk/v2.0/Documentation/index.html) within your browser.

##Using Your Custom Frame
To use your completed frame, rename your swf to frame.swf, navigate to the story_content folder located in your Storyline published output folder and replace the existing frame.swf in the story_content folder with your custom version.

##Notes
Many of the library symbols rely on the AS source files contained in the src folder. The package structure of these source files mimic the folder structure of the library. (You can tell which symbols have associated AS class files by looking at the “AS Linkage” column in the library.)

The sample frame included in this SDK does not implement the following features that are available in the stock Articulate frame:

- Accessibility Support
- Custom color schemes
- Custom text strings
- Right-to-left text support
- Custom fonts
- Search

Although these feature have not been implementented in the SDK example, all the interfaces are defined to allow you to add them to your own custom frame.
