##########################################################################
#                                                                        #
#  Copyright (C) 2017  Lukas Yoder                                       #
#                                                                        #
#  This program is free software: you can redistribute it and/or modify  #
#  it under the terms of the GNU General Public License as published by  #
#  the Free Software Foundation, either version 3 of the License, or     #
#  (at your option) any later version.                                   #
#                                                                        #
#  This program is distributed in the hope that it will be useful,       #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#  GNU General Public License for more details.                          #
#                                                                        #
#  You should have received a copy of the GNU General Public License     #
#  along with this program.  If not, see <http://www.gnu.org/licenses/>. #
#                                                                        #
#  Makefile: this is the FRC Alternative Build System (FRC-ABS)          #
#                                                                        #
##########################################################################


IP=`bash find_roborio.sh`

PACKAGE=org.usfirst.frc.team1683.robot
ROBOT_CLASS=$(PACKAGE).TechnoTitan

NOCHK=-q -o StrictHostKeyChecking=no 
ROBORIO_USER=lvuser
ROBORIO_USER_PASS=""
ROBORIO_ADMIN=admin
ROBORIO_ADMIN_PASS=""

ROBOT_COMMAND="/usr/local/frc/bin/netconsole-host                        \
              /usr/local/frc/JRE/bin/java                                \
              -Djava.library.path=/usr/local/frc/lib/ -jar               \
              /home/lvuser/FRCUserProgram.jar"

DEPLOY_KILL_COMMAND=". /etc/profile.d/natinst-path.sh &&                 \
                    /usr/local/frc/bin/frcKillRobot.sh -t -r"

all: deploy

find:
	@echo $(IP)

clean:
	@find src -name "*.class" -exec rm {} +
	@rm -rf build dist

compile: clean
	@mkdir -p build
	@javac `find src -name "*.java" -printf "%p "` -cp                     \
	`find lib -name "*.jar" -printf "%p:"` -Xlint:deprecation

jar: compile
	@mkdir -p dist
	@mkdir -p build/jars
	@cp `find lib -iname "wpilib.jar" -printf "%p " -or -iname             \
	    "networktables.jar" -printf "%p "` build/jars
	@echo "Main-Class: edu.wpi.first.wpilibj.RobotBase" > build/MANIFEST.MF
	@echo "Robot-Class: $(ROBOT_CLASS)" >> build/MANIFEST.MF
	@echo "Class-Path: ." >> build/MANIFEST.MF
	@jar -cvmf build/MANIFEST.MF dist/FRCUserProgram.jar                   \
	     `find src -name "*.class" -printf "%p "` build/jars/*

deploy: jar 
	@sshpass -p $(ROBORIO_USER_PASS) scp $(NOCHK) dist/FRCUserProgram.jar  \
	            $(ROBORIO_USER)@$(IP):/home/$(ROBORIO_USER)
	@ # Killing the netconsole-host and suppressing its output
	@sshpass -p $(ROBORIO_ADMIN_PASS) ssh $(NOCHK) $(ROBORIO_ADMIN)@$(IP)  \
	         -t "ldconfig && killall -q netconsole-host || :"
	@sshpass -p $(ROBORIO_USER_PASS) ssh $(NOCHK) $(ROBORIO_USER)@$(IP)    \
	         -t "$(DEPLOY_KILL_COMMAND) && sync"

# vim:ts=2:sw=2:nospell
