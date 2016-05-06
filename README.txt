README
The project contains three basic parts - GraphCUT, Catalogue Images and User Interface

Build-
Step 1 - Unzip the folder searchGUI
Step 2 - Launch MATLAB and open folder containing searchGUI
Step 3 - type compile in the command window. 

The command window should display 'Build Complete' at the end of successfull built

Using searchGUI-
1. Four windows Open up - 'controlGUI', 'Query Image', 'Result Images', 'Distance Results'. 
2. Press Train - To Train the model on images in the 'Training' Folder.  These training images must have nearly white background with only one object of interest on it.
3. Press Load Image - to select an image conatining article with white background as a query Image. 
The nearest image matches are displayed in 'Result Images' window. 
4. Crop - Prompts the user to select an image. After selection opens a window and asks the user to draw a rectangle over the article
The user should press and hold primary mouse click to draw a rectangle which is used as a query image 
5. GraphCUT - pops up a new window and asks the user to select an image using the button 'Open'. Draw a polygon after clicking Mark Polygon Button on the image.
Double click on the image to finalize the region. Press Run to extract the region from image. The extracted image is used as a query for search
6. Reset - Used to reset the 'results Image' window