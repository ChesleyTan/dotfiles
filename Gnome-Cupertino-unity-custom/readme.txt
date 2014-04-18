Gnome-Cupertino
Author: Rafa Cobreros rafacobreros@gmail.com
Redesigned for Ubuntu 14.04 by: Chesley Tan
License: GPL
Original theme in: 

Customization tips:
1.- Style for nautilus
2.- Style for titlebar buttons
3.- Style for tabs
4.- Fix Synaptic and/or Gimp buttons
5.- Enable/disable the use of the images .svg in checkbox/radiobuttons (GTK2)

NOTE:
	- Some changes require close and open session after them

------------------------------------------------
* 1.- Select style for nautilus and enviroment *
------------------------------------------------
Edit (gedit) the file ../Gnome-Cupertino/gtk-3.0/gtk.css

go to the last line of the file, there are seven options for nautilus:
	Nautilus 3.6.x for gnome-shell 3.6.x and/or unity (by default)
		@import url("nautilus36.css"); 

	(3 for gnome-shell)
	1.- "gnome-nautilus34-gray.css"  		(nautilus sidebar and toolbar dark gray)
	2.- "gnome-nautilus34-light.css" 		(nautilus sidebar and toolbar light)
	3.- "gnome-nautilus34-gray-light.css" (nautilus sidebar dark gray and toolbar light)

	(3 for UNITY)
	1.- "unity-nautilus34-gray.css"  		
	2.- "unity-nautilus34-light.css" 		
	3.- "unity-nautilus34-gray-light.css" 

edit (please carefully) the corresponding line "@import" according to the style of nautilus you want,
to make it ONE of the seven (not both)

@import url("nautilus36.css"); 
	or
@import url("gnome-nautilus34-gray.css");
	or
@import url("gnome-nautilus34-light.css"); 
	or
@import url("gnome-nautilus34-gray-light.css"); 
	or
@import url("unity-nautilus34-gray.css");
	or
@import url("unity-nautilus34-light.css"); 
	or
@import url("unity-nautilus34-gray-light.css"); 


-----------------------------------------
* 2.- Select style for titlebar buttons *
-----------------------------------------
If you prefer the buttons Lion style for titlebar:
Copy the contents of the file "metacity-lion-buttons.tar.gz" in folder .. /Gnome-Cupertino/metacity-1/

If you prefer the buttons Snow Leopard style for titlebar:
Copy the contents of the file "metacity-sl-buttons.tar.gz" in folder .. /Gnome-Cupertino/metacity-1/

also for unity if necessary:
"unity-lion-buttons.tar.gz" in folder .. /Gnome-Cupertino/unity/
or
"unity-sl-buttons.tar.gz" in folder .. /Gnome-Cupertino/unity/

------------------------------
* 3.- Select style for TABS *
------------------------------
Edit (gedit) the file ../Gnome-Cupertino/gtk-3.0/gtk.css

Go to the line where it says
@import url("tabs.css");

and modify it according to the option you want

1.- tabs dark gray (full)
@import url("tabs-dark.css");

2.- tabs themed blue (full)
@import url("tabs-themed.css");

3.- tabs with  blue highlight 
@import url("tabs.css");

4.- tabs with dark gray highlight
@import url("tabs-mono.css");

5.- more traditional style tabs
@import url("tabs-classic.css");

(Be careful to leave only ONE of the five)


----------------------------------------
* 4.- Fix Synaptic and/or Gimp buttons *
----------------------------------------
Note: I have not set by default because sacrifices appearance/quality of the radio-buttons in gtk2.

Edit (gedit) file:
/Gnome-Cupertino/gtk-2.0/gtkrc

Find the line (near end, about line 800):
widget_class "*<GtkRadioButton>*"				style:highest "radiobutton"

and replaced by:
widget_class "*<GtkRadioButton>*"				style:highest "checkradio"

-----------------------------------------------------------------------
5.- Enable/disable the use of the images .svg in checkbox/radiobuttons
-----------------------------------------------------------------------
Edit (gedit) file:
/Gnome-Cupertino/gtk-2.0/gtkrc
Find the section (near end, about line 800) and follow the instructions
##########################################################################
# Radiobutton and Checkbox
##########################################################################
# If you have problems displaying the checkbox or radio buttons in gtk2
# uncomment the two lines following (remove the # symbol of the beginning of the line)

# widget_class "*<GtkCheckButton>*"				style "checkradio"
# widget_class "*<GtkRadioButton>*"				style "checkradio"

# and comment on these (put the # symbol at the beginning of the line)
 widget_class "*<GtkCheckButton>*"				style "checkbutton"
 widget_class "*<GtkRadioButton>*" 				style "radiobutton"
##########################################################################

