# FRC-ABS: The FRC Alternative Build System
==========================================================================

Building can be time-consuming using the ant build system that is provided
to you because it copies over the exact same libraries every single time
you try to build as well as checking to see if the RoboRIO is up-to-date.
That, and the software bundle that's supported requires you to install a
massive and bloated text editor with oceans of drop-down menus that you
have to navigate just to build and deploy your code.

Naturally, you shouldn't have to re-initialize the RoboRIO every time you
want to make a change to the code. This build system gets rid of that
redundancy. It also means that you don't have to drain your laptop's
battery by running Eclipse or wait half a minute for your code to deploy.

Note: You must already have the native libraries on the RoboRIO. (They are
installed and reinstalled by Eclipse every time you deploy your code, so
if you have already built with Eclipse once, you don't have to copy over
the libraries and scripts in the Eclipse package to your PATH manually.
Once you have installed libraries and scripts through either of the
aforementioned means, you can use this build system as a replacement.)

Used in conjunction with QDriverStation (located at
https://github.com/FRC-Utilities/QDriverStation), you can eliminate the
need to do any of your testing on a Windows computer. Yay!

# Use
Before you begin, change the variables in Makefile and find_roborio.sh,
replacing the default team number with yours and ROBOT_CLASS with your
default class.

To compile and deploy your code, simply run "make". That's all there is to
it. Easy, right?

For ease of use, there are other make targets you can use. See the
Makefile for more details.
