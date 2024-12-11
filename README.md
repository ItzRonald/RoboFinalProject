Dear reader,
There are a lot of details that did not make it into the video or slides, so we figured that this document could explain the overall structure of our project.

To plug into the outlet, the OWI robot needs to be able to rotate the end effector left and right. If not, it would be constrained to always start directly in front of the outlet, which is unexciting. 
Therefore, we added Joint 5 to the robot, in place of the gripper. To guarantee that the end effector (the plug head) would always be horizontal, it meant that the xy-plane in Frame 5 also had to remain horizontal. 
To do this, we used the robot’s wrist (Joint 4) to cancel the angle created by the shoulder and elbow (Joints 2 and 3). To make insertion easier, we added a short prismatic joint (Joint 6), which inserts the plug directly into the outlet. 
To allow the robot to get feedback on its movements, a camera was mounted on Link 5, just behind the prismatic joint. 


The appendage was designed in Blender 3.4, printed on an Ender 3 V2, and uses MG90S servos. The gear teeth were modeled from a screenshot of an online gear generator. 
The lower gear was scaled to 400. Since linear gears are circular gears with infinite teeth, and 400 is basically infinity, this worked perfectly. The rest was done with a measuring tape, calipers, and iteration. 


Because we know that the OWI robot is imprecise, we planned out a multi-stage alignment process. Each stage is detailed in "notes.pdf" under "Movement procedures/algorithms."


Our code is designed in two parts. One part is the code that drives the robot joints, and the other part is the code that calculates the joint positions. 
The objective is to keep their development independent so that the calculating code could operate using a simple, idealized DH parameter model, while the driver code could be calibrated to precisely convert the DH parameters into real-life voltages (or PWM signals) 
for every joint to realize. The separation keeps the code modular and clean on both ends. We used Desmos to visualize the calibration data and found that everything could be adequately modeled with a linear model.


The AprilTag detection was hard to get working because most implementations are written for Linux operating systems. We found a Python library and programmed with it, although we discovered MATLAB libraries later. 
Our MATLAB code saves a camera frame, calls a Python script that analyses the image, and reads the results from a file. It is extremely inefficient, but if it ain’t broke, don’t fix it last minute.
Adding three lenses (a total of 4.75 diopters) to the webcam significantly reduced its field of view, and we suspect that this led to numerical instability in the calibration script. 
The higher the focal length, the harder it is to detect perspective, and therefore distance, especially with human-introduced errors in measurement and mouse-clicking. 
This is why we believe that the calibration was about 8 cm off. Surprisingly, the image was barely distorted at all by the unplanned optical assembly.

Thank you for reading,
    -Team 8
